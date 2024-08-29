#Private Instance SG
resource "aws_security_group" "privateInstance_sg" {
  vpc_id = aws_vpc.appVPC.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
  }

  tags = {
    Name = "privateInstance_sg"
  }
}


# Security group for Public Instances
resource "aws_security_group" "public_sg" {
  name        = "public-sg"
  description = "allow public access for instances "
  vpc_id      = aws_vpc.appVPC.id

  # Allow inbound HTTP from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow inbound SSH from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "public_sg"
  }
}


# Layer 1 AutoScailingGroup- Security Group
resource "aws_security_group" "ASG-SecurityGroup" {
  name        = "ASG-SecurityGroup"
  description = "allow HTTP requests"
  vpc_id      = aws_vpc.appVPC.id

  # Allow inbound HTTP from anywhere
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.allow_http_WebLB.id]
  }
  ingress {
    description = "Allow SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ASG-SecurityGroup"
  }
}

# Layer 2 AutoScailingGroup- Security Group
resource "aws_security_group" "ASG-SecurityGroupAPP" {
  name        = "ASG-SecurityGroup"
  description = "allow HTTP requests"
  vpc_id      = aws_vpc.appVPC.id

  # Allow inbound HTTP from anywhere
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.AppLb_sg.id]
  }
  ingress {
    description     = "Allow SSH from anywhere"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.AppLb_sg.id]
  }


  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ASG-SecurityGroup"
  }
}


# SG for Web LB
resource "aws_security_group" "allow_http_WebLB" {
  name        = "allow_http"
  description = "Allow http traffic"
  vpc_id      = aws_vpc.appVPC.id
  ingress {
    description = "Allow HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow_http_AWebLB"
  }
}


# SG for App LoadBalancer in Layer 2
resource "aws_security_group" "AppLb_sg" {
  vpc_id = aws_vpc.appVPC.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"] #needs to be modified as needed
    security_groups = [aws_security_group.ASG-SecurityGroup.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "AppLb_sg"
  }
}






# Bastion Host SG
resource "aws_security_group" "bastionHost_sg" {
  vpc_id = aws_vpc.appVPC.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #needs to be edit to allow only inbound from the same VPC
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastionHost_sg"
  }
}
