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
  description = "(Required) The aws key pair name to use for the instance(s)."
}

variable "instance_name" {
  default     = ""
  type        = string
  description = "(Required) The name of the aws ec2 instance."
}

variable "ami_id" {
  default     = "ami-0fe64c0692c69d851"
  type        = string
  description = "(Required) The aws ami id to use for the instance(s)."
}

variable "instance_type" {
  default     = "m6i.xlarge"
  type        = string
  description = "(Required) The aws instance type to use for the instance(s)."
}

variable "number_of_instances" {
  default     = 1
  type        = number
  description = "(Required) The number of aws ec2 instances to create on deployment."
}

variable "security_group_id" {
  default     = "sg-0357d71913582e447"
  type        = string
  description = "(Required) The aws security group id to use for the instance(s)."
}

variable "subnet_id" {
  default     = "subnet-068c1a36a5bfa79cc"
  type        = string
  description = "(Required) The aws subnet id to use for the instance(s)."
}

variable "associate_public_ip_address" {
  default     = true
  type        = bool
  description = "(Required) The aws associate public ip address to use for the instance(s)."
}

variable "volume_size" {
  default     = 128
  type        = number
  description = "(Required) The aws volume size to use for the instance(s)."
}

variable "volume_type" {
  default     = "gp3"
  type        = string
  description = "(Required) The aws volume type to use for the instance(s)."
}

variable "encrypted" {
  default     = false
  type        = bool
  description = "(Required) The aws encrypted to use for the instance(s)."
}

variable "delete_on_termination" {
  default     = true
  type        = bool
  description = "(Required) The aws delete on termination to use for the instance(s)."
}