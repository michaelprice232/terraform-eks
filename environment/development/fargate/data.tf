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
  name = module.eks_fargate.cluster_id
}

# Create an authentication token used by the kubernetes and helm providers
data "aws_eks_cluster_auth" "cluster" {
  name = module.eks_fargate.cluster_id
}