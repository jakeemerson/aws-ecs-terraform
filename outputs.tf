//output "bastion.hostname" {
//  value = "${module.vpc.bastion_ip}"
//}

output "graphite_load_balancer" {
  value = "${module.graphite-app.load_balancer_dns_name}"
}

output "typeform_load_balancer" {
  value = "${module.typeform-app.load_balancer_dns_name}"
}