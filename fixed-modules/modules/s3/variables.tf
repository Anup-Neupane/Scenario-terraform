variable "bucket_suffix" {
  description = "Unique suffix for bucket name"
  type        = string
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment for resource naming"
  type        = string
}

variable "is_backend_bucket" {
  description = "Whether this is a backend state bucket"
  type        = bool
  default     = false
}

variable "versioning_enabled" {
  description = "Enable versioning for the bucket"
  type        = bool
  default     = false
}
