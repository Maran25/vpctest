resource "aws_sns_topic" "sns_topic" {
  name = "test_sns_topic"
}

resource "aws_sns_topic_subscription" "queue_url_subscription" {
  topic_arn = aws_sns_topic.sns_topic.arn
  endpoint = aws_sqs_queue.sqs_queue.arn
  protocol = "sqs"
  filter_policy = {
    "event": "CreateVpc"
  }
}