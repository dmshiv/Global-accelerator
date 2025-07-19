// 4 creating pub and private route tables 

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.create_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.create_igw.id
  }

  tags = {
    Name = "ireland-public-rt"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.create_vpc.id

  tags = {
    Name = "ireland-private-rt"
  }
}
