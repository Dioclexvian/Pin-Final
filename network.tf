#VPC PIN GRUPO 10 

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = var.name
  }
}


resource "aws_subnet" "subnet_public1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = element(var.subnet_CIDR,0)
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.name}-sub-1"
  } 
}

resource "aws_subnet" "subnet_private1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = element(var.subnet_CIDR,1)
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.name}-sub-2"
  } 
}


resource "aws_subnet" "subnet_private2" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = element(var.subnet_CIDR,2)
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.name}-sub-3"
  } 
}

resource "aws_subnet" "subnet_private3" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = element(var.subnet_CIDR,3)
  availability_zone = "us-east-1c"
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.name}-sub-4"
  } 
}

resource "aws_subnet" "subnet_public2" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = element(var.subnet_CIDR,4)
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.name}-sub-5"
  } 
}

resource "aws_subnet" "subnet_public3" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = element(var.subnet_CIDR,5)
  availability_zone = "us-east-1c"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.name}-sub-6"
  } 
}

#Internet GW Publica subnet publica
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id  #attach con el igw?
  tags = {
    Name = "${var.name}-igw"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.name}-public-route-table"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0" #destino está bien así
  gateway_id             = aws_internet_gateway.igw.id 
}

resource "aws_route_table_association" "public1_route_table" {
  subnet_id      = aws_subnet.subnet_public1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public2_route_table" {
  subnet_id      = aws_subnet.subnet_public2.id
  route_table_id = aws_route_table.public_route_table.id
}