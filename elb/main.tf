resource "aws_lb" "mhdemo_alb" {
  name               = "lb-${var.short_region}-${var.environment}-${var.service_name}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.public_sg_id]
  subnets            = var.public_subnet_ids
  # cross_zone_load_balancing   = true
  enable_deletion_protection = false

  # access_logs {
  #   bucket  = aws_s3_bucket.lb_logs.bucket
  #   prefix  = "test-lb"
  #   enabled = true
  # }

  tags = var.aws_tags
}

resource "aws_lb_target_group" "mhdemo_alb_target_group" {  
  name     = "lb-tg-${var.short_region}-${var.environment}-${var.service_name}"
  port     = "80"  
  protocol = "HTTP"  
  vpc_id   = var.vpc_id
  # tags {    
  #   name = "lb-tg-${var.short_region}-${var.environment}-${var.service_name}"
  # }   
  
  health_check {    
    healthy_threshold   = 3    
    unhealthy_threshold = 10    
    timeout             = 5    
    interval            = 10    
    path                = "/"    
    port                = "80"  
  }
}

resource "aws_lb_listener" "mhdemo_alb_listener" {  
  load_balancer_arn = aws_lb.mhdemo_alb.arn
  port              = "80"  
  protocol          = "HTTP"
  
  default_action {    
    target_group_arn = aws_lb_target_group.mhdemo_alb_target_group.arn
    type             = "forward"  
  }
}

#Autoscaling Attachment
resource "aws_autoscaling_attachment" "mhdemo_alb_attachment" {
  alb_target_group_arn   = aws_lb_target_group.mhdemo_alb_target_group.arn
  autoscaling_group_name = var.asg_id
}

# Create a new load balancer attachment
# resource "aws_autoscaling_attachment" "mhdemo_asg_attachment" {
#   autoscaling_group_name = var.asg_id
#   elb                    = aws_lb.mhdemo_alb.id
# }