// 7 creating 2 instance one is pub and another is private 

resource "aws_instance" "create_instance" {
  count                  = length(var.gives_cidr_to_subnets)
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = "t2.micro"
  key_name               = "my-ec2-key" # Replace with your key pair name
  vpc_security_group_ids = [aws_security_group.create_security_group.id]
  subnet_id              = aws_subnet.create_subnet[count.index].id

  // user_script.sh must be installed only on public instance
  user_data = count.index == 0 ? file("${path.module}/user_script.sh") : null

  // assign public ip only to public instance
  associate_public_ip_address = count.index == 0 ? true : false
  tags = {
    Name = count.index == 0 ? "ireland-EC2-pub34" : "ireland-EC2-private12"
    Type = count.index == 0 ? "Public" : "Private"
  }

  // provider = aws.eu-central-1  # Uncomment if you have a specific provider configuration



}


