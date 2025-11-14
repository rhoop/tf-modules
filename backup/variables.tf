
variable "backup_cron" {
  type        = string
  description = "cron schedule for aws an backup plan"
  default     = "cron(0 4 ? * * *)"
}

variable "backup_policy_arn" {
  type        = string
  description = "aws service policy arn for backups"
  default     = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
}

variable "start_window" {
  type        = number
  description = "Start window in minutes, if job doesnt start after n minutes, job fails"
}

variable "completion_window" {
  type        = number
  description = "amount of time in minutes AWS Backup attempts a backup before canceling the job and returning an error"
}

variable "backup_procedure" {
  type        = string
  description = "daily or monthly, tella backup plan waht to tag backup recovery points"
  default     = "daily"
}

variable "delete_after" {
  type        = number
  description = "Days to retain backups after n days delete"
}

variable "copy_delete_after" {
  type        = number
  description = "Days to retain backups in copy region after n days delete"
}

variable "copy_vault_arn" {
  type        = string
  description = "Must be different region than main vault/plan, for disaster recovery"
}

variable "name_prefix" {
  type        = string
  description = "Naming prefix for backup module resources"
}

variable "sns_topic_arn" {
  type        = string
  description = "arn for sns topic vault sends backup notifications too"
}
