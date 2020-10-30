#!/bin/bash

# Get temp credentials
curl http://169.254.169.254/latest/meta-data/iam/security-credentials/

# Set envars to override the IAM credentials
export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""
export AWS_SESSION_TOKEN=""

# Test elevated permissions
aws s3 mb s3://mike-test-8888/