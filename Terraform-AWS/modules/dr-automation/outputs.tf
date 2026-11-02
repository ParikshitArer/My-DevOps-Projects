output "automation_document_name" {
  description = "SSM Automation document name"
  value       = aws_ssm_document.dr_runbook.name
}

output "event_rule_arn" {
  description = "EventBridge rule ARN"
  value       = aws_cloudwatch_event_rule.dr_trigger.arn
}

output "automation_role_arn" {
  description = "IAM Automation role ARN"
  value       = aws_iam_role.automation_role.arn
}