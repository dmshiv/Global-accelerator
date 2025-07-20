// 7 creating 2 instances in the first and second subnet with 2 different userdata script to install httpd and display public and private IPs


resource "aws_instance" "create_instance" {
  count = length(var.gives_cidr_to_subnets)

  # Instance Configuration
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.create_subnet[count.index].id
  key_name               = "my-ec2-key"
  vpc_security_group_ids = [aws_security_group.create_security_group.id]

  associate_public_ip_address = count.index == 0 ? true : false


  // installing user data script to install httpd only on public instance 

  user_data = count.index == 0 ? file("${path.module}/user_script.sh") : null


  # Enhanced Dependencies
  depends_on = [
    aws_security_group.create_security_group,
    aws_internet_gateway.create_igw, # Explicit dependency
    aws_subnet.create_subnet         # Explicit dependency
  ]

  # Tags
  tags = {
    Name = count.index == 0 ? "mum-EC2-p6766" : "mumbai-EC2-ppp1"
    Type = count.index == 0 ? "Public" : "Private"
  }
}
