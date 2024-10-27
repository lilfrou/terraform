locals {
  main_vpc_subnet_ids = concat(
    data.terraform_remote_state.vpc.outputs.main_vpc_public_subnet_ids,
    data.terraform_remote_state.vpc.outputs.main_vpc_private_a_subnet_ids,
    data.terraform_remote_state.vpc.outputs.main_vpc_private_b_subnet_ids
  )

  main_vpc_private_subnet_ids = concat(
    data.terraform_remote_state.vpc.outputs.main_vpc_private_a_subnet_ids,
    data.terraform_remote_state.vpc.outputs.main_vpc_private_b_subnet_ids
  )
  staging_oidc_issuer = replace(aws_eks_cluster.main.identity[0].oidc[0].issuer, "https://", "")
}
