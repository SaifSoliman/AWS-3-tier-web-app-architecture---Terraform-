
#Bastion Host
resource "aws_instance" "bastion_host" {
  ami             = "ami-0427090fd1714168b"
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.publicSubnet1.id
  security_groups = [aws_security_group.bastionHost_sg.name]

  tags = {
    Name = "bastion-host"
  }
}