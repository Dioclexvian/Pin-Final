resource "aws_instance" "Ubuntu-PinFinal" {
  ami           = "ami-09e67e426f25ce0d7"  
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.pinFinalSG.id]
  # key_name = "llave_ssh"
  user_data = "${file("instalacion-programas.sh")}"

  tags = {
    Name = "server-Pin-Final"
  }

}
