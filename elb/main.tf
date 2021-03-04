resource "aws_lb" "mastercard-alb" {
  name               = "lb-${var.short_region}-${var.environment}-${var.service_name}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = aws_subnet.public.*.id

  enable_deletion_protection = true

  access_logs {
    bucket  = aws_s3_bucket.lb_logs.bucket
    prefix  = "test-lb"
    enabled = true
  }

  tags = {
    Environment = "production"
  }
}

# Create a new load balancer attachment
resource "aws_autoscaling_attachment" "mastercard-asg-attachment" {
  autoscaling_group_name = var.asg_id
  elb                    = aws_lb.mastercard-alb.id
}