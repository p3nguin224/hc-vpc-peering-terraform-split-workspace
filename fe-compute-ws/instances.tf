resource "aws_instance" "public-instance-01" {
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = var.instance-type
  associate_public_ip_address = true

  key_name = aws_key_pair.ec2-keypair.key_name

  vpc_security_group_ids = [data.terraform_remote_state.fe-security-ws.outputs.pub-sgp-01-id]
  subnet_id              = data.terraform_remote_state.fe-network-ws.outputs.public_subnets_id[0]


  tags = merge(var.based-tags, {
    Name = "public-instance-01"
  })
}


resource "aws_instance" "private-instances" {
  count                       = 3
  ami                         = data.aws_ami.ubuntu_24_04.id
  instance_type               = var.instance-type
  associate_public_ip_address = false

  key_name = aws_key_pair.ec2-keypair.key_name

  vpc_security_group_ids = [data.terraform_remote_state.fe-security-ws.outputs.private-sgs-id-list[count.index]]
  subnet_id              = data.terraform_remote_state.fe-network-ws.outputs.private_subnets_id[count.index]


  tags = merge(var.based-tags, {
    Name = "private-instance-0${count.index + 1}"
  })
}
