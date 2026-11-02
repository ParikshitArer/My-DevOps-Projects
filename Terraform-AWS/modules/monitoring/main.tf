
resource "aws_cloudwatch_metric_alarm" "instance_cpu_utilization" {
  alarm_name          = "${var.project_name}-cpu-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80

  alarm_description = "EC2 CPU Utilization Alarm"

  dimensions = {
    InstanceId = var.instance_id
  }

  treat_missing_data = "missing"

  tags = {
    Environment = var.environment
  }
}

resource "aws_cloudwatch_metric_alarm" "instance_status_check_failed" {
  alarm_name          = "${var.project_name}-status-check-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 1

  alarm_description = "EC2 Status Check Failed Alarm"

  dimensions = {
    InstanceId = var.instance_id
  }

  treat_missing_data = "missing"

  tags = {
    Environment = var.environment
  }
}

