# Application resources only
module "s3_app" {
  source = "./modules/s3"
  
  bucket_suffix = "${var.bucket_suffix}-app"
  project_name  = var.project_name
  environment   = var.environment
  is_backend_bucket = false
  versioning_enabled = true
}

module "iam" {
  source = "./modules/iam"
  
  project_name    = var.project_name
  environment     = var.environment
  s3_bucket_arn   = module.s3_app.bucket_arn
  s3_bucket_id    = module.s3_app.bucket_id
}

module "lambda" {
  source = "./modules/lambda"
  
  project_name      = var.project_name
  environment       = var.environment
  lambda_role_arn   = module.iam.lambda_role_arn
  s3_bucket_id      = module.s3_app.bucket_id
  s3_bucket_arn     = module.s3_app.bucket_arn
  
  depends_on = [
    module.iam
  ]
}
