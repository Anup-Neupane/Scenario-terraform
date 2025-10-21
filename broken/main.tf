# broken/main.tf

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

# Step 1: Create S3 bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = "fuse-demo67"
}

# Step 2: Create IAM role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "my-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# Step 3: Create policy for S3 access
resource "aws_iam_policy" "s3_policy" {
  name = "lambda-SSS-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "s3:GetObject",
        "s3:ListBucket"
      ]
      Resource = [
        aws_s3_bucket.my_bucket.arn,
        "${aws_s3_bucket.my_bucket.arn}/*"
      ]
    }]
  })
}

# Step 4: Attach policy to role
resource "aws_iam_role_policy_attachment" "s3_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.s3_policy.arn
}

# Step 5: Attach CloudWatch logs policy
resource "aws_iam_role_policy_attachment" "logs_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# ❌ PROBLEM: Lambda starts before policies are attached!
resource "aws_lambda_function" "processor" {
  filename      = "function.zip"
  function_name = "file-processor"
  role          = aws_iam_role.lambda_role.arn  # Only waits for role, not attachments!
  handler       = "index.handler"
  runtime       = "python3.11"

  environment {
    variables = {
      BUCKET = aws_s3_bucket.my_bucket.id
    }
  }
}

# S3 trigger
resource "aws_lambda_permission" "s3_permission" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.processor.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.my_bucket.arn
}

resource "aws_s3_bucket_notification" "trigger" {
  bucket = aws_s3_bucket.my_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.processor.arn
    events              = ["s3:ObjectCreated:*"]
  }
}
