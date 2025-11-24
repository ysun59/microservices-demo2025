# scripts to set cpus and cpuset

This folder contains scripts used to start the **Online Boutique** benchmark, configure **CPUs** and **CPU sets**, and adjust settings when the machine location changes — ensuring the benchmark continues to work properly.


## restart-half.sh
After finishing a benchmark test, this script can terminate the old Kubernetes benchmark and start a new one.
After running it, you’ll need to manually run locust

## random-container1-cpusRandom.sh
This script configures the **CPU limits** for Kubernetes deployments (e.g., setting CPUs to 1, 2, 4, or 32).
You can modify line 25:
```bash
kubectl set resources deployment $deploymentsName -n microservices-demo --limits=cpu=2
```
to assign different CPU counts to containers.

## random-container2-1-cpuSet.sh
This script configures CPU sets, assigning 1 core per container. 

It sets the containers to core 0; core 2; core 4; core 6, etc.

**⚠️ Note**
The setting will be reset after a restart.
Therefore, always set **CPUs first**, then **CPU sets**.

## random-container2-2-cpuSet.sh
This script configures CPU sets, assigning 2 cores per container.

It sets the containers to core 0, 2; core 4, 6; core 8, 10, etc.

**⚠️ Note**
The setting will be reset after a restart.
Always set **CPUs first**, then **CPU sets**.

## random-container2-4-cpuSet.sh
This script configures CPU sets, assigning 4 cores per container.

It sets the containers to core 0, 1, 2, 3; core 4, 5, 6, 7; core 8, 9, 10, 11, etc.

**⚠️ Note**
The setting will be reset after a restart.
Always set **CPUs first**, then **CPU sets**.

## changeMachine.sh
If the physical machine has been moved to a new room or subnet, use this script (and the following instructions) to re-run the Online Boutique benchmark.
```bash
cd /home/yu/k8s/microservices-demo2025/yu-scripts
./changeMachine.sh
```
Or
```bash
cd /home/yu/k8s/microservices-demo2025/yu-scripts
./changeMachine-old.sh
```

**New login**
```bash
ssh -J yu@kaesi.dev yu@192.168.128.31
# password:cVQHGMEe7QhH4Q
```
For IPMI access:
```bash
ssh -L 8444:192.168.130.31:443 yu@kaesi.dev
```
Then open `https://127.0.0.1:8444` and login with user `ADMIN` pass `ADMIN`


**Original login**
```bash
ssh -J yu@kaesi.dev yu@192.168.132.31
```
For IPMI access:
```bash
ssh -L 8443:192.168.134.31:443 yu@kaesi.dev
```
Then open `https://127.0.0.1:8443` and login with user `ADMIN` pass `ADMIN`
