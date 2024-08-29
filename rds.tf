##############################Second Layer Done################################

# RDS SecurityGroup
resource "aws_security_group" "rds_sg" {
  vpc_id = aws_vpc.appVPC.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] #Same as VPC CIDR
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-sg"
  }
}

# Define the DB Subnet Group
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds_subnet_group"
  subnet_ids = [aws_subnet.privateSubnet3.id]

  tags = {
    Name = "rds_subnet_group"
  }
}

# Define RDS
resource "aws_db_instance" "RDS-Instance-DB-Layer" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  multi_az               = false
  publicly_accessible    = false

  tags = {
    Name = "RDS-Instance-DB-Layer"
  }
}
