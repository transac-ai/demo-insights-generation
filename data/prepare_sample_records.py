"""
Code to prepare the data file from which sample transaction records can be selected to be used for Transac AI demo.
Transactions selected at random from this file will imitate the transactions that are made by customers of a hypothetical business.

This program reads input CSV file, removes some columns, shuffles the records, and keeps only the first 1000 records. 
The result is stored in the `sample_records` CSV file.
"""
import pandas as pd
import os

# Read the CSV file into a pandas dataframe
input_filename = 'transac_sample_v1.csv'
input_filepath = os.path.join(os.path.dirname(__file__), input_filename)
df = pd.read_csv(input_filepath)

# Remove the 'completed_at' column
df = df.drop(columns=['completed_at', 'street', 'gender'])

# Shuffle and keep only the first 1000 records
df = df.sample(frac=1).reset_index(drop=True)
df = df.head(1000)

# Store the result in a new CSV file
output_filename = 'sample_records.csv'
output_filepath = os.path.join(os.path.dirname(__file__), output_filename)
df.to_csv(output_filepath, index=False)