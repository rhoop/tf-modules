variable "aws_ami" {}
variable "aws_keypair_name" {}
variable "aws_region" {}
variable "env" {}

variable "instance_type" {
  default = "t2.medium"
}

variable "private_ip_1a" {}
variable "private_ip_1b" {}
variable "private_ip_1d" {}
variable "s3_bucket_prefix" {}
variable "iam_profile" {}
