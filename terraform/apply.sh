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
  -var "WMS_API_URL=$WMS_API_URL" \
  -var "WMS_API_KEY=$WMS_API_KEY" \
  -var "RECORDS_SOURCE_ID=$RECORDS_SOURCE_ID" \
  -var "PROMPT_TEMPLATES_SOURCE_ID=$PROMPT_TEMPLATES_SOURCE_ID" \
  -var "PROMPT_ID=$PROMPT_ID" \
  -var "CLIENT_ID=$CLIENT_ID" \
