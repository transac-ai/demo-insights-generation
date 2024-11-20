# Transac AI Demo Transactions Injector

Transac AI project is geared towards generation of enriched summaries and insights of transactional data in real-time or batch using Generative AI and Large Language Models (LLMs).

To demonstrate the Transac AI project, there was requirement of a client system where transactions are happening in real-time. The Transac AI project does not concern itself with how transactions are captured. This abstraction is supported through the [Prompt Builder Service (PBS)](https://github.com/pranav-kural/transacai-prompt-builder-service). A client can easily add their own source of transaction records by extending the [PrimaryRecordsDB](https://github.com/pranav-kural/transacai-prompt-builder-service/blob/main/src/records/primary_records_db.py) class.

However, to simulate this real-time transaction data, there was a need for a service that would inject transactions into the [Supabase](https://supabase.com/)-hosted test `records` database, imitating the real-time transactions being made by customers or employees. This is where the Transac AI Demo Transactions Injector project comes into play. Below is a high-level overview of the architecture.

![transac-ai-demo-inj-arch](https://github.com/user-attachments/assets/e60286df-bda0-44a3-a013-07f165a519d7)

## Overview

At its core, a Python-based handler function is deployed as an [AWS Lambda](https://aws.amazon.com/pm/lambda) function, along with an [AWS EventBridge](https://aws.amazon.com/eventbridge/) schedule to invoke this lambda function every certain interval. This handler function reads a certain number of records from a CSV file that it fetches from an [AWS S3](https://aws.amazon.com/s3/) bucket, and then injects them into the `records` database hosted on [Supabase](https://supabase.com/).

### Inject Transactions Handler

The handler function is responsible for injecting transactions into the `records` database. The handler function is triggered by an [AWS EventBridge](https://aws.amazon.com/eventbridge/) rule every minute, and runs for about 4 seconds.

Steps:

1. Fetch the `sample_records.csv` file from S3 bucket and read the data into a list.
2. Select n records at random.
3. Add "completed_at" column with current timestamp, and "client_id" column with "test_client".
4. Prepare CSV data to be sent in bulk insert REST API request.
5. Bulk insert records.
    - Send bulk insert request to Supabase REST API.
    - Publish job status to AWS SNS.

This project holds the code for a simple Python based code program that fetches a certain number of records from `sample_records.csv` and injects them into the `records` database hosted on [Supabase](https://supabase.com/).

### Data Preparation

The `sample_records.csv` file is prepared from the `data/prepare_sample_records.py` script by using a dataset containing a large amount of sample transactions. Check this Kaggle notebook for more details: [TransacAI Data Preparation](https://www.kaggle.com/code/pranavkural/transacai-data-preparation)

## AWS

The project is deployed on AWS. The Transac AI project services are mostly deployed on Google Cloud. However, since this demo injector service is completely independent of the core Transac AI services, it is deployed on AWS. This also helps establish a cross-cloud architecture, where client is independent to choose their cloud provider.

### AWS Lambda

The handler function is deployed as an AWS Lambda function. The function is triggered by an AWS EventBridge rule every minute.

### AWS EventBridge

An EventBridge rule is created to trigger the Lambda function every minute.

### AWS S3

The `sample_records.csv` file is stored in an S3 bucket. The Lambda function fetches this file to read the records.

Package for the Lambda function is also stored in an S3 bucket, which is then used to deploy the Lambda function.

### AWS SNS

The Lambda function publishes the job status to an SNS topic.

## Supabase

The `records` database is hosted on Supabase. The Lambda function injects the transactions into this database through the REST API.

## Deployment - Terraform

The deployment of the Lambda function, EventBridge rule, and required roles is automated using Terraform. The Terraform configuration is present in the `terraform` directory.

There are also some scripts to help execute the Terraform commands with the required environment variables.

To run it locally, you will require to set the appropriate environment variables in a `.env` file in the root directory. You can check the `terraform/variables.tf` file to see the required variables.

## Creating Lambda Layer

Dependencies are installed in a Lambda layer to reduce the deployment package size and to be able to re-use the layer in multiple instances of injector lambda function, if required. The `requirements.txt` file contains the dependencies required for the Lambda function. The `create_lambda_layer.sh` script is used to create the Lambda layer. This layer is then uploaded to the AWS Lambda console.

## Creating Lambda Package

The Lambda function package is created using the `create_lambda_package.sh` script. This script creates a zip file containing the Lambda function code from `lambda/core.py`. This package is named `demo_injector_package.zip` and is uploaded to AWS S3 bucket. The Terraform configuration then uses this package to deploy the Lambda function.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Issues

If you encounter any issues or bugs while using this project, please report them by following these steps:

1. Check if the issue has already been reported by searching our [issue tracker](https://github.com/pranav-kural/transacai-demo-injector/issues).
2. If the issue hasn't been reported, create a new issue and provide a detailed description of the problem.
3. Include steps to reproduce the issue and any relevant error messages or screenshots.

[Open Issue](https://github.com/pranav-kural/transacai-demo-injector/issues/new)
