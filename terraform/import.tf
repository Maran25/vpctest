data "aws_s3_object" "lambda_zip" {
  bucket = var.bucket_name
  key    = "testlambda.zip"    
}