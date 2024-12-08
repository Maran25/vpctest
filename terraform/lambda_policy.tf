resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement: [
      {
        Effect: "Allow",
        Principal: {
          Service: "lambda.amazonaws.com"
        },
        Action: "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_policy" {
  name = "lambda-policy"
  policy = jsonencode({
    Version: "2012-10-17",
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
        Effect   = "Allow"
        Action   = "s3:GetObject"
        Resource = "arn:aws:s3:::mybucket-for-vpc/testlambda.zip"
      },
      {
        Effect   = "Allow",
        Action   = ["ec2:CreateVpcPeeringConnection"],
        Resource = "arn:aws:ec2:eu-north-1:381491871357:vpc/vpc-09d41c0d01c807be5"
      },
      {
        Effect   = "Allow",
        Action   = ["ec2:DescribeVpcPeeringConnections"],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "policy_attachment" {
    name = "lambda-policy-attachment"
    roles = [aws_iam_role.lambda_execution_role.name]
    policy_arn = aws_iam_policy.lambda_policy.arn
}