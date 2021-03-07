data "aws_ami_ids" "ubuntu" {
  owners          = ["099720109477"]
  sort_ascending  = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

resource "aws_launch_configuration" "mhdemo_launch_config" {
  name_prefix     = "lc-${var.short_region}-${var.environment}-${var.service_name}"
  image_id        = element(data.aws_ami_ids.ubuntu.ids, 0)
  instance_type   = "t2.micro"
  user_data       = file("install_apache.sh")
  security_groups = [var.private_sg_id]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "mhdemo_asg" {
  name                  = "asg-${var.short_region}-${var.environment}-${var.service_name}"
  launch_configuration  = aws_launch_configuration.mhdemo_launch_config.name
  min_size              = 1
  desired_capacity      = 2
  max_size              = 4
  vpc_zone_identifier   = var.private_subnet_ids

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_policy" "mhdemo_asg_policy" {
  name                   = "asg-pol-${var.short_region}-${var.environment}-${var.service_name}"
  scaling_adjustment     = 2
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.mhdemo_asg.name
}

resource "aws_cloudwatch_metric_alarm" "mhdemo_cloudwatch_alarm" {
  alarm_name          = "alarm-${var.short_region}-${var.environment}-${var.service_name}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.mhdemo_asg.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.mhdemo_asg_policy.arn]
}
