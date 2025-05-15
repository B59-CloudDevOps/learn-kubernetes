What is Fargate pods on EKS ?
    AWS Fargate is a serverless compute engine for containers. Instead of provisioning and managing EC2 instances, you let AWS manage the infrastructure. You just define your container specs.

What are Fargate Pods on EKS?
    When you run Fargate pods on EKS, it means:
    Your Kubernetes pods are deployed without needing to provision or manage EC2 nodes.
    Each pod runs in its own isolated Fargate environment, with its own kernel and resources.
    AWS handles scaling, patching, and securing the infrastructure automatically. 

> Not able to execute the tolerated deployments on a tolerated node