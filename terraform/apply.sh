#!/bin/bash

# Load environment variables from .env file
export $(grep -v '^#' ../.env | xargs)

# Run Terraform commands
terraform init
terraform fmt
terraform validate
terraform apply \
  -var "AWS_ACCESS_KEY=$AWS_ACCESS_KEY" \
  -var "AWS_SECRET_KEY=$AWS_SECRET_KEY" \
  -var "SUPABASE_URL=$SUPABASE_URL" \
  -var "SUPABASE_KEY=$SUPABASE_KEY" \
  -var "SUPABASE_TABLE=$SUPABASE_TABLE" \
  -var "SNS_TOPIC_ARN=$SNS_TOPIC_ARN" \
  -var "S3_BUCKET_NAME=$S3_BUCKET_NAME" \
  -var "S3_KEY=$S3_KEY"