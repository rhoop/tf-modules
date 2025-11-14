
# current is 5am 1st day of every month UTC
variable "schedule_cron" {
  type        = string
  description = "cron job for inspector assessment to run"
}

# arns are region specific
variable "rule_arns" {
  type        = list(any)
  description = "list of aws inspector rule arns"
}

variable "timeout_duration" {
  type        = string
  description = "timeout duration for assessment to run in seconds"
}

variable "name_prefix" {
  type        = string
  description = "naming prefix for aws resources"
}

variable "resource_tags" {
  description = "EC2 tags, key:value mappings to targt with inspector"
}

variable "sns_arn" {
  type        = string
  description = " sns topic arn for null resource to create link to assessment"
}