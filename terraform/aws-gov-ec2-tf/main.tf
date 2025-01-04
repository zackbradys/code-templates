resource "aws_instance" "aws_ec2_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  count         = var.number_of_instances

  vpc_security_group_ids      = [var.security_group_id]
  subnet_id                   = var.subnet_id
  associate_public_ip_address = var.associate_public_ip_address
  key_name                    = var.key_pair_name

  user_data = templatefile("user-data.sh", {
    CarbideLicense   = var.CarbideLicense
    Registry         = var.Registry
    RegistryUsername = var.RegistryUsername
    RegistryPassword = var.RegistryPassword
    GitHubUsername   = var.GitHubUsername
    GitHubToken      = var.GitHubToken
    GitHubRepository = var.GitHubRepository
    TailscaleToken   = var.TailscaleToken
    RunnerIndex      = count.index + 1
    AccessKey        = var.access_key
    SecretKey        = var.secret_key
    Region           = var.region
    HaulerVersion    = var.HaulerVersion
  })


  tags = {
    Name = "${var.instance_name}-${count.index + 1}"
  }

  root_block_device {
    iops                  = var.iops
    volume_size           = var.volume_size
    volume_type           = var.volume_type
    encrypted             = var.encrypted
    delete_on_termination = var.delete_on_termination
  }
}