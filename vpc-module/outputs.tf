output "id" {
  value = "${aws_vpc.default.id}"
}

output "public_subnet_ids" {
  value = "${join(",", aws_subnet.public.*.id)}"
}

output "private_subnet_ids" {
  value = "${join(",", aws_subnet.private.*.id)}"
}

//output "bastion_hostname" {
//  value = "${aws_instance.bastion.public_dns}"
//}
//
//output "bastion_security_group_id" {
//  value = "${aws_security_group.bastion.id}"
//}

output "cidr_block" {
  value = "${var.cidr_block}"
}

//output "bastion_ip" {
//  value = "${aws_instance.bastion.public_ip}"
//}

output "elb_security_groups" {
  value = [
    "${aws_security_group.allow_cluster.id},${aws_security_group.allow_all_inbound.id},${aws_security_group.allow_all_outbound.id}"
  ]
}

output "launch_configuration_security_groups" {
  value = "${aws_security_group.allow_all_ssh.id},${aws_security_group.allow_all_outbound.id},${aws_security_group.allow_all_inbound.id},${aws_security_group.allow_cluster.id}"
}

output "ecs_service_iam_role" {
  value = "${aws_iam_role.ecs_elb.arn}"
}

output "launch_configuration_iam_instance_profile" {
  value = "${aws_iam_instance_profile.ecs.id}"
}

# See: https://github.com/hashicorp/terraform/issues/1178
output "policy_attachment" {
  value = "${null_resource.dummy_policy_dependency.id}"
}

