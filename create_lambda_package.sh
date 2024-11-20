#!/bin/bash

# Create a temporary directory
mkdir tmp

# Copy the lambda function & requirements file to the temporary directory
cp lambda/core.py tmp/
# cp requirements.txt tmp/

# cd into the temporary directory
cd tmp

# Below commented out since we are using separate Lambda layer for dependencies
# Install the required packages in the temporary directory
# pip install -r requirements.txt -t .

# Delete older zip file
rm -f ../demo_injector_package.zip

# Zip the contents of the temporary directory
zip -r demo_injector_package.zip .

# Move the zip file to the parent directory
mv demo_injector_package.zip ..

# cd back to the parent directory
cd ..

# Remove the temporary directory
rm -r tmp