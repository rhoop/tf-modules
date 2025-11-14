# AWS IAM policy and role for CW to trigger the assessment on an event schedule
resource "aws_iam_role_policy" "inspector_policy" {
  name = "${var.name_prefix}-policy"
  role = aws_iam_role.cw_event_inspector_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "inspector:StartAssessmentRun",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role" "cw_event_inspector_role" {
  name = "${var.name_prefix}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = ["events.amazonaws.com"]
        }
      },
    ]
  })
}

# CW Event(s) and  CW target(s)
resource "aws_cloudwatch_event_rule" "inspector_cw_event" {
  name                = "${var.name_prefix}-cw-event"
  description         = "Scheduled trigger for Amazon Inspector Assessment: "
  schedule_expression = var.schedule_cron
}

resource "aws_cloudwatch_event_target" "inspector_cw_target" {
  rule      = aws_cloudwatch_event_rule.inspector_cw_event.name
  target_id = "AmazonInspectorAssessment"
  arn       = aws_inspector_assessment_template.assessment_template.arn
  role_arn  = aws_iam_role.cw_event_inspector_role.arn
}

# AWS inspetor resourcegroup for tagged selection
resource "aws_inspector_resource_group" "inspector_group" {
  tags = var.resource_tags
}

resource "aws_inspector_assessment_target" "assessment_target" {
  name               = "${var.name_prefix}-target"
  resource_group_arn = aws_inspector_resource_group.inspector_group.arn
}

resource "aws_inspector_assessment_template" "assessment_template" {
  name               = "${var.name_prefix}-assessment"
  target_arn         = aws_inspector_assessment_target.assessment_target.arn
  duration           = var.timeout_duration
  rules_package_arns = var.rule_arns

}

# changes every deployment, forcing the trigger to re-run the null resource
resource "random_id" "random" {
  keepers = {
    uuid = uuid()
  }
  byte_length = 8
}

# Links assessment template and SnS Topic
resource "null_resource" "link_sns_topic" {
  provisioner "local-exec" {
    command = "aws inspector subscribe-to-event --resource-arn ${aws_inspector_assessment_template.assessment_template.arn} --event ASSESSMENT_RUN_COMPLETED --topic-arn ${var.sns_arn}"
  }
  triggers = {
    random_uuid = "${random_id.random.hex}"
  }
  depends_on = [aws_inspector_assessment_template.assessment_template]
}