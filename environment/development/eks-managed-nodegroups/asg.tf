resource "aws_autoscaling_group" "mgmt_node" {
  vpc_zone_identifier = data.terraform_remote_state.vpc.outputs.private_subnets
  desired_capacity    = 1
  max_size            = 1
  min_size            = 1
  launch_configuration = aws_launch_configuration.mgmt_node.name

  tag {
    key                 = "Name"
    value               = "${var.environment_name}-mgmt-node"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}