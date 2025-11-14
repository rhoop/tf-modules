variable "alb_name" {
  description = "The name of the loadbalancer"
}

variable "environment" {
  description = "The name of the environment"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet ids to place the loadbalancer in"
}

variable "vpc_id" {
  description = "The VPC id"
}

variable "deregistration_delay" {
  default = "300"
}

variable "health_check_path" {
  default = "/"
}

variable "certificate_arn" {
  default = "/"
}

variable "target_group_matcher" {
  default = "200"
}

#variable "certificate_arn" {}

variable "allow_cidr_block" {
  default     = "0.0.0.0/0"
  description = "Specify cird block that is allowd to acces the LoadBalancer"
}
