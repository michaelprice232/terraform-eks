# Remote state
terraform {
  backend "s3" {
    bucket = "mike-terraform-state-bucket-94823"
    key    = "development/eks"
    region = "eu-west-1"
  }
}