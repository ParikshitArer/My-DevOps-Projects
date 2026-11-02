variable "project_name" {
  type = string

}


variable "primary_alarm_arn" {
  type = string
}

variable "secondary_alarm_arn" {
  type = string
}
variable "primary_instance_id" {
  description = "Primary EC2 instance ID"
  type        = string

}

variable "secondary_instance_id" {
  description = "Singapore standby EC2 instance ID"
  type        = string
}


variable "environment" {
  description = "Deployment environment"
  type        = string
}