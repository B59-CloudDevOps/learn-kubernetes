This repo contains the code needed to provison the EKS Cluster. 
Make sure to update the subnets from your account, these values are as per the current account only. 

We can create the EKS Cluster by using Terraform Supplied Readily Available Modules from Terraform Registry, all you need to do is just override the variables.

Example:
```
    module "eks" {
    source  = "terraform-aws-modules/eks/aws"
    version = "~> 20.31"

    cluster_name    = "example"
    cluster_version = "1.31"

    # Optional
    cluster_endpoint_public_access = true

    # Optional: Adds the current caller identity as an administrator via cluster access entry
    enable_cluster_creator_admin_permissions = true

    cluster_compute_config = {
        enabled    = true
        node_pools = ["general-purpose"]
    }

    vpc_id     = "vpc-1234556abcdef"
    subnet_ids = ["subnet-abcde012", "subnet-bcde012a", "subnet-fghi345a"]

    tags = {
        Environment = "dev"
        Terraform   = "true"
    }
    }
```