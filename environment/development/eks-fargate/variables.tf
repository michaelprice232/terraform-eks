variable "environment_name" {
  description = "Which environment are we in?"
  default     = "development"
}

variable "tag_owner" {
  description = "The owner of the resource"
  default     = "Mike Price"
}

variable "map_accounts" {
  description = "Additional AWS account numbers to add to the aws-auth configmap."
  type        = list(string)

  default = []
}

variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))

  default = []
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))

  default = []
}

variable "k8s_version" {
  description = "What version of K8s EKS control plane to deploy"
  default     = "1.17"        # Allow us to demo the upgrade option
}

variable "endpoint_private_access_enabled" {
  description = "Whether the private API endpoint is enabled"
  default     = true
}

variable "kms_key_deletion_days" {
  description = "How many days after the KMS key is marked for deletion it actually deletes"
  default     = 7
}