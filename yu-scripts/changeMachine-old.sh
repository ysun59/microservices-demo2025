#changeMachine.sh
#!/bin/bash

# If we changed the machine to another room, here's the method to run the Online Boutique benchmark

# login in command
ssh -J yu@kaesi.dev yu@192.168.128.31
# Password
cVQHGMEe7QhH4Q

# Change to make the k8s works
DEV=$(ip route get 1.1.1.1 | awk '/dev/{print $5; exit}'); echo "dev=$DEV"
sudo ip addr add 192.168.132.31/32 dev "$DEV"
sudo systemctl restart kubelet

# Test - Run the benchmark
kubectl --server=https://192.168.132.31:6443 -n microservices-demo apply -f ./release/kubernetes-manifests-yu.yaml

# Revert the modification
sudo ip addr del 192.168.132.31/32 dev eno1
sudo systemctl restart kubelet