provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "pinFinalSG" {
  name = var.name_sg
  vpc_id = aws_vpc.vpc

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/24"]  
  }
  ingress  {
    description = "trafico web"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/24"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "PinFinal-SG"
  }
}

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.name
  }
}

resource "aws_subnet" "subnets" {
  count      = 3
  vpc_id     = aws_vpc.vpc.id
  cidr_block = element(var.subnet_CIDR, count.index) 
  tags = {
    Name = "subnet-${count.index + 1}"
  }
}
