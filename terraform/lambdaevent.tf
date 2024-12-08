# Lambda Function
resource "aws_lambda_function" "vpc_event_processor" {
#   filename         = "your-lambda-code.zip" # Ensure this file exists and is uploaded
  function_name    = "process-vpc-events"
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "index.handler"
  runtime          = "nodejs18.x"

  s3_bucket = data.aws_s3_object.lambda_zip.bucket
  s3_key =  "eventlambda.zip" 
}

# IAM Policy for Lambda
resource "aws_iam_policy" "lambda_event_policy" {
  name   = "lambda-eventbridge-policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect   = "Allow",
        Action   = "s3:GetObject",
        Resource = "arn:aws:s3:::mybucket-for-vpc/eventlambda.zip"
      },
    ]
  })
}

# Attach IAM Policy to Role
resource "aws_iam_policy_attachment" "lambda_event_policy_attachment" {
  name       = "attach-lambda-policy"
  roles      = [aws_iam_role.lambda_execution_role.name]
  policy_arn = aws_iam_policy.lambda_event_policy.arn
}