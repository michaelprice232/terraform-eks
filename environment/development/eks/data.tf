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