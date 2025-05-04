#!/bin/bash

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

echo "This Property is neded to run minikube"
sysctl fs.protected_regular=0
echo "Running the following command - minikube start --force"
minikube start --force

if [ $? -ne 0 ]; then
  echo "Minikube start failed. Please check the logs for more details."
  echo "Run 'minikube delte' and start using 'minikube start --force'"
  exit 1
fi