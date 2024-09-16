output "IpPublica-UbuntuServerEC2" {
  description = "La dirección IP pública de la instancia EC2: "
  value       = aws_instance.Ubuntu-PinFinal1.public_ip
}