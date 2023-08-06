### Required Variables
variable "region" {
  type        = string
  description = "(Required) The AWS Region to use for the instance(s)."
}

variable "access_key" {
  type        = string
  description = "(Required) The AWS Access Key to use for the instance(s)."
}

variable "secret_key" {
  type        = string
  description = "(Required) The AWS Secret Key to use for the instance(s)."
}

variable "key_pair_name" {
  type        = string
  description = "(Required) The AWS Key Pair name to use for the instance(s)."
}

variable "domain" {
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

variable "vRancher" {
  default     = "2.7.4"
  type        = string
  description = "(Required) The Rancher Version to use for the clusters(s)."
}

variable "vLonghorn" {
  default     = "1.4.2"
  type        = string
  description = "(Required) The Longhorn Version to use for the clusters(s)."
}

variable "vNeuVector" {
  default     = "2.4.5"
  type        = string
  description = "(Required) The NeuVector Version to use for the clusters(s)."
}

variable "vCertManager" {
  default     = "1.7.1"
  type        = string
  description = "(Required) The Cert Manager Version to use for the clusters(s)."
}

variable "vCarbide" {
  default     = "0.1.1"
  type        = string
  description = "(Required) The Carbide Version to use for the clusters(s)."
}

variable "CarbideRegistry" {
  type        = string
  description = "(Required) The Carbide Registry to use for the clusters(s)."
}

variable "CarbideUsername" {
  type        = string
  description = "(Required) The Carbide Username to use for the clusters(s)."
}

variable "CarbidePassword" {
  type        = string
  description = "(Required) The Carbide Password to use for the clusters(s)."
}

variable "CarbideLicense" {
  type        = string
  description = "(Required) The Carbide License to use for the clusters(s)."
}

variable "ami_id" {
  default     = "ami-0fe64c0692c69d851"
  type        = string
  description = "(Required) The AWS AMI ID to use for the instance(s)."
}

### Networking Variables
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

### Instance Variables
variable "instance_name_control" {
  default     = "aws-rke2-cp"
  type        = string
  description = "(Required) The name of the AWS RKE2 Control Node EC2 instance."
}

variable "instance_name_controls" {
  default     = "aws-rke2-cps"
  type        = string
  description = "(Required) The name of the AWS RKE2 Control NodesEC2 instance."
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
  default     = 1
  type        = number
  description = "(Required) The number of AWS EC2 instances to create on deployment."
}

variable "number_of_instances_controls" {
  default     = 2
  type        = number
  description = "(Required) The number of AWS EC2 instances to create on deployment."
}

variable "number_of_instances_worker" {
  default     = 3
  type        = number
  description = "(Required) The number of AWS EC2 instances to create on deployment."
}

variable "number_of_instances_bastion" {
  default     = 1
  type        = number
  description = "(Required) The number of AWS EC2 instances to create on deployment."
}

### User Data Variables
variable "user_data_control" {
  default     = "scripts/control-node-carbide.sh"
  type        = string
  description = "(Required) The AWS User Data to use for the instance(s)."
}

variable "user_data_controls" {
  default     = "scripts/control-nodes-carbide.sh"
  type        = string
  description = "(Required) The AWS User Data to use for the instance(s)."
}

variable "user_data_workers" {
  default     = "scripts/worker-nodes-carbide.sh"
  type        = string
  description = "(Required) The AWS User Data to use for the instance(s)."
}

### Storage Variables
variable "volume_size_control" {
  default     = 128
  type        = number
  description = "(Required) The AWS Volume Size to use for the instance(s)."
}

variable "volume_size_controls" {
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

variable "volume_type_controls" {
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