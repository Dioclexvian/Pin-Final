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

# Use existing key pair if available, otherwise create a new one
data "aws_key_pair" "existing" {
  key_name = "MundosE-Grupo10-KeyPair"
  
}

resource "tls_private_key" "ssh_key" {
  count     = data.aws_key_pair.existing.key_name != "" ? 0 : 1
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "main" {
  count      = data.aws_key_pair.existing.key_name != "" ? 0 : 1
  key_name   = "MundosE-Grupo10-KeyPair"
  public_key = tls_private_key.ssh_key[0].public_key_openssh
}

# The rest of your VPC, subnet, and security group configurations remain the same

# EC2 Instance
resource "aws_instance" "Ubuntu-PinFinal" {
  ami           = "ami-0261755bbcb8c4a84"  # Ubuntu 20.04 LTS in us-east-1
  instance_type = "t2.micro"
  key_name      = data.aws_key_pair.existing.key_name != "" ? data.aws_key_pair.existing.key_name : aws_key_pair.main[0].key_name
  subnet_id     = aws_subnet.public[0].id
  vpc_security_group_ids = [aws_security_group.main.id]

  user_data = file("install-programs.sh")

  tags = {
    Name = "MundosE-Grupo10-EC2"
    grupo = "grupo10"
  }
}

# EKS Cluster
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

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

  # Use existing KMS key if available
  create_kms_key = false
  cluster_encryption_config = {
    resources        = ["secrets"]
    provider_key_arn = data.aws_kms_alias.eks.target_key_arn
  }

  # Use existing CloudWatch log group if available
  create_cloudwatch_log_group = false

  tags = {
    grupo = "grupo10"
  }
}

# Data source for existing KMS key
data "aws_kms_alias" "eks" {
  name = "alias/eks/eks-MundosE"
}

# Data source for existing CloudWatch log group
data "aws_cloudwatch_log_group" "eks" {
  name = "/aws/eks/eks-MundosE/cluster"
}