#!/bin/bash

# Deletes an S3 bucket for storing terraform state in
# Used code from https://gist.github.com/weavenet/f40b09847ac17dd99d16

set -e

REGION=${1:-'eu-west-1'}
BUCKET_NAME=${2:-'mike-terraform-state-bucket-94823'}

export AWS_DEFAULT_REGION="${REGION}"

# Check whether bucket exists
echo -e "Checking whether bucket (${BUCKET_NAME}) exists"
if aws s3 ls | grep -q "${BUCKET_NAME}" >> /dev/null; then
  echo -e "Bucket exists..."

  # Delete all object versions so we can delete the empty bucket
  echo "Removing all versions from ${BUCKET_NAME}"

  versions=`aws s3api list-object-versions --bucket ${BUCKET_NAME} |jq '.Versions'`
  markers=`aws s3api list-object-versions --bucket ${BUCKET_NAME} |jq '.DeleteMarkers'`

  echo "removing files"
  for version in $(echo "${versions}" | jq -r '.[] | @base64'); do
      version=$(echo ${version} | base64 --decode)

      key=`echo $version | jq -r .Key`
      versionId=`echo $version | jq -r .VersionId `
      cmd="aws s3api delete-object --bucket ${BUCKET_NAME} --key $key --version-id $versionId"
      echo $cmd
      $cmd
  done

  echo "removing delete markers"
  for marker in $(echo "${markers}" | jq -r '.[] | @base64'); do
      marker=$(echo ${marker} | base64 --decode)

      key=`echo $marker | jq -r .Key`
      versionId=`echo $marker | jq -r .VersionId `
      cmd="aws s3api delete-object --bucket ${BUCKET_NAME} --key $key --version-id $versionId"
      echo $cmd
      $cmd
  done


  echo -e "Deleting bucket: ${BUCKET_NAME}...\n"
  # Delete bucket
  if ! aws s3api delete-bucket --bucket "${BUCKET_NAME}"; then
    echo -e "ERR: Problems encountered deleting the bucket. Exiting\n"
  fi
else
  echo -e "Bucket does not exist. Skipping\n"
fi

echo -e "Completed!"
