# Transac AI Demo Insights Generation

Transac AI project is geared towards generation of enriched summaries and insights of transactional data in real-time or batch using Generative AI and Large Language Models (LLMs).

This repository contains the code for demo insights generation. The [Transac AI Demo Transactions Injector project](https://github.com/transac-ai/demo-transactions-injector) adds transactions to the `records` database hosted on [Supabase](https://supabase.com/), imitating the real-time transactions being made by customers or employees. The Transac AI Demo Insights Generation project deploys an AWS Lambda function that reads these transactions from the `records` database, and generates insights and summaries by submitting the request for insight generation to the core [Workload Manager Service](https://github.com/transac-ai/workload-manager-service)(WMS) of Transac AI project. The WMS service then initiates the process of generating insights, which are then stored in the `insights` database and a message is published on the `new_insights` Kafka topic to inform active clients.

## Overview

At its core, a Python-based handler function is deployed as an [AWS Lambda](https://aws.amazon.com/pm/lambda) function, along with an [AWS EventBridge](https://aws.amazon.com/eventbridge/) schedule to invoke this lambda function every **10 minutes**. This handler function submits a request to the [Workload Manager Service] to generate insights and summaries of the transactions in the `records` database for a given time period and client id (e.g., `test_client`).

## AWS

This project is deployed on AWS. The Transac AI project's core services are mostly deployed on Google Cloud. However, since this demo service is completely independent of the core Transac AI services, it is deployed on AWS. This also helps establish a cross-cloud architecture, where client is independent to choose their cloud provider.

### AWS Lambda

The handler function is deployed as an AWS Lambda function. The function is triggered by an AWS EventBridge rule after every 10 minutes.

### AWS EventBridge

An EventBridge rule is created to trigger the Lambda function once every 10 minutes.

## Deployment - Terraform

The deployment of the Lambda function, EventBridge rule, and required roles is automated using Terraform. The Terraform configuration is present in the `terraform` directory.

There are also some scripts to help execute the Terraform commands with the required environment variables.

To run it locally, you will require to set the appropriate environment variables in a `.env` file in the root directory. You can check the `terraform/variables.tf` file to see the required variables.

## Creating Lambda Layer

Dependencies are installed in a Lambda layer to reduce the deployment package size and to be able to re-use the layer in multiple instances of injector lambda function, if required. The `requirements.txt` file contains the dependencies required for the Lambda function. The `create_lambda_layer.sh` script is used to create the Lambda layer. This layer is then uploaded to the AWS Lambda console.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Issues

If you encounter any issues or bugs while using this project, please report them by following these steps:

1. Check if the issue has already been reported by searching our [issue tracker](https://github.com/transac-ai/demo-insights-generation/issues).
2. If the issue hasn't been reported, create a new issue and provide a detailed description of the problem.
3. Include steps to reproduce the issue and any relevant error messages or screenshots.

[Open Issue](https://github.com/transac-ai/demo-insights-generation/issues/new)
