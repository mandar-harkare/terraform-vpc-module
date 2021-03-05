resource "aws_lb" "mhdemo-alb" {
  name               = "lb-${var.short_region}-${var.environment}-${var.service_name}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.public_sg_id]
  subnets            = var.public_subnet_ids
  # cross_zone_load_balancing   = true
  enable_deletion_protection = true

  # access_logs {
  #   bucket  = aws_s3_bucket.lb_logs.bucket
  #   prefix  = "test-lb"
  #   enabled = true
  # }

  tags = var.aws_tags
}

# Create a new load balancer attachment
# resource "aws_autoscaling_attachment" "mhdemo-asg-attachment" {
#   autoscaling_group_name = var.asg_id
#   elb                    = aws_lb.mhdemo-alb.id
# }