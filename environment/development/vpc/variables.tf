variable "environment_name" {
  description = "Which environment are we in?"
  default     = "development"
}

variable "vpc_cidr" {
  description = "CIDR block of the VPC"
  default     = "10.50.0.0/16"
}

variable "tag_owner" {
  description = "The owner of the resource"
  default     = "Mike Price"
}