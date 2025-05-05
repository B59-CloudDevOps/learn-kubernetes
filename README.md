# learn-kubernetes

What is kubernetes ?
    Kuberntes is a container orchestrator tool which was an internal product from google till 2014 and Google made it openSource in 2014

    Kubernetes is an open-source platform for automating deployment, scaling, and management of containerized applications.
It groups containers into logical units called "pods" for easier orchestration and resource management.
Kubernetes runs across clusters of machines, making applications highly available and resilient.

> How can I learn Kubernetes ?

    1) You can set up your own kuberntes cluster on your own nodes either on cloud or on-prem 
    2) You can use the managed service on AWS: EKS ( Elastic Kubernetes Service ) 
    3) Minikube ( This is a sandbox kubernetes environment) : Let's learn all the basics on this and then we can start going to EKS. 

> Kubectl vs kubelet

    kubectl: k8's client used to connect to kubernetes cluster which is installed on the computer/server from where we are connecting 
    kubelet: This is a local leader on the node which is going to report the node and worker status to the k8 master

> Can kube-api server talk to any other components ?

    In Kubernetes, the kube-apiserver is the central communication hub—it is the only component authorized to interact with all other components within the cluster.

    For example, the scheduler does not communicate directly with etcd, nor does etcd communicate directly with the controller manager. All interactions flow through the kube-apiserver, ensuring a consistent and secure communication model.

> How to install kubectl ?
       $ curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
       $ curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
       $ sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
        ``` 
        chmod +x kubectl
        mkdir -p ~/.local/bin
        mv ./kubectl ~/.local/bin/kubectl # and then append (or prepend) ~/.local/bin to $PATH
        ```
       $ kubectl version --client [ To verify installation ]

> What are minikube hardware requirement ?

```
    2 CPUs or more
    2GB of free memory
    30GB of free disk space
```

> How to install minikube ? Ensure you provision the lab instance with 30gb and t3.medium 

    https://minikube.sigs.k8s.io/docs/start/?arch=%2Flinux%2Fx86-64%2Fstable%2Fbinary+download
    0) Ensure you fix the space issue
        $ growpart /dev/nvme0n1 4
        $ sudo lvextend -l +50%FREE /dev/mapper/RootVG-homeVol ;
        $ sudo lvextend -l +1000%FREE /dev/mapper/RootVG-varVol ;
        $ sudo xfs_growfs  /var ; sudo xfs_growfs  /home
    1) Install Docker: 
        $ sudo dnf install docker -y 
    2) Download Minikube
        $ curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
    3) Install minikube
        $ sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64
    4) Start minikubne
        $ minikube start

