resource "aws_iam_policy" "lambda_policy" {
  name = "lambda-policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement: [
      {
        Effect: "Allow",
        Action: [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ],
        Resource: aws_sqs_queue.sqs_queue.arn
      },
      {
        Effect: "Allow",
        Action: [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource: "arn:aws:logs:*:*:*"
      },
      {
        Effect   = "Allow",
        Action   = "s3:GetObject",
        Resource = "arn:aws:s3:::mybucket-for-vpc/testlambda.zip"
      },
      {
        Effect   = "Allow",
        Action   = [
          "ec2:CreateVpcPeeringConnection",
          "ec2:DescribeVpcPeeringConnections"
        ],
        Resource = [
          "arn:aws:ec2:eu-north-1:381491871357:vpc/vpc-09d41c0d01c807be5",    # Your VPC
          "arn:aws:ec2:eu-north-1:381491871357:vpc-peering-connection/*"      # VPC peering connection resource
        ]
      }
    ]
  })
}


resource "aws_iam_policy_attachment" "policy_attachment" {
    name = "lambda-policy-attachment"
    roles = [aws_iam_role.lambda_execution_role.name]
    policy_arn = aws_iam_policy.lambda_policy.arn
}