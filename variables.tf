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