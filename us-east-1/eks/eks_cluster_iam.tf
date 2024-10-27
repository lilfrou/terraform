# EKS Role
data "aws_iam_policy_document" "eks_trust" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole"
    ]
  }
}

resource "aws_iam_role" "eks" {
  name               = "AmazonEKSRole"
  assume_role_policy = data.aws_iam_policy_document.eks_trust.json
}

data "aws_iam_policy_document" "eks_sts" {
  statement {
    actions   = ["sts:AssumeRole"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "eks_sts" {
  name        = "EKSStsAssumeRolePolicy"
  path        = "/"
  description = "Enable EKS to assume other resources when accessing AWS APIs"
  policy      = data.aws_iam_policy_document.eks_sts.json
}

data "aws_iam_policy_document" "eks_describe_availability_zones" {
  statement {
    effect    = "Allow"
    actions   = ["ec2:DescribeAvailabilityZones"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "eks_describe_availability_zones" {
  name        = "EKSDescribeAvailabilityZonesPolicy"
  path        = "/"
  description = "Enable EKS to describe availability zones"
  policy      = data.aws_iam_policy_document.eks_describe_availability_zones.json
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_service_policy" {
  role       = aws_iam_role.eks.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_sts" {
  role       = aws_iam_role.eks.name
  policy_arn = aws_iam_policy.eks_sts.arn
}

resource "aws_iam_role_policy_attachment" "eks_describe_availability_zones" {
  role       = aws_iam_role.eks.name
  policy_arn = aws_iam_policy.eks_describe_availability_zones.arn
}

# For enabling users to administrate EKS
data "aws_iam_policy_document" "eks_users_trust" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    actions = [
      "sts:AssumeRole"
    ]
  }
}

resource "aws_iam_role" "eks_admin_access" {
  name               = "EKSAdminAccess"
  assume_role_policy = data.aws_iam_policy_document.eks_users_trust.json
}

data "aws_iam_policy_document" "eks_admin_access" {
  statement {
    actions   = ["sts:AssumeRole"]
    resources = [aws_iam_role.eks_admin_access.arn]
  }
}

resource "aws_iam_policy" "eks_admin_access" {
  name   = "EKSAdminUserAccess"
  policy = data.aws_iam_policy_document.eks_admin_access.json
}

# EKS deployer
resource "aws_iam_role" "eks_deployer" {
  name               = "EKSDeployer"
  assume_role_policy = data.aws_iam_policy_document.eks_users_trust.json
}

data "aws_iam_policy_document" "eks_deployer_access" {
  statement {
    actions   = ["sts:AssumeRole"]
    resources = [aws_iam_role.eks_deployer.arn]
  }
}

resource "aws_iam_policy" "eks_deployer" {
  name   = "EKSDeployer"
  policy = data.aws_iam_policy_document.eks_deployer_access.json
}
