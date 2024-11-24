#!/bin/bash

# Create a directory for the lambda code package
mkdir -p insights_generation_lambda_pkg

# Copy the dist output folder and package.json from `lambda` folder
cp -r lambda/lib/* insights_generation_lambda_pkg
cp lambda/package.json insights_generation_lambda_pkg
cp lambda/pnpm-lock.yaml insights_generation_lambda_pkg

# cd into the package directory
cd insights_generation_lambda_pkg

# Install only the production dependencies with pnpm
pnpm install --prod --frozen-lockfile

# Zip contents into a package
zip -r insights_generation_lambda_pkg.zip .

# cd back to the parent directory
cd ..

# remove older zip file
rm -f terraform/insights_generation_lambda_pkg.zip

# Move the zip file to the terraform directory
mv insights_generation_lambda_pkg/insights_generation_lambda_pkg.zip terraform

# Remove the insights_generation_lambda_pkg directory
# rm -rf insights_generation_lambda_pkg