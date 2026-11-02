variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "my_project"
}

variable "instance_type" {
  type        = string
  description = "The type of instance to use"
}

variable "security_group_id" {
  type = string
}

variable "environment" {
  description = "The environment for the EC2 instance"
  type        = string



}
variable "subnet_id" {
  description = "The ID of the subnet to launch the EC2 instance in"
  type        = string
}



variable "iam_instance_profile" {
  description = "The IAM instance profile to associate with the EC2 instance"
  type        = string
}