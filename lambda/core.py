import os
import pandas as pd
import random
from supabase import create_client, Client
import boto3

def inject_sample_transactions():
  """
  Method to prepare sample records and insert them into Supabase table.

  Steps:
  1. Read data from CSV file.
  2. Select n records at random.
  3. Add "completed_at" column with current timestamp.
  4. Connect to Supabase client.
  5. Bulk insert records.
  6. Publish job status to AWS SNS.
  """

  """
  Verify all required environment variables are set
  """
  required_env_vars = [
    "SUPABASE_URL",
    "SUPABASE_KEY",
    "SNS_TOPIC_ARN",
    "S3_BUCKET_NAME",
    "S3_KEY"
  ]
  for env_var in required_env_vars:
    if os.environ.get(env_var) is None:
      raise Exception(f"{env_var} environment variable is not set")
    
  """
  Get sample data from AWS S3
  """
  # Read data to pandas dataframe
  s3 = boto3.client('s3')
  s3_bucket_name = os.environ.get("S3_BUCKET_NAME")
  s3_key = os.environ.get("S3_KEY")
  obj = s3.get_object(Bucket=s3_bucket_name, Key=s3_key)
  df = pd.read_csv(obj['Body'])

  """
  Select n records
  """
  # n can be 2 to 4 at random
  n = random.randint(2, 4)
  df_n = df.sample(n).reset_index(drop=True)

  """
  Add "completed_at" column with current timestamp
  """
  df_n['completed_at'] = pd.Timestamp.now()

  """
  Connect to Supabase client
  """
  url: str = os.environ.get("SUPABASE_URL")
  key: str = os.environ.get("SUPABASE_KEY")
  supabase: Client = create_client(url, key)

  """
  AWS SNS client to publish job status
  """
  sns = boto3.client('sns')

  """
  Bulk insert records
  """
  try:
    # Insert records
    supabase.table("records").insert(df_n.to_dict(orient='records')).execute()
    # Publish job status
    sns.publish(
      TopicArn=os.environ.get("SNS_TOPIC_ARN"),
      Message=f"SUCCESS. Inserted {n} records. Time: {pd.Timestamp.now()}"
    )
  except Exception as e:
    # Publish job status
    sns.publish(
      TopicArn=os.environ.get("SNS_TOPIC_ARN"),
      Message=f"FAILED. Error: {str(e)}. Time: {pd.Timestamp.now()}"
    )