output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.my_bucket.id
}

output "lambda_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.processor.arn
}

output "lambda_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.processor.function_name
}
