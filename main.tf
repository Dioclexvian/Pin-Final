resource "aws_instance" "Ubuntu-PinFinal" {
  ami           = "ami-0a0e5d9c7acc336f1"  
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.pinFinalSG.id]
  key_name = "PruebaLocal"
  associate_public_ip_address = true 
  subnet_id = aws_subnet.subnets[0].id
  user_data = "${file("instalacion-programas.sh")}"

  tags = {
    Name = "server-Pin-Final"
  }

}
