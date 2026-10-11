output "petclinic_eks_cluster_sg_id" {
  description = "Security group ID for the Petclinic EKS control plane"
  value       = aws_security_group.petclinic_eks_cluster_sg.id
}

output "petclinic_eks_nodes_sg_id" {
  description = "Security group ID for the Petclinic EKS worker nodes"
  value       = aws_security_group.petclinic_eks_nodes_sg.id
}

output "petclinic_rds_sg_id" {
  description = "Security group ID for the Petclinic RDS database"
  value       = aws_security_group.petclinic_rds_sg.id
}

output "petclinic_alb_sg_id" {
  description = "Security group ID for the Petclinic load balancer"
  value       = aws_security_group.petclinic_alb_sg.id
}
