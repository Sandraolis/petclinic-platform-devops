variable "project" {
  type    = string
  default = "petclinic"
}

variable "environment" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "kubernetes_version" {
  type    = string
  default = "1.36"
}

variable "subnet_ids" {
  type = list(string)
}

variable "cluster_security_group_id" {
  type = string
}

variable "node_security_group_id" {
  type = string
}

variable "instance_types" {
  type    = list(string)
  default = ["t4g.small"]
}

variable "desired_size" {
  type    = number
  default = 2
}

variable "min_size" {
  type    = number
  default = 2
}

variable "max_size" {
  type    = number
  default = 4
}
