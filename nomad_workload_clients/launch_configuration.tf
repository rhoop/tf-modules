// Launch Configuration Resource
resource "aws_launch_configuration" "launch_configuration" {
  name_prefix = "${var.env}-nomad-${var.workload}"
  key_name    = var.aws_keypair_name
  image_id    = var.aws_ami

  # spot_price           = "${var.spot_price}"
  instance_type        = var.instance_type
  security_groups      = ["${aws_security_group.security_group.id}"]
  user_data            = var.template_file_rendered
  iam_instance_profile = var.iam_profile

  lifecycle {
    create_before_destroy = true
  }
}
