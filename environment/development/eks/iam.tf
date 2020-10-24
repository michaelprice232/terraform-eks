# IAM role to attach to the instance profile for the management node
resource "aws_iam_role" "mgmt_node" {
  name = "${var.environment_name}-eks-mgmt-node"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow"
        }
    ]
}
EOF
}

# Instance profile for management node
resource "aws_iam_instance_profile" "mgmt_node" {
  name = "${var.environment_name}-eks-mgmt-node"
  role = aws_iam_role.mgmt_node.name
}

# Allow the instance to be managed via SSM
resource "aws_iam_role_policy_attachment" "ssm_role" {
  policy_arn  = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role        = aws_iam_role.mgmt_node.name
}