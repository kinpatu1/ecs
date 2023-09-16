resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = var.public_subnet_id

  tags = {
    Name = var.nat_gateway_name
  }
}

resource "aws_eip" "nat_gateway" {
  vpc = true

  tags {
    Name = var.eip_name
  }
}