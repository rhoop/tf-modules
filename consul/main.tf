data "terraform_remote_state" "vpc" {
  backend = "s3"

  config {
    bucket = "${var.s3_bucket_prefix}-terraform-state"
    key    = "vpc/${var.env}/main.tfstate"
    region = var.aws_region
  }
}

resource "aws_security_group" "consul" {
  name        = "${var.env}_consul"
  description = "${var.env} Consul Group"

  ingress {
    from_port   = 8301
    to_port     = 8301
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    from_port   = 8301
    to_port     = 8301
    protocol    = "udp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    from_port   = 8600
    to_port     = 8600
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    from_port   = 8500
    to_port     = 8500
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    from_port   = 8400
    to_port     = 8400
    protocol    = "udp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    from_port   = 8302
    to_port     = 8302
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    from_port   = 8302
    to_port     = 8302
    protocol    = "udp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    from_port   = 8300
    to_port     = 8300
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    from_port   = 8300
    to_port     = 8300
    protocol    = "udp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = data.terraform_remote_state.vpc.vpc.id
}

resource "aws_instance" "consul_1a" {
  availability_zone       = data.terraform_remote_state.vpc.subnet_private.a.zone
  instance_type           = var.instance_type
  key_name                = var.aws_keypair_name
  subnet_id               = data.terraform_remote_state.vpc.subnet_private.a.id
  ami                     = var.aws_ami
  private_ip              = var.private_ip_1a
  vpc_security_group_ids  = ["${aws_security_group.consul.id}"]
  disable_api_termination = true
  iam_instance_profile    = var.iam_profile

  tags {
    Name      = "consul-${data.terraform_remote_state.vpc.subnet_private.a.name}"
    vpc       = var.env
    app_class = "consul"
    app_role  = "consul_server"
  }

  lifecycle {
    ignore_changes = ["ami"]
  }
}

resource "aws_instance" "consul_1b" {
  availability_zone       = data.terraform_remote_state.vpc.subnet_private.b.zone
  instance_type           = var.instance_type
  key_name                = var.aws_keypair_name
  subnet_id               = data.terraform_remote_state.vpc.subnet_private.b.id
  ami                     = var.aws_ami
  private_ip              = var.private_ip_1b
  vpc_security_group_ids  = ["${aws_security_group.consul.id}"]
  disable_api_termination = true
  iam_instance_profile    = var.iam_profile

  tags {
    Name      = "consul-${data.terraform_remote_state.vpc.subnet_private.b.name}"
    vpc       = var.env
    app_class = "consul"
    app_role  = "consul_server"
  }

  lifecycle {
    ignore_changes = ["ami"]
  }
}

resource "aws_instance" "consul_1d" {
  availability_zone       = data.terraform_remote_state.vpc.subnet_private.d.zone
  instance_type           = var.instance_type
  key_name                = var.aws_keypair_name
  subnet_id               = data.terraform_remote_state.vpc.subnet_private.d.id
  ami                     = var.aws_ami
  private_ip              = var.private_ip_1d
  vpc_security_group_ids  = ["${aws_security_group.consul.id}"]
  disable_api_termination = true
  iam_instance_profile    = var.iam_profile

  tags {
    Name      = "consul-${data.terraform_remote_state.vpc.subnet_private.d.name}"
    vpc       = var.env
    app_class = "consul"
    app_role  = "consul_server"
  }

  lifecycle {
    ignore_changes = ["ami"]
  }
}
