output "instance-pri-key" {
  description = "Private Key for instance SSH access"
  value       = tls_private_key.ec2-private-key.private_key_openssh
  sensitive   = true
}
