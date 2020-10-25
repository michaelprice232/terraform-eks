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


# IAM role - 's3-access-sa' k8s service account
resource "aws_iam_role" "s3_access_sa" {
  name                = "${var.environment_name}-eks-s3-access-sa-role"
  path                = "/"
  assume_role_policy  = data.aws_iam_policy_document.s3_access_sa_trust_policy.json
}

resource "aws_iam_policy" "s3_list_bucket_policy" {
  name        = "${var.environment_name}-s3-list-bucket-policy"
  description = "Permissions to list S3 buckets"
  policy      = data.aws_iam_policy_document.s3_access_sa_permissions.json
}

resource "aws_iam_role_policy_attachment" "s3_list_bucket" {
  policy_arn  = aws_iam_policy.s3_list_bucket_policy.arn
  role        = aws_iam_role.s3_access_sa.name
}