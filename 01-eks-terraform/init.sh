#!/bin/bash
# This script is used to initialize the EKS cluster and deploy the necessary resources.

if [ -z "$1" ]; then
  echo -e "\e[33m Usage: $0 apply|destroy \e[0m"    
  exit 1
fi

if [ $1 -eq apply ]; then

    echo "EKS Cluster Provisioning In Progress"
    terraform init
    terraform plan
    terraform apply -auto-approve 
    echo "Provisioning Metrics Server"
    aws eks update-kubeconfig --region us-east-1 --name b59-eks-cluster
    kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml 
fi 
elif [ $1 -eq destroy ]; then
    echo "EKS Cluster Destroying In Progress"
    terraform init
    terraform plan
    terraform destroy -auto-approve 
fi
