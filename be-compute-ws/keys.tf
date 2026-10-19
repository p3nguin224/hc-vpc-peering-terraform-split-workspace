resource "tls_private_key" "ec2-private-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


resource "aws_key_pair" "ec2-keypair" {
  key_name   = var.key-pair-name
  public_key = tls_private_key.ec2-private-key.public_key_openssh
}


resource "local_file" "local-priv-key" {
  content         = tls_private_key.ec2-private-key.private_key_openssh
  filename        = "${path.module}/keys/${var.key-pair-name}"
  file_permission = "0400"
}
