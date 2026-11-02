
# ==========================================
# SSM AUTOMATION IAM ROLE
# ==========================================

resource "aws_iam_role" "automation_role" {
  name = "${var.project_name}-ssm-automation-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Principal = {
        Service = "ssm.amazonaws.com"
      }

      Action = "sts:AssumeRole"
    }]
  })
}


# ==========================================
# SSM AUTOMATION IAM POLICY
# ==========================================

resource "aws_iam_policy" "automation" {
  name = "${var.project_name}-ssm-automation-policy"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Action = [
        "ec2:CreateTags"
      ]

      Resource = "arn:aws:ec2:ap-southeast-1:*:instance/*"
    }]
  })
}


# ==========================================
# ATTACH AUTOMATION POLICY
# ==========================================

resource "aws_iam_role_policy_attachment" "automation_attach" {
  role       = aws_iam_role.automation_role.name
  policy_arn = aws_iam_policy.automation.arn
}


# ==========================================
# SSM DR RUNBOOK
# ==========================================

resource "aws_ssm_document" "dr_runbook" {
  name            = "Parikshit-disaster-recovery-dr-runbook"
  document_type   = "Automation"
  document_format = "YAML"

  content = <<-DOC
    schemaVersion: '0.3'
    description: Activate the Singapore disaster recovery standby instance.

    assumeRole: "{{ AutomationAssumeRole }}"

    parameters:
      AutomationAssumeRole:
        type: String
        description: IAM role used by Systems Manager Automation

      InstanceId:
        type: String
        description: Singapore standby EC2 instance ID

    mainSteps:
      - name: MarkStandbyActivated
        action: aws:executeAwsApi
        inputs:
          Service: ec2
          Api: CreateTags
          Resources:
            - "{{ InstanceId }}"
          Tags:
            - Key: DRStatus
              Value: Failover-Ready
            - Key: DRActivationSource
              Value: Automated
  DOC

  tags = {
    Environment = var.environment
  }
}


# ==========================================
# EVENTBRIDGE IAM ROLE
# ==========================================

resource "aws_iam_role" "eventbridge" {
  name = "${var.project_name}-eventbridge-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Principal = {
        Service = "events.amazonaws.com"
      }

      Action = "sts:AssumeRole"
    }]
  })
}


# ==========================================
# EVENTBRIDGE IAM POLICY
# ==========================================

resource "aws_iam_policy" "eventbridge" {
  name = "${var.project_name}-eventbridge-policy"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "ssm:StartAutomationExecution"
        ]

        Resource = aws_ssm_document.dr_runbook.arn
      },
      {
        Effect = "Allow"

        Action = [
          "iam:PassRole"
        ]

        Resource = aws_iam_role.automation_role.arn
      }
    ]
  })
}


# ==========================================
# ATTACH EVENTBRIDGE POLICY
# ==========================================

resource "aws_iam_role_policy_attachment" "eventbridge" {
  role       = aws_iam_role.eventbridge.name
  policy_arn = aws_iam_policy.eventbridge.arn
}


# ==========================================
# CLOUDWATCH ALARM EVENT RULE
# ==========================================

resource "aws_cloudwatch_event_rule" "dr_trigger" {
  name        = "${var.project_name}-dr-trigger"
  description = "Trigger DR automation when the primary CloudWatch alarm enters ALARM state"

  event_pattern = jsonencode({
    source = [
      "aws.cloudwatch"
    ]

    detail-type = [
      "CloudWatch Alarm State Change"
    ]

    resources = [
      var.primary_alarm_arn
    ]

    detail = {
      state = {
        value = [
          "ALARM"
        ]
      }
    }
  })

  tags = {
    Environment = var.environment
  }
}


# ==========================================
# EVENTBRIDGE TARGET
# ==========================================

resource "aws_cloudwatch_event_target" "automation" {
  rule      = aws_cloudwatch_event_rule.dr_trigger.name
  target_id = "SSM-DR-Automation"

  arn      = aws_ssm_document.dr_runbook.arn
  role_arn = aws_iam_role.eventbridge.arn

  input = jsonencode({
    DocumentName = aws_ssm_document.dr_runbook.name

    Parameters = {
      AutomationAssumeRole = [
        aws_iam_role.automation_role.arn
      ]

      InstanceId = [
        var.secondary_instance_id
      ]
    }
  })

  depends_on = [
    aws_iam_role_policy_attachment.eventbridge,
    aws_iam_role_policy_attachment.automation_attach
  ]
}

