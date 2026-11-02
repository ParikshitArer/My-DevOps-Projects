variable "project_name" {
  description = "The name of the project"
  type        = string

}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC to create the ALB in"

}

variable "public_subnet_ids" {
  description = "A list of subnet IDs to create the ALB in"
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "The ID of the security group to associate with the ALB"
  type        = string
}

variable "ec2_instance_id" {
  description = "The ID of the EC2 instance to register with the ALB"
  type        = string
}

variable "environment" {
  description = "The environment for the ALB"
  type        = string
}
