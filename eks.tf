resource "aws_eks_cluster" "health_med_cluster" {
  name     = var.cluster_name
  role_arn = var.labRoleArn
  

  vpc_config {
    subnet_ids = ["${var.subnetA}", "${var.subnetB}", "${var.subnetC}"]
    security_group_ids = ["${var.sgId}"]
  }

  access_config {
    authentication_mode                         = var.accessConfig
  }
}

resource "aws_eks_access_entry" "access_entry" {
  cluster_name = aws_eks_cluster.health_med_cluster.name
  principal_arn = var.principal_arn
  kubernetes_groups = ["admin", "health-med"]
  type = "STANDARD"
}

resource "aws_eks_access_policy_association" "policy" {
  cluster_name  = aws_eks_cluster.health_med_cluster.name
  policy_arn    = var.policy_arn
  principal_arn = var.principal_arn

  access_scope {
    type = "cluster"
  }
}

resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.health_med_cluster.name
  node_group_name = var.node_group_name
  node_role_arn   = var.labRoleArn
  subnet_ids = ["${var.subnetA}", "${var.subnetB}", "${var.subnetC}"]
  disk_size = 20
  instance_types = [var.instance_type]

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  update_config {
    max_unavailable = 1
  }
}