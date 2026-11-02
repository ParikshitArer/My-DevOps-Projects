
# ==========================================
# VPC OUTPUTS
# ==========================================

output "primary_vpc_id" {
  description = "Primary Mumbai VPC ID"
  value       = module.primary_networking.vpc_id
}

output "secondary_vpc_id" {
  description = "Secondary Singapore VPC ID"
  value       = module.secondary_networking.vpc_id
}


# ==========================================
# EC2 INSTANCE OUTPUTS
# ==========================================

output "primary_ec2_instance_id" {
  description = "Primary EC2 instance ID"
  value       = module.primary_ec2.instance_id
}

output "secondary_ec2_instance_id" {
  description = "Secondary EC2 instance ID"
  value       = module.secondary_ec2.instance_id
}


# ==========================================
# EC2 PRIVATE IP OUTPUTS
# ==========================================

output "primary_ec2_private_ip" {
  description = "Primary EC2 private IP"
  value       = module.primary_ec2.private_ip
}

output "secondary_ec2_private_ip" {
  description = "Secondary EC2 private IP"
  value       = module.secondary_ec2.private_ip
}


# ==========================================
# ALB DNS OUTPUTS
# ==========================================

output "primary_alb_dns_name" {
  description = "Primary Mumbai ALB DNS name"
  value       = module.primary_alb.alb_dns_name
}

output "secondary_alb_dns_name" {
  description = "Secondary Singapore ALB DNS name"
  value       = module.secondary_alb.alb_dns_name
}


# ==========================================
# S3 BUCKET OUTPUTS
# ==========================================

output "primary_s3_bucket_arn" {
  description = "Primary S3 bucket ARN"
  value       = module.s3_replication.primary_bucket_arn
}

output "secondary_s3_bucket_arn" {
  description = "Secondary S3 bucket ARN"
  value       = module.s3_replication.secondary_bucket_arn
}

output "s3_replication_role_arn" {
  description = "S3 replication IAM role ARN"
  value       = module.s3_replication.replication_role_arn
}


# ==========================================
# DISASTER RECOVERY OUTPUTS
# ==========================================

output "dr_automation_document_name" {
  description = "SSM DR Automation document name"
  value       = module.dr_automation.automation_document_name
}

output "dr_eventbridge_rule_arn" {
  description = "DR EventBridge rule ARN"
  value       = module.dr_automation.event_rule_arn
}

output "dr_automation_role_arn" {
  description = "DR Automation IAM role ARN"
  value       = module.dr_automation.automation_role_arn
}

