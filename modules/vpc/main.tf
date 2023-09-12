output "project_vpc_id" {
  value = aws_vpc.project_vpc.id
}

output "project_subnet_public_id_1" {
  value = element(aws_subnet.project_subnet_public.*.id, 1)
}

output "project_subnet_public_id_2" {
  value = element(aws_subnet.project_subnet_public.*.id, 2)
}

output "project_subnet_private_id_1" {
  value = element(aws_subnet.project_subnet_private.*.id, 1)
}

output "project_subnet_private_id_2" {
  value = element(aws_subnet.project_subnet_private.*.id, 2)
}

resource "aws_vpc" "project_vpc" {
  cidr_block = var.cidr_vpc
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "project_igw" {
  vpc_id = aws_vpc.project_vpc.id
  tags = {
    Name = var.igw_name
  }
}

resource "aws_subnet" "project_subnet_public" {
  count             = length(var.cidr_public)
  vpc_id            = aws_vpc.project_vpc.id
  cidr_block        = element(var.cidr_public, count.index)
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name = "${var.subnet_name}-public-${count.index + 1}"
  }
}

resource "aws_route_table" "project_public_table" {
  vpc_id = aws_vpc.project_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.project_igw.id
  }

  tags = {
    Name = "${var.route_table_name}-public"
  }
}

resource "aws_route_table_association" "project_tableassociation_public" {
  count          = length(var.cidr_public)
  subnet_id      = element(aws_subnet.project_subnet_public.*.id, count.index)
  route_table_id = aws_route_table.project_public_table.id
}

resource "aws_vpc_endpoint_route_table_association" "public_s3" {
  route_table_id  = aws_route_table.project_public_table.id
  vpc_endpoint_id = aws_vpc_endpoint.s3_endpoint.id
}

resource "aws_subnet" "project_subnet_private" {
  count             = length(var.cidr_private)
  vpc_id            = aws_vpc.project_vpc.id
  cidr_block        = element(var.cidr_private, count.index)
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name = "${var.subnet_name}-private-${count.index + 1}"
  }
}

resource "aws_route_table" "project_private_table" {
  vpc_id = aws_vpc.project_vpc.id

  tags = {
    Name = "${var.route_table_name}-private"
  }
}

resource "aws_route_table_association" "project_tableassociation_private" {
  count          = length(var.cidr_private)
  subnet_id      = element(aws_subnet.project_subnet_private.*.id, count.index)
  route_table_id = aws_route_table.project_private_table.id
}

resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id       = aws_vpc.project_vpc.id
  service_name = "com.amazonaws.ap-northeast-1.s3"
  policy       = <<POLICY
    {
	      "Version": "2008-10-17",
        "Statement": [
            {
                "Action": "*",
                "Effect": "Allow",
                "Resource": "*",
                "Principal": "*"
            }
        ]
    }
    POLICY

  tags = {
    Name = var.s3endpoint_name
  }
}