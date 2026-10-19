output "pub-sgp-01-id" {
  value = aws_security_group.public-sg.id
}

output "private-sgs-id-list" {
  value = aws_security_group.priv-sgs[*].id
}
