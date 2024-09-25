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