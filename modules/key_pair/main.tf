resource "tls_private_key" "keygen" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "local_file" "private_key_pem" {
  filename = var.private_key_file
  content = tls_private_key.keygen.private_key_pem
  file_permission = "0400"
}

resource "local_file" "public_key_openssh" {
  filename = var.public_key_file
  content = tls_private_key.keygen.public_key_openssh
  file_permission = "0600"
}

