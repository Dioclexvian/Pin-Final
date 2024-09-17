output "IpPublica-UbuntuServerEC2" {
  description = "La dirección IP pública de la instancia EC2: "
  value       = aws_instance.var.name_ec2.public_ip
}