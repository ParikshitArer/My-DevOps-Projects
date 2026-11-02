variable "project_name" {

  type = string

  default = "aws-disaster-recovery"
}


variable "primary_region" {

  type = string
}

variable "secondary_region" {
  type = string
}

variable "primary_vpc_cidr" {
  type = string

}
variable "secondary_vpc_cidr" {
  type = string
}

variable "instance_type" {
  type = string

}

variable "environment" {
  type = string
}
variable "primary_availability_zones" {
  type = list(string)
}

variable "secondary_availability_zones" {
  type = list(string)
}

variable "primary_public_subnet_cidrs" {
  type = list(string)
}
variable "secondary_public_subnet_cidrs" {
  type = list(string)
}

variable "primary_private_subnet_cidrs" {
  type = list(string)
}
variable "secondary_private_subnet_cidrs" {
  type = list(string)
}
