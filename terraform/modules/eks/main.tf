resource "aws_iam_role" "petclinic_eks_cluster_role" {
  name = "${var.project}-${var.environment}-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = {
    Name = "${var.project}-${var.environment}-eks-cluster-role"
  }
}

resource "aws_iam_role_policy_attachment" "petclinic_eks_cluster_policy" {
  role       = aws_iam_role.petclinic_eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role" "petclinic_eks_node_role" {
  name = "${var.project}-${var.environment}-eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = {
    Name = "${var.project}-${var.environment}-eks-node-role"
  }
}

resource "aws_iam_role_policy_attachment" "petclinic_eks_worker_policy" {
  role       = aws_iam_role.petclinic_eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "petclinic_eks_cni_policy" {
  role       = aws_iam_role.petclinic_eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "petclinic_eks_ecr_policy" {
  role       = aws_iam_role.petclinic_eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_eks_cluster" "petclinic_eks_cluster" {
  name     = var.cluster_name
  version  = var.kubernetes_version
  role_arn = aws_iam_role.petclinic_eks_cluster_role.arn

  vpc_config {
    subnet_ids              = var.subnet_ids
    security_group_ids      = [var.cluster_security_group_id]
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }

  tags = {
    Name = "${var.project}-${var.environment}-eks"
  }

  depends_on = [
    aws_iam_role_policy_attachment.petclinic_eks_cluster_policy
  ]
}

resource "aws_eks_node_group" "petclinic_eks_nodes" {
  cluster_name    = aws_eks_cluster.petclinic_eks_cluster.name
  node_group_name = "${var.project}-${var.environment}-nodes"
  node_role_arn   = aws_iam_role.petclinic_eks_node_role.arn
  subnet_ids      = var.subnet_ids
  instance_types  = var.instance_types
  ami_type        = "AL2023_ARM_64_STANDARD"
  capacity_type   = "ON_DEMAND"
  disk_size       = 20

  scaling_config {
    desired_size = var.desired_size
    min_size     = var.min_size
    max_size     = var.max_size
  }

  update_config {
    max_unavailable = 1
  }

  tags = {
    Name = "${var.project}-${var.environment}-nodes"
  }

  depends_on = [
    aws_iam_role_policy_attachment.petclinic_eks_worker_policy,
    aws_iam_role_policy_attachment.petclinic_eks_cni_policy,
    aws_iam_role_policy_attachment.petclinic_eks_ecr_policy
  ]
}

resource "aws_eks_addon" "petclinic_vpc_cni" {
  cluster_name = aws_eks_cluster.petclinic_eks_cluster.name
  addon_name   = "vpc-cni"
}

resource "aws_eks_addon" "petclinic_kube_proxy" {
  cluster_name = aws_eks_cluster.petclinic_eks_cluster.name
  addon_name   = "kube-proxy"
}

resource "aws_eks_addon" "petclinic_coredns" {
  cluster_name = aws_eks_cluster.petclinic_eks_cluster.name
  addon_name   = "coredns"

  depends_on = [aws_eks_node_group.petclinic_eks_nodes]
}
