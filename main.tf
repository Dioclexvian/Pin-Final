# variable "aws-access-key-id" {}
# variable "aws-secret-access-key" {}
 
#  resource "aws_instance" "Ubuntu-PinFinal" {
#   ami           = "ami-0a0e5d9c7acc336f1"  
#   instance_type = "t2.micro"
#   vpc_security_group_ids = [aws_security_group.pinFinalSG.id]
#   key_name = aws_key_pair.deployer_key.key_name
#   associate_public_ip_address = true 
#   subnet_id = aws_subnet.subnet_public1.id
#   # iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name
#   user_data = <<-EOF
#     #!/bin/bash
#     # Exporta las claves como variables de entorno
#     export SECRET_KEY=${var.aws-access-key-id}
#     export ANOTHER_SECRET=${var.aws-secret-access-key} 
    
#     # Ejecuta el script de instalación
#     $(cat ${file("instalacionProgramas.sh")})

#     # Ejecuta el script para instalar EKS y crear el clúster
#     chmod +x ${file("eksInstall.sh")}
#     bash ${file("eksInstall.sh")}

#   EOF

#   tags = {
#     Name = "server-Pin-Final"
#   }

# }

# Provider configuration
provider "aws" {
  region = "us-east-1"
}

# VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/21"
  
  tags = {
    Name = "MundosE-Grupo10-VPC"
    grupo = "grupo10"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "MundosE-Grupo10-IGW"
    grupo = "grupo10"
  }
}

# Subnets
resource "aws_subnet" "public" {
  count                   = 3
  vpc_id                  = aws_vpc.main.id
  cidr_block              = ["10.0.0.0/23", "10.0.2.0/23", "10.0.4.0/23"][count.index]
  availability_zone       = ["us-east-1a", "us-east-1b", "us-east-1c"][count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "MundosE-Grupo10-Public-Subnet-${count.index + 1}"
    grupo = "grupo10"
  }
}

resource "aws_subnet" "private" {
  count             = 3
  vpc_id            = aws_vpc.main.id
  cidr_block        = ["10.0.1.0/23", "10.0.3.0/23", "10.0.5.0/23"][count.index]
  availability_zone = ["us-east-1a", "us-east-1b", "us-east-1c"][count.index]

  tags = {
    Name = "MundosE-Grupo10-Private-Subnet-${count.index + 1}"
    grupo = "grupo10"
  }
}

# Route Table for Public Subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "MundosE-Grupo10-Public-RT"
    grupo = "grupo10"
  }
}

resource "aws_route_table_association" "public" {
  count          = 3
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Security Group
resource "aws_security_group" "main" {
  name        = "MundosE-Grupo10-SG"
  description = "Security group for EC2 instances"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
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
    Name = "MundosE-Grupo10-SG"
    grupo = "grupo10"
  }
}

# EC2 Instance
resource "aws_instance" "main" {
  ami           = "ami-0261755bbcb8c4a84"  # Ubuntu 20.04 LTS in us-east-1
  instance_type = "t2.micro"
  key_name      = aws_key_pair.main.key_name
  subnet_id     = aws_subnet.public[0].id
  vpc_security_group_ids = [aws_security_group.main.id]

  user_data = file("install-programs.sh")

  tags = {
    Name = "MundosE-Grupo10-EC2"
    grupo = "grupo10"
  }
}

# Key Pair
resource "aws_key_pair" "main" {
  key_name   = "MundosE-Grupo10-KeyPair"
  public_key = file("~/.ssh/id_rsa.pub")
}

# EKS Cluster
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"  # Especificamos una versión reciente del módulo

  cluster_name    = "eks-MundosE"
  cluster_version = "1.27"

  vpc_id     = aws_vpc.main.id
  subnet_ids = aws_subnet.private[*].id

  eks_managed_node_group_defaults = {
    ami_type       = "AL2_x86_64"
    instance_types = ["t3.micro"]
  }

  eks_managed_node_groups = {
    eks_nodes = {
      min_size     = 3
      max_size     = 3
      desired_size = 3

      instance_types = ["t3.micro"]
      capacity_type  = "ON_DEMAND"

      labels = {
        grupo = "grupo10"
      }

      tags = {
        grupo = "grupo10"
      }
    }
  }

  tags = {
    grupo = "grupo10"
  }
}

# Outputs
output "ec2_public_ip" {
  description = "Public IP of EC2 instance"
  value       = aws_instance.main.public_ip
}

output "eks_cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane"
  value       = module.eks.cluster_security_group_id
}