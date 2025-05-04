#!/bin/bash

echo "Fixing the space constraint:"
  growpart /dev/nvme0n1 4
  lvextend -l +50%FREE /dev/mapper/RootVG-homeVol ;
  lvextend -l +100%FREE /dev/mapper/RootVG-varVol ;
  xfs_growfs  /var ; sudo xfs_growfs  /home

echo "Here are the space details:"
df -h

type minikube &>/dev/null
if [ $? -ne 0 ]; then
  dnf install https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm -y
fi

type docker &>/dev/null
if [ $? -ne 0 ]; then
  dnf install docker -y
fi

sysctl fs.protected_regular=0
curl -L -o /bin/kubectl "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x /bin/kubectl

minikube start --force

echo "Configuring hostname:"
set-hostname minikube

if [ $? -ne 0 ]; then
  echo "Minikube start failed run the below command to fix the issue"
  echo -e "\t minikube delete \n \t minikube start --force"
  exit 1
fi