resource "aws_sqs_queue" "sqs_queue" {
    name = "test_sqs_queue"
}

resource "aws_sqs_queue_policy" "name" {
  queue_url = aws_sqs_queue.sqs_queue.url

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = "sqs:SendMessage",
        Resource  = aws_sqs_queue.sqs_queue.arn,
        Condition = {
          ArnEquals = {
            "aws:SourceArn": aws_sns_topic.sns_topic.arn
          }
        }
      }
    ]
  })
}