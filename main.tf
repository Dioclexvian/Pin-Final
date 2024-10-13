variable "aws-access-key-id" {}
variable "aws-secret-access-key" {}
 
 resource "aws_instance" "Ubuntu-PinFinal" {
  ami           = "ami-0a0e5d9c7acc336f1"  
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.pinFinalSG.id]
  key_name = aws_key_pair.deployer_key.key_name
  associate_public_ip_address = true 
  subnet_id = aws_subnet.subnet_public1.id
  # iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name
  user_data = <<-EOF
    #!/bin/bash
    # Exporta las claves como variables de entorno
    export SECRET_KEY=${var.aws-access-key-id}
    export ANOTHER_SECRET=${var.aws-secret-access-key} 
    
    # Ejecuta el script de instalación
    $(cat ${file("instalacionProgramas.sh")})

    # Ejecuta el script para instalar EKS y crear el clúster
    chmod +x ${file("eksInstall.sh")}
    bash ${file("eksInstall.sh")}

  EOF

  tags = {
    Name = "server-Pin-Final"
  }

}