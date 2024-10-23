module "main" {
  source = "git::ssh://git@github.com/lilfrou/terraform-modules.git//vpc?ref=v1.0.0"

  vpc_name              = "main"
  vpc_region            = "us-east-1"
  region_azs            = ["a", "c", "d"]
  cidr_prefix           = "10.10"
  vpc_flow_log_iam_arn  = aws_iam_role.flowlog.arn
  enable_log_to_s3      = true
  vpc_log_s3_bucket_arn = aws_s3_bucket.vpc_log_s3_bucket.arn
}
