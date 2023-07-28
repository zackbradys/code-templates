## Required Variables
variable "region" {
  default     = ""
  type        = string
  description = "(Required) The AWS Region to use for the instance(s)."
}

variable "access_key" {
  default     = ""
  type        = string
  description = "(Required) The AWS Access Key to use for the instance(s)."
}

variable "secret_key" {
  default     = ""
  type        = string
  description = "(Required) The AWS Secret Key to use for the instance(s)."
}

variable "key_pair_name" {
  default     = ""
  type        = string
  description = "(Required) The AWS Key Pair name to use for the instance(s)."
}

variable "domain" {
  default     = ""
  type        = string
  description = "(Required) The AWS Route53 domain to use for the cluster(s)."
}

variable "token" {
  default     = "awsRKE2terraform"
  type        = string
  description = "(Required) The RKE2 Cluster Join Token to use for the cluster(s)."
}

variable "vRKE2" {
  default     = "v1.25"
  type        = string
  description = "(Required) The RKE2 Version to use for the clusters(s)."
}

## Networking Variables
variable "vpc_cidr_block" {
  default     = "10.0.0.0/16"
  type        = string
  description = "(Required) The AWS VPC CIDR Block to use for the instance(s)."
}

variable "public_subnet_cidr_blocks" {
  default     = ["10.0.10.0/24", "10.0.20.0/24", "10.0.30.0/24"]
  type        = list(any)
  description = "(Required) The AWS Subnet CIDR Blocks to use for the instance(s)."
}

variable "private_subnet_cidr_blocks" {
  default     = ["10.0.40.0/24", "10.0.50.0/24", "10.0.60.0/24"]
  type        = list(any)
  description = "(Required) The AWS Subnet CIDR Blocks to use for the instance(s)."
}

variable "associate_public_ip_address" {
  default     = true
  type        = bool
  description = "(Required) Associate AWS Public IP Address for use for the instance(s)."
}

## Instance Variables
variable "instance_name_control" {
  default     = "aws-rke2-cp"
  type        = string
  description = "(Required) The name of the AWS RKE2 Control EC2 instance."
}

variable "instance_name_worker" {
  default     = "aws-rke2-wk"
  type        = string
  description = "(Required) The name of the AWS RKE2 Worker EC2 instance."
}

variable "instance_name_bastion" {
  default     = "aws-rke2-bastion"
  type        = string
  description = "(Required) The name of the AWS Bastion EC2 instance."
}

variable "ami_id" {
  default     = "ami-0fe64c0692c69d851"
  type        = string
  description = "(Required) The AWS AMI ID to use for the instance(s)."
}

variable "instance_type_control" {
  default     = "m6i.xlarge"
  type        = string
  description = "(Required) The AWS Instance type to use for the instance(s)."
}

variable "instance_type_worker" {
  default     = "m6i.xlarge"
  type        = string
  description = "(Required) The AWS Instance type to use for the instance(s)."
}

variable "instance_type_bastion" {
  default     = "t3.medium"
  type        = string
  description = "(Required) The AWS Instance type to use for the instance(s)."
}

variable "number_of_instances_control" {
  default     = 3
  type        = number
  description = "(Required) The number of AWS EC2 instances to create on deployment."
}

variable "number_of_instances_worker" {
  default     = 2
  type        = number
  description = "(Required) The number of AWS EC2 instances to create on deployment."
}

variable "number_of_instances_bastion" {
  default     = 1
  type        = number
  description = "(Required) The number of AWS EC2 instances to create on deployment."
}

## User Data Variables
variable "user_data_control" {
  default     = "scripts/control-node.sh"
  type        = string
  description = "(Required) The AWS User Data to use for the instance(s)."
}

variable "user_data_worker" {
  default     = "scripts/worker-node.sh"
  type        = string
  description = "(Required) The AWS User Data to use for the instance(s)."
}

## Storage Variables
variable "volume_size_control" {
  default     = 128
  type        = number
  description = "(Required) The AWS Volume Size to use for the instance(s)."
}

variable "volume_size_worker" {
  default     = 256
  type        = number
  description = "(Required) The AWS Volume Size to use for the instance(s)."
}

variable "volume_size_bastion" {
  default     = 16
  type        = number
  description = "(Required) The AWS Volume Size to use for the instance(s)."
}

variable "volume_type_control" {
  default     = "gp3"
  type        = string
  description = "(Required) The AWS Volume Type to use for the instance(s)."
}

variable "volume_type_worker" {
  default     = "gp3"
  type        = string
  description = "(Required) The AWS Volume Type to use for the instance(s)."
}

variable "volume_type_bastion" {
  default     = "gp3"
  type        = string
  description = "(Required) The AWS Volume Type to use for the instance(s)."
}

variable "encrypted" {
  default     = true
  type        = bool
  description = "(Required) Volume Encryption for use for the instance(s)."
}

variable "delete_on_termination" {
  default     = true
  type        = bool
  description = "(Required) Delete on Termination for the instance(s)."
}