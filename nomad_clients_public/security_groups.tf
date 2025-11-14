// Create nomad-client Security Group
resource "aws_security_group" "security_group" {
  name        = "${var.env}_nomad_${var.workload}_client"
  description = "Security Group for ${var.env}-nomad-${var.workload}-client"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc.id

  tags = {
    vpc  = var.env
    Name = "nomad-client-${var.workload}-${var.env}"
  }
}
// "

resource "aws_security_group_rule" "security_group_tcp" {
  security_group_id = aws_security_group.security_group.id

  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["172.16.0.0/12", "10.0.0.0/8"]
}


resource "aws_security_group_rule" "security_group_nginxhttp" {
  security_group_id = aws_security_group.security_group.id

  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "security_group_https" {
  security_group_id = aws_security_group.security_group.id

  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "security_group_http" {
  security_group_id = aws_security_group.security_group.id

  type        = "ingress"
  from_port   = 4646
  to_port     = 4646
  protocol    = "tcp"
  cidr_blocks = ["172.16.0.0/12", "10.0.0.0/8"]
}

resource "aws_security_group_rule" "security_group_rpc" {
  security_group_id = aws_security_group.security_group.id

  type        = "ingress"
  from_port   = 4647
  to_port     = 4647
  protocol    = "tcp"
  cidr_blocks = ["172.16.0.0/12", "10.0.0.0/8"]
}

resource "aws_security_group_rule" "security_group_serf_tcp" {
  security_group_id = aws_security_group.security_group.id

  type        = "ingress"
  from_port   = 4648
  to_port     = 4648
  protocol    = "tcp"
  cidr_blocks = ["172.16.0.0/12", "10.0.0.0/8"]
}

resource "aws_security_group_rule" "security_group_serf_udp" {
  security_group_id = aws_security_group.security_group.id

  type        = "ingress"
  from_port   = 4648
  to_port     = 4648
  protocol    = "udp"
  cidr_blocks = ["172.16.0.0/12", "10.0.0.0/8"]
}

resource "aws_security_group_rule" "security_group_serverrcp_tcp" {
  security_group_id = aws_security_group.security_group.id

  type        = "ingress"
  from_port   = 8300
  to_port     = 8300
  protocol    = "tcp"
  cidr_blocks = ["172.16.0.0/12", "10.0.0.0/8"]
}
resource "aws_security_group_rule" "security_group_surflan_tcp" {
  security_group_id = aws_security_group.security_group.id

  type        = "ingress"
  from_port   = 8301
  to_port     = 8301
  protocol    = "tcp"
  cidr_blocks = ["172.16.0.0/12", "10.0.0.0/8"]
}


resource "aws_security_group_rule" "security_group_surflan_udp" {
  security_group_id = aws_security_group.security_group.id

  type        = "ingress"
  from_port   = 8301
  to_port     = 8301
  protocol    = "udp"
  cidr_blocks = ["172.16.0.0/12", "10.0.0.0/8"]
}

resource "aws_security_group_rule" "security_group_surfwan_tcp" {
  security_group_id = aws_security_group.security_group.id

  type        = "ingress"
  from_port   = 8302
  to_port     = 8302
  protocol    = "tcp"
  cidr_blocks = ["172.16.0.0/12", "10.0.0.0/8"]
}

resource "aws_security_group_rule" "security_group_surfwan_udp" {
  security_group_id = aws_security_group.security_group.id

  type        = "ingress"
  from_port   = 8302
  to_port     = 8302
  protocol    = "udp"
  cidr_blocks = ["172.16.0.0/12", "10.0.0.0/8"]
}

resource "aws_security_group_rule" "security_group_ephemeral_tcp" {
  security_group_id = aws_security_group.security_group.id

  type        = "ingress"
  from_port   = 20000
  to_port     = 58000
  protocol    = "tcp"
  cidr_blocks = ["172.16.0.0/12", "10.0.0.0/8"]

}



resource "aws_security_group_rule" "security_group_ephemeral_udp" {
  security_group_id = aws_security_group.security_group.id

  type        = "ingress"
  from_port   = 20000
  to_port     = 58000
  protocol    = "udp"
  cidr_blocks = ["172.16.0.0/12", "10.0.0.0/8"]
}



resource "aws_security_group_rule" "security_group_egress" {
  security_group_id = aws_security_group.security_group.id

  type        = "egress"
  from_port   = 0
  to_port     = 65535
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}
