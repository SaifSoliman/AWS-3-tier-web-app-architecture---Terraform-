# web tier ec2 1
resource "aws_instance" "webServer1" {
  ami               = "ami-0427090fd1714168b"
  instance_type     = "t2.micro"
  depends_on        = [aws_vpc.appVPC, aws_subnet.publicSubnet1, aws_security_group.public_sg]
  subnet_id         = aws_subnet.publicSubnet1.id
  security_groups   = [aws_security_group.public_sg.id]
  availability_zone = "us-east-1a"
  tenancy           = "default"

  tags = {
    Name = "webServer1"
  }
}

# web tier ec2 2
resource "aws_instance" "webServer2" {
  ami               = "ami-0427090fd1714168b"
  instance_type     = "t2.micro"
  depends_on        = [aws_vpc.appVPC, aws_subnet.publicSubnet2, aws_security_group.public_sg]
  subnet_id         = aws_subnet.publicSubnet2.id
  security_groups   = [aws_security_group.public_sg.id]
  availability_zone = "us-east-1b"
  tenancy           = "default"

  tags = {
    Name = "webServer2"
  }
}

# Private instance 1 
resource "aws_instance" "Application_Instance1" {
  ami             = "ami-0427090fd1714168b"
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.privateSubnet1.id
  security_groups = [aws_security_group.privateInstance_sg.name]

  tags = {
    Name = "Application_Instance1"
  }
}

# Private instance 2
resource "aws_instance" "Application_Instance2" {
  ami             = "ami-0427090fd1714168b"
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.privateSubnet2.id
  security_groups = [aws_security_group.privateInstance_sg.name]

  tags = {
    Name = "Application_Instance2"
  }
}



