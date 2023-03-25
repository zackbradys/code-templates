output "vpc_id" {
  value = aws_vpc.aws_rke2_vpc.id
  description = "VPC ID for the AWS RKE2 cluster"
}

output "subnet_ids" {
  value = [aws_subnet.aws_rke2_subnet1.id, aws_subnet.aws_rke2_subnet2.id, aws_subnet.aws_rke2_subnet3.id]
  description = "Subnet IDs for the AWS RKE2 cluster"
}

output "instance_ids_control" {
  value = ["${aws_instance.aws_ec2_instance_control.*.id}"]
  description = "Instance IDs for the Control Nodes in the AWS RKE2 cluster"
}

output "instance_ids_worker" {
  value = ["${aws_instance.aws_ec2_instance_worker.*.id}"]
  description = "Instance IDs for the Worker Nodes in the AWS RKE2 cluster"
}

output "instance_ips_control" {
  value = ["${aws_instance.aws_ec2_instance_control.*.public_ip}"]
  description = "Instance IPs for the Control Nodes in the AWS RKE2 cluster"
}

output "instance_ips_worker" {
  value = ["${aws_instance.aws_ec2_instance_worker.*.public_ip}"]
  description = "Instance IPs for the Worker Nodes in the AWS RKE2 cluster"
}