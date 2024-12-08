# Grant EventBridge Permission to Invoke Lambda
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.vpc_event_processor.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.vpc_peering_events.arn
}

resource "aws_cloudwatch_event_rule" "vpc_peering_events" {
  name        = "vpc-peering-events"
  description = "Capture VPC Peering connection events"
  event_pattern = jsonencode({
    source = ["aws.ec2"],
    detail = {
      eventName = [
        "CreateVpcPeeringConnection",
        "AcceptVpcPeeringConnection",
        "RejectVpcPeeringConnection",
        "DeleteVpcPeeringConnection",
        "VpcPeeringConnectionFailed",
        "VpcPeeringConnectionExpired"
      ]
    }
  })
}

# EventBridge Target to Invoke Lambda
resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.vpc_peering_events.name
  target_id = "vpc-peering-lambda"
  arn       = aws_lambda_function.vpc_event_processor.arn
}