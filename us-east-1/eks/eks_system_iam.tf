# Service account setting

data "tls_certificate" "main_tls_certificate" {
  url = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "main_connect" {
  url             = aws_eks_cluster.main.identity[0].oidc[0].issuer
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.main_tls_certificate.certificates[0].sha1_fingerprint]
}

# # External DNS settings
# data "aws_iam_policy_document" "staging-external-dns-trust" {
#   statement {
#     principals {
#       type        = "Federated"
#       identifiers = [aws_iam_openid_connect_provider.staging-eks.arn]
#     }

#     actions = ["sts:AssumeRoleWithWebIdentity"]

#     condition {
#       test     = "StringEquals"
#       variable = "${local.staging_oidc_issuer}:sub"
#       values   = ["system:serviceaccount:external-dns:external-dns"]
#     }
#   }
# }

# resource "aws_iam_role" "staging-external-dns" {
#   name               = "StagingK8SExternalDNS"
#   assume_role_policy = data.aws_iam_policy_document.staging-external-dns-trust.json
# }

# data "aws_iam_policy_document" "staging-external-dns-policy" {
#   statement {
#     actions   = ["route53:ChangeResourceRecordSets"]
#     resources = ["arn:aws:route53:::hostedzone/*"]
#   }

#   statement {
#     actions = [
#       "route53:ListHostedZones",
#       "route53:ListResourceRecordSets"
#     ]
#     resources = ["*"]
#   }
# }

# resource "aws_iam_role_policy" "staging-external-dns-policy" {
#   name   = "ExternalDNS"
#   role   = aws_iam_role.staging-external-dns.name
#   policy = data.aws_iam_policy_document.staging-external-dns-policy.json
# }

# # CertManager settings
# data "aws_iam_policy_document" "staging-certmanager-trust" {
#   statement {
#     principals {
#       type        = "Federated"
#       identifiers = [aws_iam_openid_connect_provider.staging-eks.arn]
#     }

#     actions = ["sts:AssumeRoleWithWebIdentity"]

#     condition {
#       test     = "StringEquals"
#       variable = "${local.staging_oidc_issuer}:sub"
#       values   = ["system:serviceaccount:cert-manager:cert-manager"]
#     }
#   }
# }

# resource "aws_iam_role" "staging-certmanager" {
#   name               = "StagingCertManager"
#   assume_role_policy = data.aws_iam_policy_document.staging-certmanager-trust.json
# }

# data "aws_iam_policy_document" "staging-certmanager" {
#   statement {
#     actions   = ["route53:GetChange"]
#     resources = ["arn:aws:route53:::change/*"]
#   }

#   statement {
#     actions = [
#       "route53:ChangeResourceRecordSets",
#       "route53:ListResourceRecordSets"
#     ]
#     resources = ["arn:aws:route53:::hostedzone/*"]
#   }

#   statement {
#     actions   = ["route53:ListHostedZonesByName"]
#     resources = ["*"]
#   }
# }

# resource "aws_iam_role_policy" "staging-certmanager" {
#   name   = "CertManager"
#   role   = aws_iam_role.staging-certmanager.name
#   policy = data.aws_iam_policy_document.staging-certmanager.json
# }

# # ClusterAutoscaler settings
# data "aws_iam_policy_document" "staging-cluster-autoscaler-trust" {
#   statement {
#     principals {
#       type        = "Federated"
#       identifiers = [aws_iam_openid_connect_provider.staging-eks.arn]
#     }

#     actions = ["sts:AssumeRoleWithWebIdentity"]

#     condition {
#       test     = "StringEquals"
#       variable = "${local.staging_oidc_issuer}:sub"
#       values   = ["system:serviceaccount:kube-system:cluster-autoscaler"]
#     }
#   }
# }

# resource "aws_iam_role" "staging-cluster-autoscaler" {
#   name               = "StagingClusterAutoscaler"
#   assume_role_policy = data.aws_iam_policy_document.staging-cluster-autoscaler-trust.json
# }

# data "aws_iam_policy_document" "staging-cluster-autoscaler" {
#   statement {
#     actions = [
#       "autoscaling:DescribeAutoScalingGroups",
#       "autoscaling:DescribeAutoScalingInstances",
#       "autoscaling:DescribeLaunchConfigurations",
#       "autoscaling:SetDesiredCapacity",
#       "autoscaling:TerminateInstanceInAutoScalingGroup",
#       "autoscaling:DescribeTags",
#       "ec2:DescribeLaunchTemplateVersions",
#       "ec2:DescribeInstanceTypes",
#       "eks:DescribeNodegroup"
#     ]
#     resources = ["*"]
#   }
# }

# resource "aws_iam_role_policy" "staging-cluster-autoscaler" {
#   name   = "ClusterAutoscaler"
#   role   = aws_iam_role.staging-cluster-autoscaler.name
#   policy = data.aws_iam_policy_document.staging-cluster-autoscaler.json
# }

# # External Secrets
# data "aws_iam_policy_document" "staging-externalsecrets-trust" {
#   statement {
#     sid     = "StagingSecretsReadonly"
#     actions = ["sts:AssumeRoleWithWebIdentity"]

#     principals {
#       type        = "Federated"
#       identifiers = [aws_iam_openid_connect_provider.staging-eks.arn]
#     }

#     condition {
#       test     = "StringEquals"
#       variable = "${local.staging_oidc_issuer}:sub"
#       values = [
#         "system:serviceaccount:external-secrets:external-secrets",
#         "system:serviceaccount:external-secrets-operator:aws-secret-manager",
#       ]
#     }
#   }
# }

# resource "aws_iam_role" "staging-externalsecrets" {
#   name               = "StagingExternalSecretsReadonlyAccess"
#   assume_role_policy = data.aws_iam_policy_document.staging-externalsecrets-trust.json
# }

# resource "aws_iam_role_policy_attachment" "staging-externalsecrets-readonly" {
#   role       = aws_iam_role.staging-externalsecrets.name
#   policy_arn = aws_iam_policy.secretsmanager-readonly.arn
# }

# ####### ####### ####### ####### ####### ####### ####### ####### ####### ####### ####### #######
# ####### ####### ####### ####### ####### ####### ####### ####### ####### ####### ####### #######
# # EBS CSI Driver
# ####### ####### ####### ####### ####### ####### ####### ####### ####### ####### ####### #######
# ####### ####### ####### ####### ####### ####### ####### ####### ####### ####### ####### #######
# resource "aws_iam_role" "staging_ebs_csi_driver" {
#   name               = "EksStagingAwsEbsCsiDriverRole"
#   assume_role_policy = data.aws_iam_policy_document.staging_ebs_csi_driver_trust.json
# }

# data "aws_iam_policy" "ebs_csi_driver" {
#   arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
# }

# data "aws_iam_policy_document" "staging_ebs_csi_driver_trust" {
#   statement {
#     sid = "StagingClusterAccess"
#     principals {
#       type        = "Federated"
#       identifiers = [aws_iam_openid_connect_provider.staging-eks.arn]
#     }

#     actions = ["sts:AssumeRoleWithWebIdentity"]

#     condition {
#       test     = "StringLike"
#       variable = "${local.staging_oidc_issuer}:sub"
#       values   = ["system:serviceaccount:kube-system:ebs-csi-*"]
#     }
#   }
# }

# resource "aws_iam_role_policy_attachment" "staging_ebs_csi_driver" {
#   role       = aws_iam_role.staging_ebs_csi_driver.name
#   policy_arn = data.aws_iam_policy.ebs_csi_driver.arn
# }

# # AWSLoadBalancerController settings
# resource "aws_iam_role" "staging_aws_load_balancer_controller" {
#   name               = "StagingAWSLoadBalancerController"
#   assume_role_policy = data.aws_iam_policy_document.staging_aws_load_balancer_controller_trust.json
# }

# data "aws_iam_policy_document" "staging_aws_load_balancer_controller_trust" {
#   statement {
#     principals {
#       type        = "Federated"
#       identifiers = [aws_iam_openid_connect_provider.staging-eks.arn]
#     }

#     actions = ["sts:AssumeRoleWithWebIdentity"]

#     condition {
#       test     = "StringEquals"
#       variable = "${local.staging_oidc_issuer}:sub"
#       values   = ["system:serviceaccount:aws-load-balancer-controller:aws-load-balancer-controller"]
#     }
#   }
# }

# data "aws_iam_policy_document" "staging_aws_load_balancer_controller" {
#   // Refs: https://github.com/kubernetes-sigs/aws-load-balancer-controller/blob/49805eac72ec533acdbc2580d6f57c68a9cad45c/docs/install/iam_policy.json
#   statement {
#     actions   = ["iam:CreateServiceLinkedRole"]
#     resources = ["*"]
#     condition {
#       test     = "StringEquals"
#       variable = "iam:AWSServiceName"
#       values   = ["elasticloadbalancing.amazonaws.com"]
#     }
#   }
#   statement {
#     actions = [
#       "ec2:DescribeAccountAttributes",
#       "ec2:DescribeAddresses",
#       "ec2:DescribeAvailabilityZones",
#       "ec2:DescribeInternetGateways",
#       "ec2:DescribeVpcs",
#       "ec2:DescribeVpcPeeringConnections",
#       "ec2:DescribeSubnets",
#       "ec2:DescribeSecurityGroups",
#       "ec2:DescribeInstances",
#       "ec2:DescribeNetworkInterfaces",
#       "ec2:DescribeTags",
#       "ec2:GetCoipPoolUsage",
#       "ec2:DescribeCoipPools",
#       "elasticloadbalancing:DescribeLoadBalancers",
#       "elasticloadbalancing:DescribeLoadBalancerAttributes",
#       "elasticloadbalancing:DescribeListeners",
#       "elasticloadbalancing:DescribeListenerCertificates",
#       "elasticloadbalancing:DescribeListenerAttributes",
#       "elasticloadbalancing:DescribeSSLPolicies",
#       "elasticloadbalancing:DescribeRules",
#       "elasticloadbalancing:DescribeTargetGroups",
#       "elasticloadbalancing:DescribeTargetGroupAttributes",
#       "elasticloadbalancing:DescribeTargetHealth",
#       "elasticloadbalancing:DescribeTags"
#     ]
#     resources = ["*"]
#   }
#   statement {
#     actions = [
#       "cognito-idp:DescribeUserPoolClient",
#       "acm:ListCertificates",
#       "acm:DescribeCertificate",
#       "iam:ListServerCertificates",
#       "iam:GetServerCertificate",
#       "waf-regional:GetWebACL",
#       "waf-regional:GetWebACLForResource",
#       "waf-regional:AssociateWebACL",
#       "waf-regional:DisassociateWebACL",
#       "wafv2:GetWebACL",
#       "wafv2:GetWebACLForResource",
#       "wafv2:AssociateWebACL",
#       "wafv2:DisassociateWebACL",
#       "shield:GetSubscriptionState",
#       "shield:DescribeProtection",
#       "shield:CreateProtection",
#       "shield:DeleteProtection"
#     ]
#     resources = ["*"]
#   }
#   statement {
#     actions = [
#       "ec2:AuthorizeSecurityGroupIngress",
#       "ec2:RevokeSecurityGroupIngress"
#     ]
#     resources = ["*"]
#   }
#   statement {
#     actions   = ["ec2:CreateSecurityGroup"]
#     resources = ["*"]
#   }
#   statement {
#     actions   = ["ec2:CreateTags"]
#     resources = ["arn:aws:ec2:*:*:security-group/*"]
#     condition {
#       test     = "StringEquals"
#       variable = "ec2:CreateAction"
#       values   = ["CreateSecurityGroup"]
#     }
#     condition {
#       test     = "Null"
#       variable = "aws:RequestTag/elbv2.k8s.aws/cluster"
#       values   = ["false"]
#     }
#   }
#   statement {
#     actions = [
#       "ec2:CreateTags",
#       "ec2:DeleteTags"
#     ]
#     resources = ["arn:aws:ec2:*:*:security-group/*"]
#     condition {
#       test     = "Null"
#       variable = "aws:RequestTag/elbv2.k8s.aws/cluster"
#       values   = ["true"]
#     }
#     condition {
#       test     = "Null"
#       variable = "aws:ResourceTag/elbv2.k8s.aws/cluster"
#       values   = ["false"]
#     }
#   }
#   statement {
#     actions = [
#       "ec2:AuthorizeSecurityGroupIngress",
#       "ec2:RevokeSecurityGroupIngress",
#       "ec2:DeleteSecurityGroup"
#     ]
#     resources = ["*"]
#     condition {
#       test     = "Null"
#       variable = "aws:ResourceTag/elbv2.k8s.aws/cluster"
#       values   = ["false"]
#     }
#   }
#   statement {
#     actions = [
#       "elasticloadbalancing:CreateLoadBalancer",
#       "elasticloadbalancing:CreateTargetGroup"
#     ]
#     resources = ["*"]
#     condition {
#       test     = "Null"
#       variable = "aws:RequestTag/elbv2.k8s.aws/cluster"
#       values   = ["false"]
#     }
#   }
#   statement {
#     actions = [
#       "elasticloadbalancing:CreateListener",
#       "elasticloadbalancing:DeleteListener",
#       "elasticloadbalancing:CreateRule",
#       "elasticloadbalancing:DeleteRule"
#     ]
#     resources = ["*"]
#   }
#   statement {
#     actions = [
#       "elasticloadbalancing:AddTags",
#       "elasticloadbalancing:RemoveTags"
#     ]
#     resources = [
#       "arn:aws:elasticloadbalancing:*:*:targetgroup/*/*",
#       "arn:aws:elasticloadbalancing:*:*:loadbalancer/net/*/*",
#       "arn:aws:elasticloadbalancing:*:*:loadbalancer/app/*/*"
#     ]
#     condition {
#       test     = "Null"
#       variable = "aws:RequestTag/elbv2.k8s.aws/cluster"
#       values   = ["true"]
#     }
#     condition {
#       test     = "Null"
#       variable = "aws:ResourceTag/elbv2.k8s.aws/cluster"
#       values   = ["false"]
#     }
#   }
#   statement {
#     actions = [
#       "elasticloadbalancing:AddTags",
#       "elasticloadbalancing:RemoveTags"
#     ]
#     resources = [
#       "arn:aws:elasticloadbalancing:*:*:listener/net/*/*/*",
#       "arn:aws:elasticloadbalancing:*:*:listener/app/*/*/*",
#       "arn:aws:elasticloadbalancing:*:*:listener-rule/net/*/*/*",
#       "arn:aws:elasticloadbalancing:*:*:listener-rule/app/*/*/*"
#     ]
#   }
#   statement {
#     actions = [
#       "elasticloadbalancing:ModifyLoadBalancerAttributes",
#       "elasticloadbalancing:SetIpAddressType",
#       "elasticloadbalancing:SetSecurityGroups",
#       "elasticloadbalancing:SetSubnets",
#       "elasticloadbalancing:DeleteLoadBalancer",
#       "elasticloadbalancing:ModifyTargetGroup",
#       "elasticloadbalancing:ModifyTargetGroupAttributes",
#       "elasticloadbalancing:DeleteTargetGroup"
#     ]
#     resources = ["*"]
#     condition {
#       test     = "Null"
#       variable = "aws:ResourceTag/elbv2.k8s.aws/cluster"
#       values   = ["false"]
#     }
#   }
#   statement {
#     actions = [
#       "elasticloadbalancing:AddTags"
#     ]
#     resources = [
#       "arn:aws:elasticloadbalancing:*:*:targetgroup/*/*",
#       "arn:aws:elasticloadbalancing:*:*:loadbalancer/net/*/*",
#       "arn:aws:elasticloadbalancing:*:*:loadbalancer/app/*/*"
#     ]
#     condition {
#       test     = "StringEquals"
#       variable = "elasticloadbalancing:CreateAction"
#       values = [
#         "CreateTargetGroup",
#         "CreateLoadBalancer"
#       ]
#     }
#     condition {
#       test     = "Null"
#       variable = "aws:RequestTag/elbv2.k8s.aws/cluster"
#       values   = ["false"]
#     }
#   }
#   statement {
#     actions = [
#       "elasticloadbalancing:RegisterTargets",
#       "elasticloadbalancing:DeregisterTargets"
#     ]
#     resources = ["arn:aws:elasticloadbalancing:*:*:targetgroup/*/*"]
#   }
#   statement {
#     actions = [
#       "elasticloadbalancing:SetWebAcl",
#       "elasticloadbalancing:ModifyListener",
#       "elasticloadbalancing:AddListenerCertificates",
#       "elasticloadbalancing:RemoveListenerCertificates",
#       "elasticloadbalancing:ModifyRule",
#       "elasticloadbalancing:ModifyListenerAttributes"
#     ]
#     resources = ["*"]
#   }
# }

# resource "aws_iam_role_policy" "staging_aws_load_balancer_controller" {
#   name   = "AWSLoadBalancerController"
#   role   = aws_iam_role.staging_aws_load_balancer_controller.name
#   policy = data.aws_iam_policy_document.staging_aws_load_balancer_controller.json
# }
