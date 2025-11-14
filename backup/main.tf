
# IAM Role:
resource "aws_iam_role" "backup_role" {
  name               = "${var.name_prefix}-role"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": ["sts:AssumeRole"],
      "Effect": "allow",
      "Principal": {
        "Service": ["backup.amazonaws.com"]
      }
    }
  ]
}
POLICY
}


resource "aws_backup_plan" "plan" {
  name = "${var.name_prefix}-plan"

  rule {
    rule_name         = "${var.name_prefix}-rule"
    target_vault_name = aws_backup_vault.vault.name
    schedule          = var.backup_cron
    start_window      = var.start_window
    completion_window = var.completion_window
    lifecycle {
      delete_after = var.delete_after
    }
    copy_action {
      destination_vault_arn = var.copy_vault_arn

      lifecycle {
        delete_after = var.copy_delete_after
      }
    }
  }
}

resource "aws_backup_selection" "selection" {
  iam_role_arn = aws_iam_role.backup_role.arn
  name         = "${var.name_prefix}-selection"
  plan_id      = aws_backup_plan.plan.id
  resources    = ["*"]
  not_resources = ["arn:aws:s3:::*"]
}

resource "aws_iam_role_policy_attachment" "backup_attachment" {
  policy_arn = var.backup_policy_arn
  role       = aws_iam_role.backup_role.name
}

resource "aws_backup_vault" "vault" {
  name = "${var.name_prefix}-vault"
  tags = {
    environment = "production"
    Name        = "${var.name_prefix}-vault"
    type        = "normal_backup"
  }
}

resource "aws_backup_vault_notifications" "vault_sns" {
  backup_vault_name = aws_backup_vault.vault.name
  sns_topic_arn     = var.sns_topic_arn
  backup_vault_events = [
    "BACKUP_JOB_FAILED",
    "BACKUP_JOB_COMPLETED",
    "BACKUP_JOB_EXPIRED",
    "BACKUP_PLAN_MODIFIED",
    "COPY_JOB_FAILED",
    "RECOVERY_POINT_MODIFIED",
    "RESTORE_JOB_FAILED"
  ]
}






