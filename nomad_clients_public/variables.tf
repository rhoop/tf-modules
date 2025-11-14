variable "aws_access_key" {}
variable "aws_region" {}
variable "aws_secret_key" {}
variable "env" {}
variable "s3_bucket_prefix" {}
variable "aws_ami" {}
variable "aws_keypair_name" {}
variable "iam_profile" {}
variable "workload" {}
variable "template_file_rendered" {}

// variable "spot_price" {
//   default = "0.31"
// }

variable "autoscaling_group_desired_capacity" {
  default = "3"
}

variable "autoscaling_group_min_size" {
  default = "3"
}

variable "autoscaling_group_max_size" {
  default = "12"
}

variable "instance_type" {
  default = "t3.2xlarge"
}
