output "aws_region" {
  value = "${var.aws_region}"
}

output "dns_name" {
  value = "${module.elb.dns_name}"
}