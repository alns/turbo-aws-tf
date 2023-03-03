variable "aws_region" {
  description = "Region for login and bucket"
  default     = "us-east-1"
}

variable "aws_access_key" {
  description = "Turbo user access key"
  default     = "Update a local copy of this file or pass in overrides"
}

variable "aws_secret_key" {
  description = "Turbo user secret key"
  default     = "Update a local copy of this file or pass in overrides"
}

variable "bucket_name" {
  description = "lower case bucket name"
  default     = "test_bucket"
}

variable "rw_user" {
  default = 0
}

variable "user_name" {
  description = "If set to true, turbo users joins RW group"
  default     = "username"
}
