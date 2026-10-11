variable "environment" {
  description = "Petclinic deployment environment"
  type        = string

  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "Environment must be dev or prod."
  }
}

variable "vpc_id" {
  description = "ID of the Petclinic VPC"
  type        = string
}

variable "cluster_name" {
  description = "Name of the Petclinic EKS cluster"
  type        = string
}
