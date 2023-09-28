output "timestamp" {
  value       = [timestamp()]
  description = "Create/Update Timestamp"
}

output "instance_ips" {
  value       = ["${aws_instance.aws_ec2_instance.*.public_ip}"]
  description = "Public IP for the EC2 Instance"
}