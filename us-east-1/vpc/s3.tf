resource "aws_s3_bucket" "vpc_log_s3_bucket" {
  bucket = "main-vpc-flow-logs-lilfrou"
}

resource "aws_s3_bucket_policy" "vpc_log_s3_bucket" {
  bucket = aws_s3_bucket.vpc_log_s3_bucket.id
  policy = data.aws_iam_policy_document.vpc_log_s3_bucket.json
}

resource "aws_s3_bucket_lifecycle_configuration" "lifecycle_rule" {
  bucket = aws_s3_bucket.vpc_log_s3_bucket.id

  rule {
    id     = "retention_1_year"
    status = "Enabled"
    expiration {
      days = 365
    }
  }
}

data "aws_caller_identity" "current" {}

locals {
  aws_account_id = data.aws_caller_identity.current.account_id
}

data "aws_iam_policy_document" "vpc_log_s3_bucket" {
  version = "2012-10-17"
  statement {
    sid    = "AWSLogDeliveryWrite"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.vpc_log_s3_bucket.arn}/*"]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [local.aws_account_id]
    }

    condition {
      test     = "StringEquals"
      values   = ["bucket-owner-full-control"]
      variable = "s3:x-amz-acl"
    }
    condition {
      test     = "ArnLike"
      values   = ["arn:aws:logs:*:${local.aws_account_id}:*"]
      variable = "aws:SourceArn"
    }
  }
  statement {
    sid    = "AWSLogDeliveryAclCheck"
    effect = "Allow"
    principals {
      identifiers = ["delivery.logs.amazonaws.com"]
      type        = "Service"
    }

    actions = [
      "s3:GetBucketAcl",
      "s3:ListBucket"
    ]
    resources = [aws_s3_bucket.vpc_log_s3_bucket.arn]
    condition {
      test     = "StringEquals"
      values   = [local.aws_account_id]
      variable = "aws:SourceAccount"
    }
    condition {
      test     = "ArnLike"
      values   = ["arn:aws:logs:*:${local.aws_account_id}:*"]
      variable = "aws:SourceArn"
    }
  }
}
