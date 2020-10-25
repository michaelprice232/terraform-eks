#!/bin/bash

# Script for applying terraform
# Must use the assume-mfa-role-hmrc.sh script as we need MFA enabled temp credentials

set -e

ENVIRONMENT=${1:-'development'}
REGION=${2:-'eu-west-1'}

export AWS_DEFAULT_REGION="${REGION}"

HERE=$(pwd)

# Create terraform state bucket (if required)
"${HERE}/scripts/create-terraform-state-bucket.sh"


## Run terraform build ##
# VPC module
MODULE="vpc"
echo "Applying ${MODULE} module..."
cd "${HERE}/environment/${ENVIRONMENT}/${MODULE}/"
rm -Rf .terraform
terraform init
terraform apply -auto-approve

# Fargate module
MODULE="eks-fargate"
echo "Applying ${MODULE} module..."
cd "${HERE}/environment/${ENVIRONMENT}/${MODULE}/"
rm -Rf .terraform
terraform init
terraform apply -auto-approve

# EKS infra
MODULE="eks-managed-nodegroups"
echo "Applying ${MODULE} module..."
cd "${HERE}/environment/${ENVIRONMENT}/${MODULE}/"
rm -Rf .terraform
terraform init
terraform apply -auto-approve


