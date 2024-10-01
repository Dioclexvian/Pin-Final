#VPC PIN GRUPO 10 

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = var.name
  }
}

#Subnet 0 es Publica
#Creaciòn de las subnet
#¿aquí las subnetes deberían estar en zonas a y b, diferentes?
#creo que debemos separarlos
resource "aws_subnet" "subnets" {
  count      = 3
  vpc_id     = aws_vpc.vpc.id
  cidr_block = element(var.subnet_CIDR, count.index)
  tags = {
    Name = "${var.name}-sub-${count.index + 1}"
  }
}

#Internet GW Publica subnet publica
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id  #attach con el igw?
  tags = {
    Name = "${var.name}-igw"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.name}-public-route-table"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0" #destino está bien así
  gateway_id             = aws_internet_gateway.igw.id #este es el target?
}

resource "aws_route_table_association" "public_route_table" {
  subnet_id      = aws_subnet.subnets[0].id
  route_table_id = aws_route_table.public_route_table.id
}



# #Elastic IP para el NAT GW

# resource "aws_eip" "nat_eip" {
#   domain     = "vpc"
#   depends_on = [aws_internet_gateway.igw]
# }

# # NAT Gateway
# #necesitamos nat gw? 
# resource "aws_nat_gateway" "nat" {
#   allocation_id = aws_eip.nat_eip.id
#   subnet_id     = aws_subnet.subnets[0].id #la subnet debería ser la privada?
#   depends_on    = [aws_internet_gateway.igw]

#   tags = {
#     Name = "${var.name}-nat"
#   }
# }

# resource "aws_route_table" "private_route_table" {
#   count  = 2
#   vpc_id = aws_vpc.vpc.id

#   tags = {
#     Name = "${var.name}-private-rt-${count.index + 1}"
#   }
# }

# resource "aws_route" "private_route" {
#   count                  = 2
#   route_table_id         = aws_route_table.private_route_table[count.index].id
#   destination_cidr_block = "10.0.1.0/24"
#   nat_gateway_id         = aws_nat_gateway.nat.id
# }

# resource "aws_route_table_association" "private_route_table" {
#   count          = 2
#   subnet_id      = aws_subnet.subnets[count.index + 1].id
#   route_table_id = aws_route_table.private_route_table[count.index].id
# }