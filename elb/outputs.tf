output "dns_name" {
  value = "${aws_lb.mhdemo-alb.dns_name}"
}

output "elb_id" {
  value = "${aws_lb.mhdemo-alb.id}"
}
