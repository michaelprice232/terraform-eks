#!/bin/bash

# Script for destroying terraform

set -e

# Which terraform modules to destroy
MODULES_TO_DESTROY="eks-fargate eks-managed-nodegroups vpc"

ENVIRONMENT=${1:-'development'}
REGION=${2:-'eu-west-1'}

export AWS_DEFAULT_REGION="${REGION}"

HERE=$(pwd)

# Destroy the terraform modules
for module in ${MODULES_TO_DESTROY}; do
  echo "Destroying ${module} module..."
  cd "${HERE}/environment/${ENVIRONMENT}/${module}/"
  rm -Rf .terraform
  terraform init
  terraform destroy -auto-approve
done