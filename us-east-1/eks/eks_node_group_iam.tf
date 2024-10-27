data "aws_iam_policy_document" "node_instance_trust" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole"
    ]
  }
}

resource "aws_iam_role" "eks_node_instance" {
  name               = "EKSNodeInstance"
  assume_role_policy = data.aws_iam_policy_document.node_instance_trust.json
}

data "aws_iam_policy_document" "secretsmanager_readonly" {
  statement {
    actions = [
      "secretsmanager:ListSecretVersionIds",
      "secretsmanager:GetSecretValue",
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetRandomPassword",
      "secretsmanager:DescribeSecret",
      "kms:Decrypt"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "secretsmanager_readonly" {
  name   = "SecretsManagerReadonly"
  path   = "/"
  policy = data.aws_iam_policy_document.secretsmanager_readonly.json
}


resource "aws_iam_role_policy_attachment" "secret_manager_readonly" {
  role       = aws_iam_role.eks_node_instance.name
  policy_arn = aws_iam_policy.secretsmanager_readonly.arn
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  role       = aws_iam_role.eks_node_instance.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  role       = aws_iam_role.eks_node_instance.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "ec2_container_registry_readonly" {
  role       = aws_iam_role.eks_node_instance.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}
