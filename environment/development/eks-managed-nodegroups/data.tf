# Lookup outputs from the vpc module
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "mike-terraform-state-bucket-94823"
    key    = "development/vpc"
    region = "eu-west-1"
  }
}

# Lookup Kubernetes cluster config
data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

# Create an authentication token used by the kubernetes and helm providers
data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

# Amazon Linux 2 AMI
data "aws_ami" "amzn2" {
  owners      = ["amazon"]
  most_recent = true
  name_regex  = "^amzn2-ami-hvm"
}

# IAM role trust policy
data "aws_iam_policy_document" "s3_access_sa_trust_policy" {

  statement {
    effect = "Allow"

    principals {
      identifiers = [module.eks.oidc_provider_arn]
      type        = "Federated"
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test = "StringEquals"
      variable = "${trimprefix(module.eks.cluster_oidc_issuer_url, "https://")}:sub"
      values = ["system:serviceaccount:default:s3-access-sa"]
    }
  }
}

# IAM role permissions
data "aws_iam_policy_document" "s3_access_sa_permissions" {
  statement {
    sid    = "AllowListBuckets"
    effect = "Allow"
    actions = [
      "s3:ListAllMyBuckets",
      "s3:ListBucket"
    ]
    resources = ["*"]
  }
}
