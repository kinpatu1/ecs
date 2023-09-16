output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_id_1" {
  value = element(aws_subnet.public_subnet.*.id, 1)
}

output "public_subnet_id_2" {
  value = element(aws_subnet.public_subnet.*.id, 2)
}

output "private_subnet_id_1" {
  value = element(aws_subnet.private_subnet.*.id, 1)
}

output "private_subnet_id_2" {
  value = element(aws_subnet.private_subnet.*.id, 2)
}

####################
#vpc 
####################

resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_vpc
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = var.igw_name
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = var.public_subnet_id

  tags = {
    Name = var.nat_gateway_name
  }
}

resource "aws_eip" "nat_gateway" {
  vpc = true
}

####################
#public_subnet
####################

resource "aws_subnet" "public_subnet" {
  count             = length(var.cidr_public)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.cidr_public, count.index)
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name = "${var.subnet_name}-public-${count.index + 1}"
  }
}

resource "aws_route_table" "public_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.route_table_name}-public"
  }
}

resource "aws_route_table_association" "tableassociation_public" {
  count          = length(var.cidr_public)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public_table.id
}

####################
#private_subnet
####################

resource "aws_subnet" "private_subnet" {
  count             = length(var.cidr_private)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.cidr_private, count.index)
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name = "${var.subnet_name}-private-${count.index + 1}"
  }
}

resource "aws_route_table" "private_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "${var.route_table_name}-private"
  }
}

resource "aws_route_table_association" "tableassociation_private" {
  count          = length(var.cidr_private)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.private_table.id
}

####################
#s3_endpoint
####################

resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id       = aws_vpc.vpc.id
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

resource "aws_vpc_endpoint_route_table_association" "tableassociation_s3" {
  route_table_id  = aws_route_table.public_table.id
  vpc_endpoint_id = aws_vpc_endpoint.s3_endpoint.id
}