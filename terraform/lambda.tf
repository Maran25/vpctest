resource "aws_lambda_function" "create_vpc_peering" {
  function_name = "create_vpc_peering"
  runtime = "nodejs18.x"
  handler = "lambda_function.handler"
  role = aws_iam_role.lambda_execution_role.arn
  filename = "${path.module}/lambda_function.zip"

  environment {
    variables = {
        "SQS_QUEUE_URL" = aws_sqs_queue.sqs_queue.url
    }
  }
}

resource "aws_lambda_event_source_mapping" "sqs_to_lambda" {
  event_source_arn = aws_sqs_queue.sqs_queue.arn
  function_name    = aws_lambda_function.create_vpc_peering.arn
  batch_size       = 10
}