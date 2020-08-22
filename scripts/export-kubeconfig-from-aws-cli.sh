#!/bin/bash

# Exports the kubeconfig for an EKS based cluster using the AWS CLI

set -e

REGION=${1:-'eu-west-1'}
K8S_CLUSTER=${2:-development}

export AWS_DEFAULT_REGION="${REGION}"

echo "Attempting to export the kubeconfig..."
if ! aws --region "${REGION}" eks update-kubeconfig --name "${K8S_CLUSTER}"; then
  echo -e "ERR: Problems exporting the kubeconfig"
fi

echo "Completed!"