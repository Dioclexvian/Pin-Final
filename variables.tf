variable "name" {
  type        = string
  description = "Nombre general para los recursos"
  default     = ""
}
variable "vpc_cidr" {
  type        = string
  description = "CIDR usado por la VPC"
  default     = ""
}
variable "subnet_CIDR" {
  type        = list(string)
  description = "CIDR de los subnets"
  default     = []

}

variable "name_sg" {
  type = string
  description = "security group name "
  default = "ssh y web"
}

variable "name_ec2" {
  type = string
  description = "instance name"
  default = "Ubuntu-PinFinal"
}



#variables EKS

variable "cluster_name" {
  default = "Eks-mundos-e"
}

variable "node_instance_type" {
  default = "t1.micro"
}

variable "desired_capacity" {
  default = 3
}

variable "max_size" {
  default = 3
}

variable "min_size" {
  default = 1
}

# variable "ssh_key_name" {
#   description = "Nombre de la llave SSH para acceder a los nodos"
# }
