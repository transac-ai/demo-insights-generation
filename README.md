# Transac AI Demo Transactions Injector

To demonstrate the Transac AI project, there was requirement of a service that would inject transactions into the `records` database, imitating the real-time transactions being made by customers or employees.

This project holds the code for a simple Python based code program that fetches a certain number of records from `sample_records.csv` and injects them into the `records` database hosted on [Supabase](https://supabase.com/).

This python code is deployed to [AWS Lambda](https://aws.amazon.com/pm/lambda) and is scheduled to run every 10 minutes through [AWS EventBridge](https://aws.amazon.com/eventbridge/) rule.

The `sample_records.csv` file is prepared from the `data/prepare_sample_records.py` script by using a dataset containing a large amount of sample transactions. Check this Kaggle notebook for more details: [TransacAI Data Preparation](https://www.kaggle.com/code/pranavkural/transacai-data-preparation)

Code deployed to AWS Lambda is available in the `lambda/core.py` file.
