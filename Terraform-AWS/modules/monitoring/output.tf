output "cpu_alarm_arn" {
  description = "ARN of the EC2 CPU utilization alarm"
  value       = aws_cloudwatch_metric_alarm.instance_cpu_utilization.arn
}

output "status_check_alarm_arn" {
  description = "ARN of the EC2 status check alarm"
  value       = aws_cloudwatch_metric_alarm.instance_status_check_failed.arn
}

