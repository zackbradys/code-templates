resource "aws_instance" "aws_ec2_instance" {
  tags = {
    Name = "${var.instance_name}"
  }
  ami           = var.ami_id
  instance_type = var.instance_type
  count         = var.number_of_instances

  vpc_security_group_ids      = ["${var.security_group_id}"]
  subnet_id                   = var.subnet_id
  associate_public_ip_address = var.associate_public_ip_address
  key_name                    = var.key_pair_name

  root_block_device {
    volume_size           = var.volume_size
    volume_type           = var.volume_type
    encrypted             = var.encrypted
    delete_on_termination = var.delete_on_termination
  }
}