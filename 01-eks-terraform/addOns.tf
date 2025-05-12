resource "aws_eks_addon" "main" {
  depends_on = [aws_eks_cluster.main, aws_eks_node_group.nodegroup_01]

  cluster_name = aws_eks_cluster.main.name
  addon_name   = "vpc-cni"
  configuration_values = jsonencode({
    configuration_values = {
      "enableNetworkPolicy" = "true"
    }
  })
}