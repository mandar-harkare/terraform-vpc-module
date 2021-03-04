data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"] # Canonical
}

resource "aws_efs_file_system" "mastercard-log-volume" {
  creation_token = "ebs-lc-${var.short_region}-${var.environment}-${var.service_name}"
  encrypted      = "true"
}

resource "aws_launch_configuration" "mastercard-launch-config" {
  name_prefix   = "lc-${var.short_region}-${var.environment}-${var.service_name}"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  user_data     = "${file("../install_apache.sh")}"

  dynamic "root_block_device" {
    content {
      delete_on_termination = "true"
      encrypted             = "true"
    }
  }

  dynamic "ebs_block_device" {
    content {
      delete_on_termination = "true"
      device_name           = ebs_block_device.value.device_name
      encrypted             = "true"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "mastercard-asg" {
  name                 = "asg-${var.short_region}-${var.environment}-${var.service_name}"
  launch_configuration = aws_launch_configuration.mastercard-launch-config.name
  min_size             = 1
  max_size             = 2

  lifecycle {
    create_before_destroy = true
  }
}