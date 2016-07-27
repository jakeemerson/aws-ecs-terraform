output "load_balancer_dns_name" {
  value = "${aws_elb.app.dns_name}"
}

output "launch_security_groups" {
  value = "${var.launch_configuration_security_groups}"
}