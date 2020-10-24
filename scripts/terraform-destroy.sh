#!/bin/bash

# Script for destroying terraform
# Must use the assume-mfa-role-hmrc.sh script as we need MFA enabled temp credentials

set -e

ENVIRONMENT=${1:-'development'}
REGION=${2:-'eu-west-1'}

export AWS_DEFAULT_REGION="${REGION}"

HERE=$(pwd)

## Run terraform destroy ##
# EKS module
MODULE="eks"
echo "Destroying ${MODULE} module..."
cd "${HERE}/environment/${ENVIRONMENT}/${MODULE}/"
rm -Rf .terraform
terraform init
terraform destroy -auto-approve

# Fargate module
MODULE="fargate"
echo "Destroying ${MODULE} module..."
cd "${HERE}/environment/${ENVIRONMENT}/${MODULE}/"
rm -Rf .terraform
terraform init
terraform destroy -auto-approve

# VPC infra
MODULE="vpc"
echo "Destroying ${MODULE} module..."
cd "${HERE}/environment/${ENVIRONMENT}/${MODULE}/"
rm -Rf .terraform
terraform init
terraform destroy -auto-approve




