# Sample app deployed into the default namespace
resource "aws_eks_fargate_profile" "default_namespace_sample_app" {
  cluster_name           = module.eks_fargate.cluster_id
  fargate_profile_name   = "default-namespace-sample-app"
  pod_execution_role_arn = aws_iam_role.fargate_profile.arn
  subnet_ids             = data.terraform_remote_state.vpc.outputs.private_subnets

  # Filter on namespace and labels
  selector {
    namespace = "default"

    labels = {
      app = "sample-app"
    }
  }
}

# kube-system workloads (inc. coredns)
resource "aws_eks_fargate_profile" "kube_system_namespace" {
  cluster_name           = module.eks_fargate.cluster_id
  fargate_profile_name   = "kube-system-namespace"
  pod_execution_role_arn = aws_iam_role.fargate_profile.arn
  subnet_ids             = data.terraform_remote_state.vpc.outputs.private_subnets

  # Only filter on namespace
  selector {
    namespace = "kube-system"
  }

  # There appears to be a scheduling issue when building concurrently, so adding dependency
  depends_on = [aws_eks_fargate_profile.default_namespace_sample_app]
}