// Populate User Data Template
data "template_file" "user_data" {
  template = file("${path.module}/user_data.sh.tpl")

  vars = {
    aws_region        = var.aws_region
    consul_domain     = var.consul_domain
    consul_datacenter = var.env
  }
}

// Launch Configuration Resource
resource "aws_launch_configuration" "launch_configuration" {
  name_prefix = "${var.env}-nomad-"
  key_name    = var.aws_keypair_name
  image_id    = var.aws_ami

  # spot_price           = "${var.spot_price}"
  instance_type        = var.instance_type
  security_groups      = ["${aws_security_group.security_group.id}"]
  user_data            = data.template_file.user_data.rendered
  iam_instance_profile = var.iam_profile

  lifecycle {
    create_before_destroy = true
  }
}
