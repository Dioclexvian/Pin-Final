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



resource "aws_security_group" "ec2_sg" {
  name   = var.name
  vpc_id = aws_vpc.vpc
}