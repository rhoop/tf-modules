// Create Auto Scaling Group Resource
resource "aws_autoscaling_group" "autoscaling_group" {
  desired_capacity          = var.autoscaling_group_desired_capacity
  health_check_type         = "EC2"
  health_check_grace_period = 900
  launch_configuration      = aws_launch_configuration.launch_configuration.name
  load_balancers            = ["${aws_elb.internal_elb.name}"]
  max_size                  = var.autoscaling_group_max_size
  min_elb_capacity          = var.autoscaling_group_min_size
  min_size                  = var.autoscaling_group_min_size
  termination_policies      = ["OldestLaunchConfiguration", "OldestInstance"]
  vpc_zone_identifier = [
    "${data.terraform_remote_state.vpc.outputs.subnet_private.a.id}",
    "${data.terraform_remote_state.vpc.outputs.subnet_private.b.id}",
    "${data.terraform_remote_state.vpc.outputs.subnet_private.d.id}",
  ]

  # wait_for_capacity_timeout = "10m"
  # wait_for_elb_capacity     = "${var.autoscaling_group_min_size}"

  lifecycle {
    create_before_destroy = true
  }
  tag {
    key                 = "Name"
    value               = "${var.env}-nomad-asg"
    propagate_at_launch = true
  }
  tag {
    key                 = "vpc"
    value               = var.env
    propagate_at_launch = true
  }

  tag {
    key                 = "app_class"
    value               = "nomad"
    propagate_at_launch = true
  }

  tag {
    key                 = "app_role"
    value               = "nomad_client"
    propagate_at_launch = true
  }

  tag {
    key   = "meta"
    value = "workload=general,docker_control=false"
  }
}
