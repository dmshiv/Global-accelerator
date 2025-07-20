//3 creating internet gateway
resource "aws_internet_gateway" "create_igw" {
  vpc_id = aws_vpc.create_vpc.id

  tags = {
    Name = "ireland-igw-pub"
  }

  # provider = aws.eu-central-1  # Uncomment if you have a specific provider configuration

}
