# vpc creation
resource "aws_vpc" "appVPC" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "appVPC"
  }
}

#public subnet1
resource "aws_subnet" "publicSubnet1" {
  vpc_id            = aws_vpc.appVPC.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "publicSubnet1"
  }
}

#public subnet2
resource "aws_subnet" "publicSubnet2" {
  vpc_id            = aws_vpc.appVPC.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "publicSubnet2"
  }
}

# public route table
resource "aws_route_table" "publicRouteTable" {
  vpc_id = aws_vpc.appVPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "publicRouteTable"
  }
}


#public route table assosiations
resource "aws_route_table_association" "publicRouteTableAssosiation1" {
  subnet_id      = aws_subnet.publicSubnet1.id
  depends_on     = [aws_route_table.publicRouteTable]
  route_table_id = aws_route_table.publicRouteTable.id
}
resource "aws_route_table_association" "publicRouteTableAssosiation2" {
  subnet_id      = aws_subnet.publicSubnet2.id
  depends_on     = [aws_route_table.publicRouteTable]
  route_table_id = aws_route_table.publicRouteTable.id
}


#private subnet1 for app
resource "aws_subnet" "privateSubnet1" {
  vpc_id            = aws_vpc.appVPC.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "privateSubnet1"
  }
}

#private subnet2
resource "aws_subnet" "privateSubnet2" {
  vpc_id            = aws_vpc.appVPC.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "privateSubnet2"
  }
}


#private subnet3 for RDS
resource "aws_subnet" "privateSubnet3" {
  vpc_id            = aws_vpc.appVPC.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "privateSubnet3"
  }
}


#private subnet4
resource "aws_subnet" "privateSubnet4" {
  vpc_id            = aws_vpc.appVPC.id
  cidr_block        = "10.0.6.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "privateSubnet4"
  }
}

# routetable for private subnets
resource "aws_route_table" "privateRouteTable" {
  vpc_id = aws_vpc.appVPC.id
  tags = {
    Name = "privateRouteTable"
  }
}

# routetable for private subnets for RDS
resource "aws_route_table" "privateRouteTableRDS" {
  vpc_id = aws_vpc.appVPC.id
  tags = {
    Name = "privateRouteTable"
  }
}



#private route table assosiations
resource "aws_route_table_association" "privateRouteTableAssosiation1" {
  subnet_id      = aws_subnet.privateSubnet1.id
  depends_on     = [aws_route_table.privateRouteTable]
  route_table_id = aws_route_table.privateRouteTable.id
}
resource "aws_route_table_association" "privateRouteTableAssosiation2" {
  subnet_id      = aws_subnet.privateSubnet2.id
  depends_on     = [aws_route_table.privateRouteTable]
  route_table_id = aws_route_table.privateRouteTable.id
}
resource "aws_route_table_association" "privateRouteTableAssosiation3" {
  subnet_id      = aws_subnet.privateSubnet3.id
  depends_on     = [aws_route_table.privateRouteTableRDS]
  route_table_id = aws_route_table.privateRouteTableRDS.id
}
resource "aws_route_table_association" "privateRouteTableAssosiation4" {
  subnet_id      = aws_subnet.privateSubnet4.id
  depends_on     = [aws_route_table.privateRouteTableRDS]
  route_table_id = aws_route_table.privateRouteTableRDS.id
}

# internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.appVPC.id

  tags = {
    Name = "igw"
  }
}
