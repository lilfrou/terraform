# Kubernetes cluster staging
resource "aws_eks_cluster" "main" {
  name     = "main"
  version  = "1.31"
  role_arn = aws_iam_role.eks.arn

  access_config {
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = false
  }

  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs     = ["0.0.0.0/0"]

    subnet_ids = local.main_vpc_subnet_ids

    security_group_ids = [
      data.terraform_remote_state.vpc.outputs.main_vpc_security_group_id
    ]
  }

  encryption_config {
    resources = ["secrets"]

    provider {
      key_arn = data.terraform_remote_state.kms.outputs.kms_arn # Use the KMS Key ID
    }
  }

  enabled_cluster_log_types = []

  depends_on = [aws_iam_role.eks]
}

######## ######## ######## ######## ######## ######## ######## ######## ######## ######## ########
######## ######## ######## ######## ######## ######## ######## ######## ######## ######## ########
#
# EKS ADDONS
#
# These should match node version not cluster version
# Check the links for compatible versions for the current version of your nodes/cluster
######## ######## ######## ######## ######## ######## ######## ######## ######## ######## ########
######## ######## ######## ######## ######## ######## ######## ######## ######## ######## ########

# https://docs.aws.amazon.com/eks/latest/userguide/managing-kube-proxy.html
# https://kubernetes.io/releases/version-skew-policy/#kube-proxy

