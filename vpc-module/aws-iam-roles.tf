
resource "aws_iam_role" "ecs_host_role" {
  name = "ecs_host_role"
  assume_role_policy = "${file("${path.module}/policies/ecs-role.json")}"
}

resource "aws_iam_policy_attachment" "ecs_for_ec2" {
  name = "ecs-for-ec2"
  roles = ["${aws_iam_role.ecs_host_role.id}"]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role" "ecs_elb" {
  name = "ecs-elb"
  assume_role_policy = "${file("${path.module}/policies/elb-role.json")}"
}

resource "aws_iam_policy_attachment" "ecs_elb" {
  name = "ecs_elb"
  roles = ["${aws_iam_role.ecs_elb.id}"]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

resource "aws_iam_instance_profile" "ecs" {
  name = "ecs_profile"
  path = "/"
  roles = ["${aws_iam_role.ecs_host_role.name}"]
}


