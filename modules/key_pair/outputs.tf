output "private_key_file" {
  value = var.private_key_file
}

output "private_key_pem" {
  value = tls_private_key.keygen.private_key_pem
}

output "public_key_file" {
  value = var.public_key_file
}

output "public_key_openssh" {
  value = tls_private_key.keygen.public_key_openssh
}

resource "aws_key_pair" "key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.keygen.public_key_openssh
}

output "key_name" {
  value = aws_key_pair.key_pair.key_name
}