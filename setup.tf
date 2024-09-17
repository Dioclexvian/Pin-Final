provider "aws" {
  region = "us-east-1"
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "deployer_key" {
  key_name   = "deployer-key-${random_string.key_suffix.result}"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "random_string" "key_suffix" {
  length  = 8
  special = false
}

resource "aws_security_group" "pinFinalSG" {
  name = var.name_sg
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }
  ingress  {
    description = "trafico web"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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

# resource "aws_vpc" "vpc" {
#   cidr_block = var.vpc_cidr
#   tags = {
#     Name = var.name
#   }
# }

# resource "aws_subnet" "subnets" {
#   count      = 3
#   vpc_id     = aws_vpc.vpc.id
#   cidr_block = element(var.subnet_CIDR, count.index) 
#   tags = {
#     Name = "subnet-${count.index + 1}"
#   }
# }
