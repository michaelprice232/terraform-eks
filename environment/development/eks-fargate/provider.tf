terraform {
  required_version = ">= 0.12.6"
}

# AWS - Ireland region
provider "aws" {
  version = ">= 2.28.1"
  region  = "eu-west-1"
}

# Kubernetes - managed node group cluster
provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
  version                = "~> 1.11"
}
