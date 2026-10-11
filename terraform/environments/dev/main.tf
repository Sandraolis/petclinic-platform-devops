module "petclinic_vpc" {
  source = "../../modules/vpc"

  project             = "petclinic"
  environment         = "dev"
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  availability_zones  = ["eu-central-1a", "eu-central-1b"]
  cluster_name        = "petclinic-dev"
}

output "petclinic_vpc_id" {
  description = "ID of the Petclinic Dev VPC"
  value       = module.petclinic_vpc.petclinic_vpc_id
}

output "petclinic_public_subnet_ids" {
  description = "IDs of the Petclinic Dev public subnets"
  value       = module.petclinic_vpc.petclinic_public_subnet_ids
}

module "petclinic_security_groups" {
  source = "../../modules/security-groups"

  environment  = "dev"
  vpc_id       = module.petclinic_vpc.petclinic_vpc_id
  cluster_name = "petclinic-dev"
}

output "petclinic_eks_cluster_sg_id" {
  description = "Petclinic Dev EKS cluster security group ID"
  value       = module.petclinic_security_groups.petclinic_eks_cluster_sg_id
}

output "petclinic_eks_nodes_sg_id" {
  description = "Petclinic Dev worker-node security group ID"
  value       = module.petclinic_security_groups.petclinic_eks_nodes_sg_id
}

output "petclinic_rds_sg_id" {
  description = "Petclinic Dev database security group ID"
  value       = module.petclinic_security_groups.petclinic_rds_sg_id
}

output "petclinic_alb_sg_id" {
  description = "Petclinic Dev load balancer security group ID"
  value       = module.petclinic_security_groups.petclinic_alb_sg_id
}

module "petclinic_eks" {
  source = "../../modules/eks"

  project                   = "petclinic"
  environment               = "dev"
  cluster_name              = "petclinic-dev"
  kubernetes_version        = "1.36"
  subnet_ids                = module.petclinic_vpc.petclinic_public_subnet_ids
  cluster_security_group_id = module.petclinic_security_groups.petclinic_eks_cluster_sg_id
  node_security_group_id    = module.petclinic_security_groups.petclinic_eks_nodes_sg_id

  instance_types = ["t4g.medium"]
  min_size       = 2
  desired_size   = 2
  max_size       = 4
}

output "petclinic_eks_cluster_name" {
  value = module.petclinic_eks.petclinic_eks_cluster_name
}

output "petclinic_eks_cluster_endpoint" {
  value = module.petclinic_eks.petclinic_eks_cluster_endpoint
}

output "petclinic_eks_node_group_name" {
  value = module.petclinic_eks.petclinic_eks_node_group_name
}

module "petclinic_ecr" {
  source = "../../modules/ecr"

  project     = "petclinic"
  environment = "dev"

  service_names = [
    "config-server",
    "discovery-server",
    "api-gateway",
    "customers-service",
    "visits-service",
    "vets-service",
    "genai-service",
    "admin-server"
  ]
}

output "petclinic_ecr_repository_urls" {
  value = module.petclinic_ecr.petclinic_ecr_repository_urls
}
