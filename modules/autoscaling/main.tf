resource "aws_launch_template" "launch_template" {
  name                   = var.launch_template_name
  image_id               = "ami-0ae451dcc36be7bb3"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.application.id]
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
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = ["${var.security_group_ec2}"]
  }
}