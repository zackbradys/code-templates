output "vpc_id" {
  value       = [aws_vpc.aws_rke2_vpc.id]
  description = "VPC ID for the AWS RKE2 cluster"
}

output "public_subnet_ids" {
  value       = [aws_subnet.aws_rke2_public_subnet1.id, aws_subnet.aws_rke2_public_subnet2.id, aws_subnet.aws_rke2_public_subnet3.id]
  description = "Public Subnet IDs for the AWS RKE2 cluster"
}

output "private_subnet_ids" {
  value       = [aws_subnet.aws_rke2_private_subnet1.id, aws_subnet.aws_rke2_private_subnet2.id, aws_subnet.aws_rke2_private_subnet3.id]
  description = "Private Subnet IDs for the AWS RKE2 cluster"
}

output "instance_ids_control" {
  value       = ["${aws_instance.aws_ec2_instance_control.*.id}"]
  description = "Instance IDs for the Control Nodes in the AWS RKE2 cluster"
}

output "instance_ids_worker" {
  value       = ["${aws_instance.aws_ec2_instance_worker.*.id}"]
  description = "Instance IDs for the Worker Nodes in the AWS RKE2 cluster"
}

output "instance_ips_control" {
  value       = ["${aws_instance.aws_ec2_instance_control.*.private_ip}"]
  description = "Instance IPs for the Control Nodes in the AWS RKE2 cluster"
}

output "instance_ips_worker" {
  value       = ["${aws_instance.aws_ec2_instance_worker.*.private_ip}"]
  description = "Instance IPs for the Worker Nodes in the AWS RKE2 cluster"
}