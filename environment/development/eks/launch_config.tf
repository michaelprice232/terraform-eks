# EKS management node
resource "aws_launch_configuration" "mgmt_node" {
  name_prefix   = "${var.environment_name}-mgmt-node-"
  image_id      = data.aws_ami.amzn2.id
  instance_type = var.mgmt_node_instance_size
  iam_instance_profile = aws_iam_instance_profile.mgmt_node.name
  key_name = var.mgmt_node_ssh_key_name

  lifecycle {
    create_before_destroy = true
  }
}