resource "aws_instance" "aws_ec2_instance_control" {
  ami           = var.ami_id
  instance_type = var.instance_type
  count         = var.number_of_instances_control

  vpc_security_group_ids      = [aws_security_group.aws_rke2_sg.id]
  subnet_id                   = element([aws_subnet.aws_rke2_subnet1.id, aws_subnet.aws_rke2_subnet2.id, aws_subnet.aws_rke2_subnet3.id], count.index % 3)
  associate_public_ip_address = var.associate_public_ip_address
  key_name                    = var.key_pair_name

  user_data = file(var.user_data_control)

  tags = {
    Name = "${var.instance_name_control}-0${count.index + 1}"
  }

  root_block_device {
    volume_size           = var.volume_size
    volume_type           = var.volume_type
    encrypted             = var.encrypted
    delete_on_termination = var.delete_on_termination

    tags = {
      Name = "${var.instance_name_control}-volume-0${count.index + 1}"
    }
  }
}

resource "aws_instance" "aws_ec2_instance_worker" {
  ami           = var.ami_id
  instance_type = var.instance_type
  count         = var.number_of_instances_worker

  vpc_security_group_ids      = [aws_security_group.aws_rke2_sg.id]
  subnet_id                   = element([aws_subnet.aws_rke2_subnet1.id, aws_subnet.aws_rke2_subnet2.id, aws_subnet.aws_rke2_subnet3.id], count.index % 3)
  associate_public_ip_address = var.associate_public_ip_address
  key_name                    = var.key_pair_name

  user_data = file(var.user_data_worker)

  tags = {
    Name = "${var.instance_name_worker}-0${count.index + 1}"
  }

  root_block_device {
    volume_size           = var.volume_size
    volume_type           = var.volume_type
    encrypted             = var.encrypted
    delete_on_termination = var.delete_on_termination

    tags = {
      Name = "${var.instance_name_worker}-volume-0${count.index + 1}"
    }
  }
}

resource "aws_eip" "aws_eip_control" {
  vpc      = true
  count    = var.number_of_instances_control
  instance = aws_instance.aws_ec2_instance_control[count.index].id

  tags = {
    Name = "${var.instance_name_control}-eip-0${count.index + 1}"
  }
}

resource "aws_eip" "aws_eip_worker" {
  vpc      = true
  count    = var.number_of_instances_worker
  instance = aws_instance.aws_ec2_instance_worker[count.index].id

  tags = {
    Name = "${var.instance_name_worker}-eip-0${count.index + 1}"
  }
}