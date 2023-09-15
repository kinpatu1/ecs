####################
#ec2
####################

resource "aws_instance" "gateway" {
  subnet_id                   = var.subnet_id
  ami                         = "ami-0f89bdd365c3d966d"
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  key_name                    = var.key_name
  vpc_security_group_ids = [
    aws_security_group.gateway.id
  ]
  root_block_device {
    volume_type = "gp2"
    volume_size = 8
    tags = {
      Name = var.ebs_name
    }
  }

  tags = {
    Name = var.ec2_name
  }
}

resource "aws_security_group" "gateway" {
  description = var.security_group_gateway
  vpc_id      = var.vpc_id
  name        = var.security_group_gateway
  tags = {
    Name = var.security_group_gateway
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