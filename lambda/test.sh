#!/bin/bash

# Load environment variables from .env file
export $(grep -v '^#' ../.env | xargs)

# Run function with environment variables
env WMS_API_URL=$WMS_API_URL WMS_API_KEY=$WMS_API_KEY RECORDS_SOURCE_ID=$RECORDS_SOURCE_ID PROMPT_TEMPLATES_SOURCE_ID=$PROMPT_TEMPLATES_SOURCE_ID PROMPT_ID=$PROMPT_ID CLIENT_ID=$CLIENT_ID node ../insights_generation_lambda_pkg/index.js