resource "aws_ecs_cluster" "main" {
  name = "microservices"
}

/* Setup our aws provider */
provider "aws" {
  access_key  = "${var.aws_access_key}"
  secret_key  = "${var.aws_secret_key}"
  region      = "${var.region}"
}

module "vpc" {
  source = "./vpc-module"

  name = "simple-vpc"
  region = "us-east-1"
  key_name = "bdn"
  cidr_block = "10.1.0.0/16"
  external_access_cidr_block = "0.0.0.0/0"
  private_subnet_cidr_blocks = "10.1.0.128/25"
  public_subnet_cidr_blocks = "10.1.0.0/25"
//  public_subnet_cidr_blocks = "10.0.0.0/24,10.0.2.0/24"
  availability_zones = "us-east-1a"
//  availability_zones = "us-east-1a,us-east-1b"
  bastion_ami = "ami-ff02509a"
  bastion_instance_type = "t2.micro"
}

module "graphite-app" {
  source = "./app-module"

  ecs_cluster_id = "${aws_ecs_cluster.main.id}"
  ecs_cluster_name = "${aws_ecs_cluster.main.name}"
  vpc_id = "${module.vpc.id}"
  aws_key_name = "bdn"
  app_name = "graphite"
  task_def_filename = "task-definitions/graphite-app.json"
  policy_attachment = "${module.vpc.policy_attachment}"
  public_subnet_ids = "${module.vpc.public_subnet_ids}"
  private_subnet_ids = "${module.vpc.private_subnet_ids}"
  elb_security_groups = "${split(",", module.vpc.elb_security_groups)}"
  ecs_service_iam_role = "${module.vpc.ecs_service_iam_role}"
  launch_configuration_iam_instance_profile = "${module.vpc.launch_configuration_iam_instance_profile}"
  launch_configuration_security_groups = "${split(",", module.vpc.launch_configuration_security_groups)}"
  app_test_target = "HTTP:80/"
  app_container_exposed_port = "80"
  app_elb_port = "80"


}

module "typeform-app" {
  source = "./app-module"

  ecs_cluster_id = "${aws_ecs_cluster.main.id}"
  ecs_cluster_name = "${aws_ecs_cluster.main.name}"
  vpc_id = "${module.vpc.id}"
  aws_key_name = "bdn"
  app_name = "typeform"
  task_def_filename = "task-definitions/typeform-app.json"
  policy_attachment = "${module.vpc.policy_attachment}"
  public_subnet_ids = "${module.vpc.public_subnet_ids}"
  private_subnet_ids = "${module.vpc.private_subnet_ids}"
  elb_security_groups = "${split(",", module.vpc.elb_security_groups)}"
  ecs_service_iam_role = "${module.vpc.ecs_service_iam_role}"
  launch_configuration_iam_instance_profile = "${module.vpc.launch_configuration_iam_instance_profile}"
  launch_configuration_security_groups = "${split(",", module.vpc.launch_configuration_security_groups)}"
  app_test_target = "HTTP:8000/typeform/"
  app_container_exposed_port = "8000"
  app_elb_port = "80"


}

