/*
 App setup
*/

resource "aws_elb" "app" {
  name = "${var.app_name}-app-elb"
  subnets = ["${var.public_subnet_ids}"]
  connection_draining = true
  cross_zone_load_balancing = true
  security_groups = ["${var.elb_security_groups}"]

  listener {
    lb_protocol = "http"
    lb_port = "${var.app_elb_port}"
    instance_protocol = "http"
    instance_port = "${var.app_container_exposed_port}"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 10
    timeout = 15
    target = "${var.app_test_target}"
    interval = 20
  }

  tags {
    Name = "${var.app_name}-app-elb"
    policy_attachment = "${var.policy_attachment}"
  }
}

resource "aws_ecs_task_definition" "app" {
  family = "${var.app_name}-app"
  container_definitions = "${file(var.task_def_filename)}"
  lifecycle { create_before_destroy = true }
}

resource "aws_ecs_service" "app" {
  name = "${var.app_name}-service"
  cluster = "${var.ecs_cluster_id}"
  task_definition = "${aws_ecs_task_definition.app.arn}"
  iam_role = "${var.ecs_service_iam_role}"
  desired_count = 2

  load_balancer {
    elb_name = "${aws_elb.app.name}"
    container_name = "${var.app_name}-app"
    container_port = "${var.app_container_exposed_port}"
  }
}

/*
 Load balancer setup
*/


/*
  Template for initial configuration bash script
  See: http://docs.aws.amazon.com/AmazonECS/latest/developerguide/start_task_at_launch.html
*/
resource "template_file" "template" {
  template = "${file("${path.module}/cloud-config/ecs.template")}"

  vars {
    cluster_name = "${var.ecs_cluster_name}"
    task_definition = "${aws_ecs_task_definition.app.id}"
    app_name= "${var.app_name}"
  }

  lifecycle { create_before_destroy = true }
}

/* EC2 Instances that run docker containers */
resource "aws_launch_configuration" "config" {
  image_id = "${lookup(var.amis, "amazon-ecs-optimized")}"
  instance_type = "t2.micro"
  security_groups = ["${var.launch_configuration_security_groups}"]
  iam_instance_profile = "${var.launch_configuration_iam_instance_profile}"
  key_name = "${var.aws_key_name}"
  associate_public_ip_address = true
  user_data = "${template_file.template.rendered}"
  lifecycle { create_before_destroy = true }
}

resource "aws_autoscaling_group" "asg" {
  name = "${var.ecs_cluster_name}-${var.app_name}"
  vpc_zone_identifier = ["${var.public_subnet_ids}"]
  min_size = "${var.autoscale_min}"
  max_size = "${var.autoscale_max}"
  desired_capacity = "${var.autoscale_desired}"
  health_check_type = "EC2"
  launch_configuration = "${aws_launch_configuration.config.name}"
  load_balancers = ["${aws_elb.app.name}"]
}

