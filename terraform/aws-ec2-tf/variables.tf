variable "vpc_cidr_block" {
  default     = "10.0.0.0/16"
  description = "(Required) The aws vpc cidr block to use for the instance(s)."
}

variable "subnet_cidr_blocks" {
  default     = ["10.0.10.0/24", "10.0.20.0/24", "10.0.30.0/24"]
  description = "(Required) The aws subnet cidr blocks to use for the instance(s)."
}

variable "instance_name_control" {
  default     = "aws-rke2-cp"
  description = "(Required) The name of the aws ec2 instance."
}

variable "instance_name_worker" {
  default     = "aws-rke2-wk"
  description = "(Required) The name of the aws ec2 instance."
}

variable "ami_id" {
  default     = "ami-0cce0fd28f5ae1c16"
  description = "(Required) The aws ami id to use for the instance(s)."
}

variable "instance_type" {
  default     = "c5d.xlarge"
  description = "(Required) The aws instance type to use for the instance(s)."
}

variable "number_of_instances_control" {
  default     = 3
  description = "(Required) The number of aws ec2 instances to create on deployment."
}

variable "number_of_instances_worker" {
  default     = 3
  description = "(Required) The number of aws ec2 instances to create on deployment."
}

variable "security_group_id" {
  default     = "sg-0357d71913582e447"
  description = "(Required) The aws security group id to use for the instance(s)."
}

variable "subnet_id" {
  default     = "subnet-068c1a36a5bfa79cc"
  description = "(Required) The aws subnet id to use for the instance(s)."
}

variable "associate_public_ip_address" {
  default     = true
  description = "(Required) The aws associate public ip address to use for the instance(s)."
}

variable "key_pair_name" {
  default     = "aws-zackbradys-work"
  description = "(Required) The aws key pair name to use for the instance(s)."
}

variable "user_data" {
  default     = "scripts/user-data.sh"
  description = "(Required) The aws user data to use for the instance(s)."

}
variable "volume_size" {
  default     = 128
  description = "(Required) The aws volume size to use for the instance(s)."
}

variable "volume_type" {
  default     = "gp2"
  description = "(Required) The aws volume type to use for the instance(s)."
}

variable "encrypted" {
  default     = true
  description = "(Required) The aws encrypted to use for the instance(s)."
}

variable "delete_on_termination" {
  default     = true
  description = "(Required) The aws delete on termination to use for the instance(s)."
}