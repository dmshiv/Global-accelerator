// 4 creating 2 route tables and associating them with the vpc and internet gateway


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.create_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.create_igw.id
  }

  tags = {
    Name = "mumbai-public-rt"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.create_vpc.id

  tags = {
    Name = "mumbai-private-rt"
  }
}
