#!/bin/bash

# Create a directory for the lambda code package
mkdir -p insights_generation_lambda_pkg

# Copy the dist output folder and package.json from `lambda` folder
cp -r lambda/lib/* insights_generation_lambda_pkg

# cd into the package directory
cd insights_generation_lambda_pkg

# Install only the production dependencies with pnpm
pnpm install --prod --frozen-lockfile

# cd back to the parent directory
cd ..

# remove older zip file
rm -f terraform/packages/insights_generation_lambda_pkg.zip

# Zip the contents of the package directory
zip -r terraform/packages/insights_generation_lambda_pkg.zip insights_generation_lambda_pkg

# Remove the insights_generation_lambda_pkg directory
rm -rf insights_generation_lambda_pkg