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
# resource "aws_subnet" "subnets" {
#   count      = 3
#   vpc_id     = aws_vpc.vpc.id
#   cidr_block = element(var.subnet_CIDR, count.index)
#   tags = {
#     Name = "${var.name}-sub-${count.index + 1}"
#   }
# }


resource "aws_subnet" "subnet_public1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = element(var.subnet_CIDR,0)
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.name}-sub-1"
  } 
}

resource "aws_subnet" "subnet_private1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = element(var.subnet_CIDR,1)
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.name}-sub-2"
  } 
}


resource "aws_subnet" "subnet_private2" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = element(var.subnet_CIDR,2)
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.name}-sub-3"
  } 
}

resource "aws_subnet" "subnet_public2" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = element(var.subnet_CIDR,3)
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.name}-sub-4"
  } 
}
######################################################################
############AGREGAR SUB NET PUBLICA Y PRIVADA IUS-EAST-1C#############
######################################################################

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
  gateway_id             = aws_internet_gateway.igw.id 
}

resource "aws_route_table_association" "public1_route_table" {
  subnet_id      = aws_subnet.subnet_public1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public2_route_table" {
  subnet_id      = aws_subnet.subnet_public2.id
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