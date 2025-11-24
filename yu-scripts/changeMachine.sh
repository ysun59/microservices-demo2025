#changeMachine.sh
#!/bin/bash

# If we changed the machine to another room, and machine name and ip has been changed. Here's the method to run the Online Boutique benchmark

# login in command
ssh -J yu@kaesi.dev yu@192.168.128.75
# Password
cVQHGMEe7QhH4Q

# Change to make the k8s works
sudo ip addr add 192.168.132.31/32 dev enp73s0f0
sudo hostnamectl set-hostname c1

sudo systemctl restart kubelet

# Verify
hostnamectl

# Revert the modification
sudo ip addr del 192.168.132.31/32 dev enp73s0f0
sudo hostnamectl set-hostname emr