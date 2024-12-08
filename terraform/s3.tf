resource "aws_s3_bucket" "cloudtrail_bucket" {
  bucket = "cloudtrail-logs-${var.account_id}"
}