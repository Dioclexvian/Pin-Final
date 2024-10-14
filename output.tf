output "IpPublica-UbuntuServerEC2" {
  description = "La dirección IP pública de la instancia EC2: "
  value       = aws_instance.Ubuntu-PinFinal.public_ip
}
output "private_key_pem" {
  description = "Llave privada .pem"
  value       = tls_private_key.ssh_key.private_key_pem
  sensitive   = true
}
output "key_name" {
  value = aws_instance.Ubuntu-PinFinal.key_name
}

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

# output "instance_public_ip" {
#   value = aws_instance.eks_instance.public_ip
# }

# output "private_key_path" {
#   value = local_file.private_key.filename
# }

# output "vpc_id" {
#   value = aws_vpc.main.id
# }

# output "public_subnet_id" {
#   value = aws_subnet.subnets[0].id
# }

# output "private_subnet_ids" {
#   value = [aws_subnet.subnets[1].id, aws_subnet.subnets[2].id]
# }