$ sudo minikube start --force
    😄  minikube v1.35.0 on Redhat 9.4
    ❗  minikube skips various validations when --force is supplied; this may lead to unexpected behavior
    ✨  Using the podman driver based on existing profile
    🛑  The "podman" driver should not be used with root privileges. If you wish to continue as root, use --force.
    💡  If you are running minikube within a VM, consider using --driver=none:
    📘    https://minikube.sigs.k8s.io/docs/reference/drivers/none/
    💡  Tip: To remove this root owned cluster, run: sudo minikube delete
    👍  Starting "minikube" primary control-plane node in "minikube" cluster
    🚜  Pulling base image v0.0.46 ...
    E0504 20:16:58.345309    1936 cache.go:222] Error downloading kic artifacts:  not yet implemented, see issue #8426
    🔄  Restarting existing podman container for "minikube" ...
    🤦  StartHost failed, but will try again: driver start: start: sudo -n podman start --cgroup-manager cgroupfs minikube: exit status 125
    stdout:

    stderr:
    Error: no container with name or ID "minikube" found: no such container

    😿  Failed to start podman container. Running "minikube delete" may fix it: boot lock: unable to open /tmp/juju-mkb63ae66e893d288f67f2a5f7037e90ebe08078: permission denied

    ❌  Exiting due to HOST_JUJU_LOCK_PERMISSION: Failed to start host: boot lock: unable to open /tmp/juju-mkb63ae66e893d288f67f2a5f7037e90ebe08078: permission denied
    💡  Suggestion: Run 'sudo sysctl fs.protected_regular=0', or try a driver which does not require root, such as '--driver=docker'
    🍿  Related issue: https://github.com/kubernetes/minikube/issues/6391

Do this:
    1) sudo minikube delete 