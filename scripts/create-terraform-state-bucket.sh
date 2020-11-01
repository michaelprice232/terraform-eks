#!/bin/bash

# Creates an S3 bucket for storing terraform state in

set -e

BUCKET_NAME=${1:-'mike-terraform-state-bucket-94823'}
REGION=${2:-'eu-west-1'}

export AWS_DEFAULT_REGION="${REGION}"

# Create bucket (if required)
echo -e "Checking whether bucket (${BUCKET_NAME}) already exists"
if aws s3 ls | grep -q "${BUCKET_NAME}" >> /dev/null; then
  echo -e "Bucket already exists. Skipping creation..."
else
  echo -e "Creating bucket ${BUCKET_NAME} in AWS region: ${REGION}"
  if ! aws s3api create-bucket --bucket "${BUCKET_NAME}" --create-bucket-configuration LocationConstraint="${REGION}"; then
    echo -e "ERR: Problems encountered creating the bucket\nExiting!"
    exit 1
  fi
fi

# Set default server side encryption
echo -e "Setting default server side encryption to SSE-S3"
if ! aws s3api put-bucket-encryption \
    --bucket "${BUCKET_NAME}" \
    --server-side-encryption-configuration '{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]}'; then

      echo -e "ERR: Problems encountered setting the default bucket encryption\nExiting!"
      exit 2
fi

# Set object versioning
echo -e "Setting bucket object versioning"
if ! aws s3api put-bucket-versioning --bucket "${BUCKET_NAME}" --versioning-configuration Status=Enabled; then
  echo -e "ERR: Problems encountered setting bucket object versioning\nExiting"
  exit 3
fi

echo -e "Completed!"
