variable "project" {
  type    = string
  default = "petclinic"
}

variable "environment" {
  type = string

  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "Environment must be dev or prod."
  }
}

variable "service_names" {
  type = set(string)
}
