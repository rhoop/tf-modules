// Create nomad Internal ELB
resource "aws_elb" "internal_elb" {
  name     = "${var.env}-nomad-elb"
  internal = true

  subnets = [
    "${data.terraform_remote_state.vpc.outputs.subnet_private.a.id}",
    "${data.terraform_remote_state.vpc.outputs.subnet_private.b.id}",
    "${data.terraform_remote_state.vpc.outputs.subnet_private.d.id}",
  ]

  security_groups           = ["${aws_security_group.elb_security_group.id}"]
  cross_zone_load_balancing = true
  connection_draining       = true

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  listener {
    instance_port     = 443
    instance_protocol = "tcp"
    lb_port           = 443
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:80"
    interval            = 10
  }
  tags = {
    vpc = var.env
  }
}

