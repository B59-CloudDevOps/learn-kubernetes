# resource "aws_eks_cluster" "main" {
#   name = var.cluster_name

#   access_config {
#     authentication_mode = "API"
#   }

#   role_arn = aws_iam_role.cluster.arn
#   version  = var.cluster_version

#   vpc_config {
#     subnet_ids = ["subnet-0d1a07bc7ceaf4694", "subnet-05a9dc77897b66c38", "subnet-08c53c78664626d0f"] #  The 3 subnets are for the EKS control plane's network access, not for controlling the number of master nodes.
#   }

#   # Ensure that IAM Role permissions are created before and deleted
#   # after EKS Cluster handling. Otherwise, EKS will not be able to
#   # properly delete EKS managed EC2 infrastructure such as Security Groups.
#   depends_on = [
#     aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
#     aws_iam_role_policy_attachment.cluster_AmazonEKSVPCResourceController,
#   ]
# }

# resource "aws_iam_role" "cluster" {
#   name = "b59-eks-cluster-role"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = [
#           "sts:AssumeRole",
#           "sts:TagSession"
#         ]
#         Effect = "Allow"
#         Principal = {
#           Service = "eks.amazonaws.com"
#         }
#       },
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
#   role       = aws_iam_role.cluster.name
# }

# resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSVPCResourceController" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
#   role       = aws_iam_role.cluster.name
# }


# resource "aws_eks_node_group" "nodegroup_01" {
#   cluster_name    = aws_eks_cluster.main.name
#   node_group_name = var.nodegroup_01_name
#   node_role_arn   = aws_iam_role.nodegroup_01_iamrole.arn
#   subnet_ids      = ["subnet-0d1a07bc7ceaf4694", "subnet-05a9dc77897b66c38", "subnet-08c53c78664626d0f"] # worker subnets
#   instance_types  = ["t3.medium", "t3.large"]
#   capacity_type   = "SPOT" # EC2 instance type for the worker nodes

#   scaling_config {
#     desired_size = 2 # When node group is created, it will have 2 nodes.
#     max_size     = 3 # Maximum number of nodes in the node group.   
#     min_size     = 1 # Minimum number of nodes in the node group that it can scale down to.
#   }

#   update_config {
#     max_unavailable = 1 # Maximum number of nodes that can be unavailable during an update.
#   }

#   # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
#   # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
#   depends_on = [
#     aws_iam_role_policy_attachment.b59_eks_AmazonEKSWorkerNodePolicy,
#     aws_iam_role_policy_attachment.b59_eks_AmazonEKS_CNI_Policy,
#     aws_iam_role_policy_attachment.b59_eks_AmazonEC2ContainerRegistryReadOnly,
#   ]
# }

# # IAM Role for the Node Group
# resource "aws_iam_role" "nodegroup_01_iamrole" {
#   name = "eks-node-group-example"

#   assume_role_policy = jsonencode({
#     Statement = [{
#       Action = "sts:AssumeRole"
#       Effect = "Allow"
#       Principal = {
#         Service = "ec2.amazonaws.com"
#       }
#     }]
#     Version = "2012-10-17"
#   })
# }

# resource "aws_iam_role_policy_attachment" "b59_eks_AmazonEKSWorkerNodePolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
#   role       = aws_iam_role.nodegroup_01_iamrole.name
# }

# resource "aws_iam_role_policy_attachment" "b59_eks_AmazonEKS_CNI_Policy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
#   role       = aws_iam_role.nodegroup_01_iamrole.name
# }

# resource "aws_iam_role_policy_attachment" "b59_eks_AmazonEC2ContainerRegistryReadOnly" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
#   role       = aws_iam_role.nodegroup_01_iamrole.name
# }

# # resource "aws_iam_role_policy_attachment" "b59_eks_AmazonEKSClusterPolicy" {
# #   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
# #   role       = aws_iam_role.nodegroup_01_iamrole.name
# # }

# variable "cluster_name" {
#   description = "The name of the EKS cluster"
#   type        = string
#   default     = "b59-eks-cluster"
# }

# variable "cluster_version" {
#   description = "The version of the EKS cluster"
#   type        = string
#   default     = "1.32"
# }

# # nodeGroup varaibles
# variable "nodegroup_01_name" {
#   description = "The name of the first node group"
#   type        = string
#   default     = "b59-eks-nodegroup-01"
# }

# terraform {
#   backend "s3" {
#     bucket = "b59-tf-state-bucket"
#     key    = "b59/eks-learning/terraform.tfstate"
#     region = "us-east-1"
#   }
# }