output "instance_ids" {
  value = [aws_instance.aws_ec2_instance.*.id]
  description = "AWS EC2 Instance ID(s)"
}

output "instance_ips" {
  value = [aws_instance.aws_ec2_instance.*.public_ip]
  description = "AWS EC2 Instance Public IP(s)"
}