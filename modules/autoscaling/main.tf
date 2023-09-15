output "autoscaling_arn" {
  value = aws_autoscaling_group.autoscaling_group.arn
}

resource "aws_launch_template" "launch_template" {
  name          = var.launch_template_name
  image_id      = "ami-0ae451dcc36be7bb3"
  instance_type = "t2.micro"
  key_name      = var.key_name
  iam_instance_profile {
    arn = "arn:aws:iam::${var.account}:instance-profile/ecsInstanceRole"
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.application.id]
  }

  user_data = base64encode(data.template_file.user_data.rendered)
}

data "template_file" "user_data" {
  template = file("${path.module}/userdata/application")
  vars = {
    ecs_cluster_name = var.ecs_cluster_name
  }
}

resource "aws_security_group" "application" {
  description = var.security_group_application
  vpc_id      = var.vpc_id
  name        = var.security_group_application
  tags = {
    Name = var.security_group_application
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }

  ingress {
    cidr_blocks      = ["0.0.0.0/0"]
    from_port        = "22"
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = false
    to_port          = "22"
  }
}

resource "aws_autoscaling_group" "autoscaling_group" {
  name                = var.autoscaling_group_name
  vpc_zone_identifier = [var.public_subnet-a_id, var.public_subnet-c_id]
  max_size            = "1"
  min_size            = "1"
  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = var.ecs_instance_name
    propagate_at_launch = true
  }
}