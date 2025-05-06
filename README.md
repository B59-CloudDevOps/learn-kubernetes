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

> How to test the connectivity to the cluster or get the cluster info

    $ kubectl cluster-info
        Kubernetes control plane is running at https://192.168.49.2:8443
        CoreDNS is running at https://192.168.49.2:8443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

        To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
        
> How can we connect to kubernetes cluster
    1) kubectl  ( cli way of accessing the cluster : This is the most preferred & highly used )
    2) non-cli  ( K9s ) 
    3) K9s UI   ( Octane )

> Going forward, we don't say we will run the containers on kubernetes. Instead, we say we run the pods. 

> What is a POD in kubernetes ?
Pod is the smalled computable component on kubernetes cluster and on this we container will run and this is referred as a "Wrapper To The Containers"

> A Pod (as in a pod of whales or pea pod) is a group of one or more containers, with shared storage and network resources, and a specification for how to run the containers. A Pod's contents are always co-located and co-scheduled, and run in a shared context.

> One of the biggerst operational challenge of Shared Storage & Network was solved by Kubernetes via Pods and it's a big achievement

> Kubernetes offers lots of varieties of respources and it's all about API's,
    You want x-resourc,e you need use some api 
    You want x-resourc,e you need use some api [ No need to byheart any of these, it's all available in the documentaiton ]

> kubernetes command syntax:

    $ kubectl verb  resource  [ syntax ]
    $ kubectl get pods
    $ kubectl cluster-info 
    $ kubectl api-versions  

> Kuberntes offers lot of variety of resources to compliment the pods functionality and these resources can be created by the follwing ways:

    1) Manual approach ( By suppling the values : This is not recommended as we cannot version control it )
        $ kubectl run nginx-pod --image=nginx

    2) Declarative approach ( Define all the needed properties as per the documentation and version control it: This is the recommended pattern ) 

    K8 resources can be created in declarative pattern by using YAML 

        $ kubectl create -f fileName.yaml
        $ kubectl apply -f fileName.yaml 

> How can I see the properties of the pod ?

        $ kubectl describe pod podName

> How can I delete all the resources mentioned in a manifest file ?

        $ kubectl delete -f fileName.yaml 

> Important use case on kubernetes cluster!!!

    On kubernetes, resources can be utilized very efficiently. 

    1) If you have a kuberntes cluster, this can be logically provisioned in to multiple spaces and can be delegated to multiple teams 
    2) You can host, qa, dev , sit environments in a single cluster without interference to each other

    This can be achieved by using a concept called as namespace. By default, on kuberntes cluster resources in one namespace can communicate with other pods in other namespaces. However we can control the behavior if we wish to restrict using a concept called as Network Policy.  
     
> On kubernetes cluster, we have these namespaces to host different resources 
    # kubectl get ns

        kube-system  [ control plane components are hosted on this namespace ]
        kube-public 
        default      [ If you don't the namespace, k8 resources will be hosted on the default namespace ]
    
    # kube-system namespace:
        This is where the control plane (master) components and core cluster services typically run:

        kube-apiserver – Exposes the Kubernetes API.
        kube-controller-manager – Runs controllers to manage cluster state.
        kube-scheduler – Assigns pods to nodes.
        etcd – Key-value store for cluster data (sometimes run separately).
        CoreDNS – Cluster DNS service.
        cloud-controller-manager – Interacts with cloud provider APIs (if used).

    # kube-public namespace:

        Mostly empty by default.
        Publicly readable across all users; used to expose cluster info (like the cluster-info ConfigMap).
        Not for hosting control plane components.

> How to run a specific command on a pod non-interactively

    $ kubectl exec podName  -- commandToExecute 
    $ kubectl exec nginx-env  -- env


> How to enter in to the pod interactively ?

    $ kubectl exec -it podName -- bash 

> Whenever you have a common set of properties that needs to be supplied across the componets of the kubernetes, then rather supplying manually, we tend to create a resource called as ConfigMap and we inject this configMap in to the pods. 


> Keep in mind, pods are immutable. If you want to do some, you cannot do it on the same pod, even if you don't you'll lose the changes.


### In reality, we don't directly create pods. They would be done by using SETS. You provision sets will provision the pods

> If you pods are provisioned by SETS:
    1) They will take care of the pods availability. Even if something got deleted, they create it automatically 
    2) If you want to scale up or down, sets will take care of it.
    3) If you want a singple pod per node as per the nodes scalabililty  
    4) They help you in moving pods from one version to another version ( v1 to v2 ) 

Keep in mind, we never create pods directly. We will deploy SETS and sets will create the pods. And these pods will be managed by SETS

> Based on the use case, there are 4 varieties of sets offered in kubernetes as of today:

    1) Replica Set       : A ReplicaSet is a controller that ensures a specified number of replicas (identical copies) of a pod are running in a cluster at all times. ReplicaSets help to ensure high availability and scalability by automatically scaling the number of pod replicas up or down in response to changes in demand or hardware failures.
    2) Deployment Set    :
    3) Daemon Set 
    4) Stateful Set 

What is a rolling udpate vs Recreate based deployment ? 