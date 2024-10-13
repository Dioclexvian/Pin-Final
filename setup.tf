provider "aws" {
  region = "us-east-1"
}

#key pem EC2

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

#key pem cluster

resource "tls_private_key" "cluster_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "cluster_key" {
  key_name   = "cluster-key-${random_string.cluster_key_suffix.result}"
  public_key = tls_private_key.cluster_ssh_key.public_key_openssh
}

resource "random_string" "cluster_key_suffix" {
  length  = 8
  special = false
}

output "cluster_private_key_pem" {
  value     = tls_private_key.cluster_ssh_key.private_key_pem
  sensitive = true
}

#security group

resource "aws_security_group" "pinFinalSG" {
  name = var.name_sg
  vpc_id = aws_vpc.vpc.id

  ingress {
    description = "conexion ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }
  ingress {
    description = "conexion http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }
    ingress {
    description = "conexion http x2"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }
  ingress {
    description = "conexion https"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }
  ingress {
    description = "conexion eks"
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }
  egress  {
    description = "servicio web"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    egress  {
    description = "servicio web x2"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress  {
    description = "servicio web curl y eks cluster traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "servicio web curl y eks cluster traffic"
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # egress {
  #   from_port   = 0
  #   to_port     = 0
  #   protocol    = "-1"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }
  tags = {
    Name = "PinFinal-SG"
  }
}