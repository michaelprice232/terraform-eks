# Remote state
terraform {
  backend "s3" {
    bucket = "mike-terraform-state-bucket-94823"
    key    = "development/fargate"
    region = "eu-west-1"
  }
}