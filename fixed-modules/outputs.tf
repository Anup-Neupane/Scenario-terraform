output "app_bucket_name" {
  description = "Name of the application S3 bucket"
  value       = module.s3_app.bucket_name
}

output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = module.lambda.lambda_name
}

output "lambda_function_arn" {
  description = "ARN of the Lambda function"
  value       = module.lambda.lambda_arn
}

output "lambda_role_arn" {
  description = "ARN of the Lambda IAM role"
  value       = module.iam.lambda_role_arn
}
