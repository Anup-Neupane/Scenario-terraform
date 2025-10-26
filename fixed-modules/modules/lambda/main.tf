resource "aws_lambda_function" "processor" {
  filename         = "function.zip"
  function_name    = "${var.project_name}-${var.environment}-file-processor"
  role             = var.lambda_role_arn
  handler          = "index.handler"
  runtime          = "python3.11"
  timeout          = 60
  memory_size      = 256
  source_code_hash = filebase64sha256("function.zip")

  environment {
    variables = {
      BUCKET = var.s3_bucket_id
    }
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_lambda_permission" "s3_permission" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.processor.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = var.s3_bucket_arn
}

resource "aws_s3_bucket_notification" "trigger" {
  bucket = var.s3_bucket_id

  lambda_function {
    lambda_function_arn = aws_lambda_function.processor.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "uploads/"
  }

  depends_on = [aws_lambda_permission.s3_permission]
}
