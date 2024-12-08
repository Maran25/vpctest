variable "access_key" {
  type = string
  sensitive = true
  description = "aws account access key"
}

variable "secret_key" {
  type = string
  sensitive = true
  description = "aws account secret key"
}

variable "bucket_name" {
  type = string
  sensitive = false
  description = "name of the bucket"
}

variable "account_id" {
  type = string
  sensitive = false
  description = "aws account id"
}