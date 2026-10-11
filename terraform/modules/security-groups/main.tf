resource "aws_security_group" "petclinic_eks_cluster_sg" {
  name        = "petclinic-${var.environment}-eks-cluster-sg"
  description = "Security group for the Petclinic EKS control plane"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "petclinic-${var.environment}-eks-cluster-sg"
    Project     = "petclinic"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

resource "aws_security_group" "petclinic_eks_nodes_sg" {
  name        = "petclinic-${var.environment}-eks-nodes-sg"
  description = "Security group for Petclinic EKS worker nodes"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "petclinic-${var.environment}-eks-nodes-sg"
    Project     = "petclinic"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

resource "aws_security_group" "petclinic_rds_sg" {
  name        = "petclinic-${var.environment}-rds-sg"
  description = "Security group for the Petclinic MySQL database"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "petclinic-${var.environment}-rds-sg"
    Project     = "petclinic"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

resource "aws_security_group" "petclinic_alb_sg" {
  name        = "petclinic-${var.environment}-alb-sg"
  description = "Security group for the Petclinic Application Load Balancer"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "petclinic-${var.environment}-alb-sg"
    Project     = "petclinic"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

# Allow the worker nodes to communicate with the EKS API.
resource "aws_vpc_security_group_ingress_rule" "petclinic_cluster_from_nodes" {
  security_group_id            = aws_security_group.petclinic_eks_cluster_sg.id
  referenced_security_group_id = aws_security_group.petclinic_eks_nodes_sg.id
  description                  = "Allow EKS worker nodes to reach the cluster API"
  ip_protocol                  = "tcp"
  from_port                    = 443
  to_port                      = 443
}

# Allow control-plane traffic to the worker nodes.
resource "aws_vpc_security_group_ingress_rule" "petclinic_nodes_from_cluster" {
  security_group_id            = aws_security_group.petclinic_eks_nodes_sg.id
  referenced_security_group_id = aws_security_group.petclinic_eks_cluster_sg.id
  description                  = "Allow EKS control-plane communication to worker nodes"
  ip_protocol                  = "-1"
}

# Allow communication between worker nodes.
resource "aws_vpc_security_group_ingress_rule" "petclinic_nodes_self" {
  security_group_id            = aws_security_group.petclinic_eks_nodes_sg.id
  referenced_security_group_id = aws_security_group.petclinic_eks_nodes_sg.id
  description                  = "Allow required communication between Petclinic worker nodes"
  ip_protocol                  = "-1"
}

# RDS accepts MySQL traffic only from the EKS worker nodes.
resource "aws_vpc_security_group_ingress_rule" "petclinic_rds_from_nodes" {
  security_group_id            = aws_security_group.petclinic_rds_sg.id
  referenced_security_group_id = aws_security_group.petclinic_eks_nodes_sg.id
  description                  = "Allow MySQL only from Petclinic EKS worker nodes"
  ip_protocol                  = "tcp"
  from_port                    = 3306
  to_port                      = 3306
}

# Public HTTP access for the Application Load Balancer.
resource "aws_vpc_security_group_ingress_rule" "petclinic_alb_http" {
  security_group_id = aws_security_group.petclinic_alb_sg.id
  description       = "Allow HTTP traffic to the public load balancer"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = "0.0.0.0/0"
}

# Public HTTPS access for the Application Load Balancer.
resource "aws_vpc_security_group_ingress_rule" "petclinic_alb_https" {
  security_group_id = aws_security_group.petclinic_alb_sg.id
  description       = "Allow HTTPS traffic to the public load balancer"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = "0.0.0.0/0"
}

# Explicit outbound rules for each security group.
resource "aws_vpc_security_group_egress_rule" "petclinic_cluster_egress" {
  security_group_id = aws_security_group.petclinic_eks_cluster_sg.id
  description       = "Allow outbound cluster traffic"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "petclinic_nodes_egress" {
  security_group_id = aws_security_group.petclinic_eks_nodes_sg.id
  description       = "Allow outbound worker-node traffic"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "petclinic_rds_egress" {
  security_group_id = aws_security_group.petclinic_rds_sg.id
  description       = "Allow outbound database traffic"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "petclinic_alb_egress" {
  security_group_id = aws_security_group.petclinic_alb_sg.id
  description       = "Allow outbound load-balancer traffic"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}
