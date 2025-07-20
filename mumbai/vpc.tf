// creating vpc 1

resource "aws_vpc" "create_vpc" {
  cidr_block = var.gives_cidr_to_vpc

  tags = {
    Name = "mumbai-vpc"
  }

  # provider = aws.eu-central-1  # Uncomment if you have a specific provider configuration

}
