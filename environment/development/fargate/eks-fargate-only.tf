# Create Fargate only EKS cluster
module "eks_fargate" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "${var.environment_name}-fargate-only"
  cluster_version = var.k8s_version

  # Enable private API endpoint
  cluster_endpoint_private_access = var.endpoint_private_access_enabled

  # Don't write a local kubeconfig file as it relies on IAM Authenticator (generate from the AWS CLI instead)
  write_kubeconfig = false

  vpc_id  = data.terraform_remote_state.vpc.outputs.vpc_id
  subnets = data.terraform_remote_state.vpc.outputs.private_subnets

  tags = {
    Owner       = var.tag_owner
    Environment = var.environment_name
    Type        = "Fargate Only"
  }

  # Envelope encryption of k8s secrets using KMS data key
  # Available on clusters created after 6th May 2020 and > v1.13
  # https://aws.amazon.com/about-aws/whats-new/2020/03/amazon-eks-adds-envelope-encryption-for-secrets-with-aws-kms
  cluster_encryption_config = [
    {
      provider_key_arn = aws_kms_key.eks.arn
      resources        = ["secrets"]
    }
  ]

  map_roles    = var.map_roles
  map_users    = var.map_users
  map_accounts = var.map_accounts
}