
# S3 Bucket for Terraform State
resource "aws_s3_bucket" "terraform_state" {
  bucket = "lilfrou-terraform-state"
  tags = {
    Name = "Terraform State Bucket"
  }

}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Set the server-side encryption configuration for the S3 bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = data.terraform_remote_state.kms.outputs.kms_arn # Use the KMS Key ID
    }
    bucket_key_enabled = true
  }
}

# S3 Bucket Policy
resource "aws_s3_bucket_policy" "terraform_state_policy" {
  bucket = aws_s3_bucket.terraform_state.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_AdministratorAccess_39786f9038456b73"
        },
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ],
        Resource = "arn:aws:s3:::${aws_s3_bucket.terraform_state.id}"
      },
      {
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_AdministratorAccess_39786f9038456b73"
        },
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ],
        Resource = "arn:aws:s3:::${aws_s3_bucket.terraform_state.id}/*"
      }
    ]
  })
}
