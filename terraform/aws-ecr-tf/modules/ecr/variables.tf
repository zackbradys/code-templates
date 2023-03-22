variable "name" {
  type = string
  description = "(Required) Name of the repository. {name}."
}

variable "image_tag_mutability" {
  type = string
  default = "MUTABLE"
  description = "(Required) The tag mutability setting for the repository. Must be one of: MUTABLE or IMMUTABLE. Defaults to MUTABLE."
}

variable "scan_on_push" {
  type = bool
  default = true
  description = "(Required) Indicates whether images are scanned after being pushed to the repository (true) or not scanned (false)."
}

variable "expiration_after_days" {
  type = number
  default = 0
  description = "(Required) Delete images older than the specific numbered of days."

}

variable "force_delete" {
  type = bool
  default = true
  description = "(Required) If true, will delete the repository even if it contains images. Defaults to false."
}