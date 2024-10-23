resource "aws_iam_role" "flowlog" {
  name = "FlowLogsRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
    ]
  })
  tags = {
    tfstate = "iam.tfstate"
  }
}

resource "aws_iam_policy" "flowlog" {
  name        = "VPCFlowLog"
  description = "Policy to create Cloudwatch logs for VPC Flow Logs"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = ""
        Action = [
          "logs:PutLogEvents",
          "logs:DescribeLogStreams",
          "logs:DescribeLogGroups",
          "logs:CreateLogStream",
          "logs:CreateLogGroup",
          "logs:CreateLogDelivery",
          "logs:DeleteLogDelivery"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
  tags = {
    tfstate = "iam.tfstate"
  }
}

resource "aws_iam_role_policy_attachment" "flowlog" {
  role       = aws_iam_role.flowlog.name
  policy_arn = aws_iam_policy.flowlog.arn
}
