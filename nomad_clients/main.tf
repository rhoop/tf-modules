data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "${var.s3_bucket_prefix}-terraform-state-usw2"
    key    = "vpc/${var.env}/main.tfstate"
    region = "us-west-2"
  }
}

