# KMS key to be used for envelope encryption for k8s secrets
# https://aws.amazon.com/about-aws/whats-new/2020/03/amazon-eks-adds-envelope-encryption-for-secrets-with-aws-kms
resource "aws_kms_key" "eks" {
  description             = "EKS Secret Encryption Key"
  deletion_window_in_days = var.kms_key_deletion_days

  tags = {
    Owner       = var.tag_owner
    Environment = var.environment_name
  }
}

resource "aws_kms_alias" "a" {
  name          = "alias/k8s-envelope-encryption-key-fargate-${var.environment_name}"
  target_key_id = aws_kms_key.eks.key_id
}