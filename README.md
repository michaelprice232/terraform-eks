# terraform-build readme

Terraform repo used for upcoming tech talk around EKS. Deploys a VPC and 2 EKS clusters: one fargate only and one with a single EKS managed node group

## Deployment

Pre-reqs:
1) AWS CLI installed
2) AWS credentials configured (via envar etc)

To deploy the environment run the following. Note it will first create an S3 bucket for storing state as this cannot be terraform'd: 
```
./scripts/terraform-build.sh
```
Note: the default S3 state bucket name is `mike-terraform-state-bucket-94823`. This can be overridden by passing a parameter, although you will need to update the terraform backend state configs (state-backend.tf) to reference the new name. 

## Cleanup
```
./scripts/terraform-destroy.sh
```