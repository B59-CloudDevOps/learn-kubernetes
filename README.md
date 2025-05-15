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


Deployment Types:
    1) Rolling update: Moves from one version to another version sequentially, we would encounter near zero downtime. But during updates, users will experience both the versions. 

    2) Recreate Update: Deletes all the pods of the set at a time and recreates the pods with newer version. Involved some downtime. 

    3) Blue Green Deployment

> Why you create a service ?
    1) To expose it 
       
       Frontend ( Public )    :  In this case we will go with K8 SVC of type LB ( which is going to provision loadbalancer )
       Backend  ( Internal )  : In this case, we will go with K8 SCV of type Cluster IP ( This is 100% internal to the cluster, which can only be accessed by the services inside the cluster )
       Mysql    ( Internal )
    
> Service In Kubernetes:
    1) Why you need a service ? To expose
    2) Based on from where we need to expose our service, we will use one among them:
        a) Cluster IP ( default )
        b) Load Balancer
        c) Node Port
        d) External Name

    North - South Communication ( Communication from internet to service on kubernetes )
    East - Sest communications ( Communication between services on kubernetes)

>>> NodePort & LoadBalancers don't work on minikube <<<

How one service in one namespace-x can talk to other service in another namespace-y ?

> How a Fully Qualified Domain Name of a service on Kubernetes looks like ?

    serviceName.nameSpace.svc.cluster.local 

    There is a service named svc-x in ns-x & another service named svc-y in ns-y ?

    If x wants to communicate with y, then x has to refer y the following way 

       From x-ns,  svc-y.ns-y.svc.cluster.local 

```
# kc exec -it nginx -n expense -- bash
    root@nginx:/# curl nginx-deployment-svc
    curl: (6) Could not resolve host: nginx-deployment-svc
    root@nginx:/# curl nginx-deployment-svc.roboshop.svc.cluster.local
    <!DOCTYPE html>
    <html>
    <head>
    <title>Welcome to nginx!</title>
    <style>
    html { color-scheme: light dark; }
    body { width: 35em; margin: 0 auto;
    font-family: Tahoma, Verdana, Arial, sans-serif; }
    </style>
    </head>
    <body>
    <h1>Welcome to nginx!</h1>
    <p>If you see this page, the nginx web server is successfully installed and
    working. Further configuration is required.</p>

    <p>For online documentation and support please refer to
    <a href="http://nginx.org/">nginx.org</a>.<br/>
    Commercial support is available at
    <a href="http://nginx.com/">nginx.com</a>.</p>

    <p><em>Thank you for using nginx.</em></p>
    </body>
</html>
```

> Who defines the maximum CPU and Memory that can be used by the provision pod on a kubernetes cluster ?
    By default, if we don't mentioned those details, pod can use as much as it can as per the Nodes availability & this can also lead to the pod going to Out Of Resources. It's always a best practice to offer Limits & Requests for CPU and Memory when scheduling the k8 resources. 

    Keep in mind, the max cpu, memory that can be declared should always be less than 85% of the node's cpu / memory. 


> How to can define what's the max and min resources that can be used by the pods ?
    Using Limits & Requests

        Requests: Lower cap, min resources that has be allocated for the pod to be scheduled.
        Limits: Upper cap, max resources that the pod can use on the top of the node. 
    
    Limits & Requests are at the container level of the pod. If the pod has 2 containers, we can define 2 sets of limits & requests in such case

1. Resource Requests
    What it is: The minimum amount of CPU or memory that a container is guaranteed.
    Why it matters: Kubernetes uses this to schedule pods. If a node doesn’t have enough available resources to satisfy the request, the pod won’t be scheduled there.
    Analogy: Think of this as a reservation.

2. Resource Limits
    What it is: The maximum amount of CPU or memory that a container is allowed to use.
    Why it matters: If the container tries to use more than the limit:
    For CPU: it will be throttled.
    For memory: it can be terminated (OOMKilled).

> What will happen if you try to schedule a pod on a node that has not enough resources ? 
    > Pod will not be scheduled, it remains in Pending State

What are the pod states that we have see so far ?
    1) Running State 
    2) ImagePull Back Error 
    3) CrashloopbackOff
    4) OutOfMemory
    5) Pending

> How do we know the resource details on the nodes of a kubernetes cluster ?
    We can install metrics server that's going to extract the node metrics and can show you
        $ kubectl top nodes
    
    Ref: https://github.com/kubernetes-sigs/metrics-server 

    kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

    [ If your run this on minikube, you'd would need to do some tls tuning ]

> On minikube, LB, NodePort were not working and we can also see that few of the aspects are not working.
So, let's proceed with provisioning an AWS Managed Kubernetes Cluster : EKS ( Elastic Kubernetes Service ) 

    When we use Kubernetes on a managed service like EKS:   
        1) Node autoscaling & deprovisioning can be automated and are handled by AWS 
        2) Here, you don't have control on the Master Node or Control Plan, we don't even be seeing it.  
        3) On EKS, we call the group of nodes as NodeGroup

> What is the scope of EKS Cluster ?
    1) Zonal:  Both master and work nodes are on the same zone of the regions  ( One master and nodegroup , both of the same zone )
    2) Multi-zonal: Nodes of the nodegroup would be speading across the selected zones of the region. ( One master in zone-x and nodegroups in x,y zones )
    3) Regional: Nodes of the node group & master would be on more than one zone. 

> What will happen if you lost the node that has pods of the sets running in a nodeGroup of the k8 cluster ?
    * Pods will be recreated on other node of the node group 

> What will happen if you lose the master node ? 
    If someone asks you this question, your answer should be:
        1) Is that a Multi-zonal cluster or a regional cluster? 
        
        2) If the answer is multi-zonal cluster, that means one master & multiple nodeGroups: 
                In this case, if you lose the one existing master node:
                    * You can no longer connect to the cluster.
                    * Existing workloads on the cluster will run as is 
                    * New workloads cannot be scheduled as we cannot connect.
                    * If you lose one pod of a SET, new pods won't be scheduled. 

        3) If the answer is regional cluster, that means more than one master & multiple nodeGroups: 
                In this case, if you lose one of the existing master node:
                    * We can still connect to the cluster.
                    * Existing workloads on the cluster will run as is.
                    * New workloads can also be scheduled as is as we have other working master node.
                    * If you lose one pod of a SET, new pods will be scheduled as is.

> Let's proceed with provisioning EKS Cluster:
    EKS: Elastic Kubernetes Service

    Note: When you use a managed service, you don't have go do the os patch manitenance of the underlying hosts, you only need to patch the nodePools and this goes by a single click of a button.

> Tomorrow, we will use terraform and provision EKS by using the EKS Module from Terraform registry 

> What is AWS EKS Mode ?

> Why EKS Cluster when provisioning needs an IAM Role? 
    EKS Cluster has to interact with other services like Load Balancers, EC2 , CloudWatch 

> Why EKS Cluster's Nodepools also needs an IAM Role ?
    Node pools reports metrics to Cloud watch, Accessing EKS API, To pull the images from container registry, For autoscaling of nodes as well. 

> How can we connect to the kuberntes cluster ?
    You need to generate the kube-config file.
        $ aws eks udpate-kubeconfig --name clusterName

> What is the kube-config file ?
    This file has the authentication information needed to connect to the cluster along with the cluster details.

> Location of the kube-config file ?
    /home/yourProfile/.kube/config

> let's focus on RBAC, Network Security, Container & Pod Security 

Here are the top 3 principles that any resource to be followed in the infrastructure:

 1) Authentication
 2) Authorization     ( Least Privilege Principle ) : Role Based Access Control
 3) Auditing 

> Role Based Access Control ( RBAC )
    1) On k8 cluster, we will creat a role with Pod, CM, Secret list Only access.
    2) Using Role Binding, we will bind this role to a user.
    3) Then that user will only that listing the pods, cm or secrets in the cluster.

> Kubernetes is all about service accounts,
    We will configure the workloads with these service accounts and we will assign the roles to the service accounts using Role Binding. So that those resources will get the needed permissions.

    We can create a SA, grant the roles and provison a token which can be assigned to human and human can connect to cluster using that role.

> Let's use K8 SA's token to autheticate to k8 cluster and test the rbac 

    1) Create sa 
    2) Provision the token  ( kubectl create token saName )
    3) Paste this token to the cluster kube config 
    4) Create role and using roleBidning, assign that role to this sa
    5) Using this sa, let's connect to cluster and see the limitations.

eyJhbGciOiJSUzI1NiIsImtpZCI6IjdiNGFkZTZiY2Q5Nzc2MWRmMWUyNjA3MGQxNWEwMWJlZjI5MDExMDEifQ.eyJhdWQiOlsiaHR0cHM6Ly9rdWJlcm5ldGVzLmRlZmF1bHQuc3ZjIl0sImV4cCI6MTc0NzEwMDc2NywiaWF0IjoxNzQ3MDk3MTY3LCJpc3MiOiJodHRwczovL29pZGMuZWtzLnVzLWVhc3QtMS5hbWF6b25hd3MuY29tL2lkLzYzRUQxRkRCQTU1MDEyN0VEODM3NjcwNjAyMzcxOTg2IiwianRpIjoiMmE0MWY4NzktMTYxMC00NDY3LTk0ZDctMmFlMzIyYWZmNTFmIiwia3ViZXJuZXRlcy5pbyI6eyJuYW1lc3BhY2UiOiJkZWZhdWx0Iiwic2VydmljZWFjY291bnQiOnsibmFtZSI6ImV4cGVuc2Utc2EiLCJ1aWQiOiJiMzMxNWI3NS1mMjA5LTRjMDMtYWJhYi0yZmQ3ZTVmYTVjOTkifX0sIm5iZiI6MTc0NzA5NzE2Nywic3ViIjoic3lzdGVtOnNlcnZpY2VhY2NvdW50OmRlZmF1bHQ6ZXhwZW5zZS1zYSJ9.jw0ZO6kl5tPXNBAx2D3akdjHI0eazEykisHfZd8gh0AJxxXa9p41IZ4A8EIoYk0o8NGT4-3cyc6Ymq9em1Rt5ER3mcvHzi4B2bwIGVsUyZDTn4xmVLqdpwXtVCVZnwlWiFvYfUt4FAdcL3-kgZ4lwK0SWDa_s35aJe0BeMaxg8tW_z7KIztWsWF4fYDOZghQHiGCSaIAqcncfwjMnmf67PeF6COILYTAY9BdjNMONb0qf5KtnpuRKgzOskrRw-CxeALPSYelPjmVEYhKtc4DzPbvFJQbo1URup-QokL7Yb13BChtSzLJK3HlrfT0Wh5KXH3_vmh5SiI8PKh9FzDkxQ

> Roles in kubernetes are of 2 types:
    1) Roles ( Scope is just with in the mentioned namespace )  
        Ex: control access to pod, restrict reading secrets in x nameSpace , deny creating configMap in x nameSpace 
    2) ClusterRole ( Scope is across the cluster. This is to control creating namespace, allow roles )


> Network policies 
    These are like security groups on kuberntes cluster. Using this can deny communication or enable communication among the namespaces.
    To use these, we need to enable an add on called "AWS VPC CNI" 

> What is the CNI used on AWS EKS ?
    AWS VPC CNI : This enables pod networking within your cluster. 
    Whenever you enable an addon on EKS, technically aws on the backend is deploying those resources for you in the kube-system namespace

> Network Policies ( Start with ) : Yesetrday we didn't record the session, so will reCap this.

> HPA vs VPA 
    Horizontal Pod Autoscaling, Vertical Pod Autoscaling 

    VPA: The same pod with the turned down and based on the recommendation controller will allocate more resources, but this involves downtime 
        VPA can be deployed in 2 modes: 
            Manual Mode  ( vpc just gives you recommendations on what are limits and requests of the cpu and & memory)
            Auto Mode    ( Automatically updates the values )
        Most of the times, we do the tuning of cpu, memory by VPA in manual mode.

> Can HPA & VPA work together ?
    Yes, but:
    HPA scales replicas.
    VPA adjusts resource requests.
    Be careful: HPA scales based on resource utilization %, which VPA can affect by changing resource requests.
    Best practice: Use VPA for recommendations only, or tune both with care.

> Taints & Tolerations: 

    When you taint a node, you cannot schedule any pods by default or pods will not be scueduled on the nodes that has taints

> Then what's the user of taints ?  

    If you want specific workloads to be deployed to a specific nodes, then we taint those nodes and workloads that needs to be running on the top of those nodes would be tolerated. 

    Only workloads that has tolerations will be deployed on the tainted nodes by the scheduler.

> How to taint a node ?

    $ kubectl taint nodes node1 key1=value1:NoSchedule

> What will happen once you taint a node ?
    Since then, no new workloads will be scheduled on the tainted nodes. 

> How can we target our workloads to be tolerant to those taints ?
    You need to add tolerations to our workloads based on the tainted node 
    