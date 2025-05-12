provider "kubernetes" {
  host                   = aws_eks_cluster.main.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.main.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.main.token
}

data "aws_eks_cluster_auth" "main" {
  name = aws_eks_cluster.main.name
}

# ****  
resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode([
      {
        rolearn  = aws_iam_role.nodegroup_01_iamrole.arn
        username = "system:node:{{EC2PrivateDNSName}}"
        groups = [
          "system:bootstrappers",
          "system:nodes"
        ]
      },
      {
        rolearn  = "arn:aws:iam::355449129696:role/b59-administrator-role"
        username = "admin"
        groups = [
          "system:masters"
        ]
      }
    ])
  }
  # The config map is created only if the cluster is created successfully.
  # Otherwise, it will fail to create the config map.
  depends_on = [
    aws_eks_node_group.nodegroup_01
  ]
}
