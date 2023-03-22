terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  required_version = "~> 1.0"
}

provider "aws" {
  region = "us-east-1"
  
  default_tags {
    tags = {
    provisioner = "terraform"
   }
 }
}

locals {
  tags = {
    Name = "aws-rke2-node"
  }
  ami = "ami-0cce0fd28f5ae1c16"
  instance_type = "c5d.xlarge"
  count = 6

  vpc_security_group_ids = ["sg-0357d71913582e447"]
  subnet_id = "subnet-068c1a36a5bfa79cc"
  associate_public_ip_address = true
  key_name = "aws-zackbradys-work"

  root_block_device = [{
    device_name           = "/dev/sda1"
    volume_size           = "128"
    volume_type           = "gp2"
    encrypted             = false
    delete_on_termination = true
  }]
}

resource "aws_instance" "aws_ec2_instance" {
  tags = {
    Name = "${var.instance_name}-0${count.index + 1}"
  }
  ami = "${var.ami_id}"
  instance_type = "${var.instance_type}"
  count = "${var.number_of_instances}"

  vpc_security_group_ids = ["${var.security_group_id}"]
  subnet_id = "${var.subnet_id}"
  associate_public_ip_address = "${var.associate_public_ip_address}"
  key_name = "${var.key_pair_name}"

  root_block_device {
    device_name = "${var.device_name}"
    volume_size = "${var.volume_size}"
    volume_type = "${var.volume_type}"
    encrypted = "${var.encrypted}"
    delete_on_termination = "${var.delete_on_termination}"
  }
}