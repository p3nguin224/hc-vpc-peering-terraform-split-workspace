output "instance-pri-key" {
  description = "Private Key for instance SSH access"
  value       = tls_private_key.ec2-private-key.private_key_openssh
  sensitive   = true
}

output "aws-keypair-public-key" {
  description = "Keypair for EC2 instances"
  value       = aws_key_pair.ec2-keypair.public_key
}
