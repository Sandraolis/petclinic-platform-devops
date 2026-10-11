output "petclinic_eks_cluster_name" {
  value = aws_eks_cluster.petclinic_eks_cluster.name
}

output "petclinic_eks_cluster_endpoint" {
  value = aws_eks_cluster.petclinic_eks_cluster.endpoint
}

output "petclinic_eks_cluster_arn" {
  value = aws_eks_cluster.petclinic_eks_cluster.arn
}

output "petclinic_eks_node_group_name" {
  value = aws_eks_node_group.petclinic_eks_nodes.node_group_name
}

output "petclinic_eks_node_role_arn" {
  value = aws_iam_role.petclinic_eks_node_role.arn
}
