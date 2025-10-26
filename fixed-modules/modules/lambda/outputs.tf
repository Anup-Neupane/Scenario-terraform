output "lambda_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.processor.arn
}

output "lambda_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.processor.function_name
}
