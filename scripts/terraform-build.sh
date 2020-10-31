#!/bin/bash

# Script for applying terraform

set -e

# Which terraform modules to apply
MODULES_TO_APPLY="vpc eks-fargate eks-managed-nodegroups"

ENVIRONMENT=${1:-'development'}
REGION=${2:-'eu-west-1'}

export AWS_DEFAULT_REGION="${REGION}"

HERE=$(pwd)


# Create terraform state bucket (if required)
"${HERE}/scripts/create-terraform-state-bucket.sh"

# Apply the terraform modules
for module in ${MODULES_TO_APPLY}; do
  echo "Applying ${module} module..."
  cd "${HERE}/environment/${ENVIRONMENT}/${module}/"
  rm -Rf .terraform
  terraform init
  terraform apply -auto-approve
done