# Create EKS cluster + managed node groups
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.environment_name
  cluster_version = var.k8s_version

  # Enable private API endpoint
  cluster_endpoint_private_access = var.endpoint_private_access_enabled

  # Don't write a local kubeconfig file as it relies on IAM Authenticator (generate from the AWS CLI instead)
  write_kubeconfig       = false

  vpc_id          = data.terraform_remote_state.vpc.outputs.vpc_id
  subnets         = data.terraform_remote_state.vpc.outputs.private_subnets

  tags = {
    Owner       = var.tag_owner
    Environment = var.environment_name
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

  node_groups_defaults = {
    ami_type  = "AL2_x86_64"
    disk_size = 50
  }

  node_groups = {
    standard_workers = {
      desired_capacity = 2
      max_capacity     = 2
      min_capacity     = 2

      instance_type = "m5.large"
      k8s_labels = {
        Environment = var.environment_name
      }
      additional_tags = {
        Environment = var.environment_name
      }
    }
  }

  map_roles    = var.map_roles
  map_users    = var.map_users
  map_accounts = var.map_accounts
}