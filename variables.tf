
/*
these come from terraform.tfvars
See:  https://nickcharlton.net/posts/terraform-aws-vpc.html
*/
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_key_path" {}
variable "aws_key_name" {}

variable "env" {
  description = "The environment type."
  default = "production"
}

variable "ecs_cluster_name" {
    description = "The name of the Amazon ECS cluster."
    default = "microservices"
}

variable "connection_user" {
    default = "ubuntu"
    description = "Ubuntu SSH user"
}

variable "region"     {
  description = "AWS region"
  default     = "us-east-1"
}

variable "aws_az"     {
  description = "AWS availability zone"
  default     = "us-east-1a"
}

variable "vpc_cidr" {
  description = "CIDR for VPC"
  default     = "10.1.0.0/16"
}

/*
 Ubuntu amis by region
 https://cloud-images.ubuntu.com/locator/ec2/

 ECS container optimized AMIs
 http://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html

 WATCH OUT! Amazon changes the AMIs from time to time. Be sure to double check the
 ECS optimized AMI number.
*/
variable "amis" {
  default = {
    ubuntu-16 = "ami-13be557e"
    amazon-nat = "ami-bae80fd7"
    amazon-ecs-optimized = "ami-8f7687e2"
  }
}

variable "public_subnet_cidr" {
  default = "10.1.0.0/25"
}

variable "private_subnet_cidr" {
  default = "10.1.0.128/25"
}

variable "subnet_letters" {
  default = {
    "0" = "a"
  }
}

/* For the ECS cluster */
variable "autoscale_min" {
    default = "1"
    description = "Minimum autoscale (number of EC2 instances)"
}

variable "autoscale_max" {
    default = "10"
    description = "Maximum autoscale (number of EC2 instances)"
}

variable "autoscale_desired" {
    default = "2"
    description = "Desired autoscale (number of EC2 instances)"
}