resource "aws_kms_key" "terraform" {
  description             = "Encryption key used for terraform related things, especially for secret manager"
  deletion_window_in_days = 7
}

resource "aws_kms_alias" "terraform" {
  name          = "alias/terraform-kms"
  target_key_id = aws_kms_key.terraform.key_id
}
