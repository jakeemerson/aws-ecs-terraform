variable "ecs_cluster_id" {}
variable "ecs_cluster_name" {}
variable "vpc_id" {}
variable "aws_key_name" {}
variable "app_name" {}
variable "task_def_filename" {}
variable "public_subnet_ids" {}
variable "private_subnet_ids" {}
variable "policy_attachment" {}
variable "elb_security_groups" {}
variable "ecs_service_iam_role" {}
variable "launch_configuration_iam_instance_profile" {}
variable "launch_configuration_security_groups" {}
variable "autoscale_min" { default = 1 }
variable "autoscale_max" { default = 10 }
variable "autoscale_desired" { default = 2 }
variable "app_test_target" {}
variable "app_container_exposed_port" { default = "8000" }
variable "app_elb_port" { default = "80" }

/*
 Ubuntu amis by region
 https://cloud-images.ubuntu.com/locator/ec2/

 ECS container optimized AMIs
 http://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html
*/
variable "amis" {
  default = {
    ubuntu-16 = "ami-13be557e"
    amazon-nat = "ami-bae80fd7"
    amazon-ecs-optimized = "ami-8f7687e2"
  }
}
