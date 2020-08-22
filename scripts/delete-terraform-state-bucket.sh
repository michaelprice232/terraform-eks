#!/bin/bash

# Deletes an S3 bucket for storing terraform state in

set -e

REGION=${1:-'eu-west-1'}
BUCKET_NAME=${2:-'mike-terraform-state-bucket-29894'}

export AWS_DEFAULT_REGION="${REGION}"

# Delete bucket (if required)
echo -e "Checking whether bucket (${BUCKET_NAME}) exists"
if aws s3 ls | grep -q "${BUCKET_NAME}"; then
  echo -e "Bucket exists. Deleting...\n"
  if ! aws s3api delete-bucket --bucket "${BUCKET_NAME}"; then
    echo "ERR: Problems encountered deleting the bucket. Exiting\n"
  fi
else
  echo -e "Bucket does not exist. Skipping\n"
fi

echo -e "Completed!"
