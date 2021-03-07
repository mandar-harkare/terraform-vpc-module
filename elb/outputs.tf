output "dns_name" {
  value = aws_lb.mhdemo_alb.dns_name
}

output "elb_id" {
  value = aws_lb.mhdemo_alb.id
}
