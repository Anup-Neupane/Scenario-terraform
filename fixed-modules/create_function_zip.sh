#!/bin/bash

echo "Creating Lambda function ZIP package..."

# Create the ZIP file
cd lambda_function
zip -r ../function.zip .
cd ..

echo "ZIP package created: function.zip"

# List contents to verify
echo "ZIP contents:"
unzip -l function.zip
