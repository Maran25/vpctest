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