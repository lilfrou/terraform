resource "tls_private_key" "lilfrou_bot" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "lilfrou_bot" {
  key_name   = "lilfrou-bot"
  public_key = tls_private_key.lilfrou_bot.public_key_openssh
}

resource "aws_secretsmanager_secret" "lilfrou_bot_secret" {
  name       = "lilfrou-key"
  kms_key_id = "arn:aws:kms:us-east-1:615324611841:key/742b33c7-6cb5-484a-a84f-37713121c405"
}

resource "aws_secretsmanager_secret_version" "lilfrou_bot_secret_version" {
  secret_id = aws_secretsmanager_secret.lilfrou_bot_secret.id
  secret_string = jsonencode({
    private_key = tls_private_key.lilfrou_bot.private_key_pem
    public_key  = tls_private_key.lilfrou_bot.public_key_openssh
  })
}
