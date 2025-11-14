# vpn
data "terraform_remote_state" "vpc" {
  backend = "s3"

  config {
    bucket = "${var.s3_bucket_prefix}-terraform-state"
    key    = "vpc/${var.env}/main.tfstate"
    region = "us-west-2"
  }
}

resource "aws_security_group" "vpc_vpn" {
  name        = "${var.env}_vpn"
  description = "Allow VPN traffic from the internet"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8301
    to_port     = 8301
    protocol    = "tcp"
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

/// VPN
resource "aws_instance" "vpc_vpn" {
  ami                    = var.aws_ami
  availability_zone      = data.terraform_remote_state.vpc.subnet_vpn.a.zone
  instance_type          = var.vpn_instance_type
  key_name               = var.aws_keypair_name
  vpc_security_group_ids = ["${aws_security_group.vpc_vpn.id}"]
  source_dest_check      = false
  subnet_id              = data.terraform_remote_state.vpc.subnet_vpn.a.id

  tags {
    Name      = "vpn-${data.terraform_remote_state.vpc.subnet_vpn.a.name}"
    vpc       = var.env
    app_class = "vpn"
  }
}

resource "aws_eip" "vpn" {
  instance = aws_instance.vpc_vpn.id
  vpc      = true
}
