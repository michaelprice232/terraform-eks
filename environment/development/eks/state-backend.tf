# Remote state
terraform {
  backend "s3" {
    bucket = "mike-terraform-state-bucket-29894"
    key    = "development/eks"
    region = "eu-west-1"
  }
}