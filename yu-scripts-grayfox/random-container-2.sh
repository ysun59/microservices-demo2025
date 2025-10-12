#random-container-2.sh
#!/bin/bash

for fcId in \
  mediamicroservices-jaeger-1 \
  mediamicroservices-movie-id-service-1 
do 
    sudo docker update --cpus 2 $fcId
done


docker ps --format "{{.Names}}" | awk '/server_paymentservice/ {print $1}' | xargs -I {} sudo docker update --cpus 1 {}

#verification
#default is "NanoCpus": 0,
docker inspect $(docker ps --filter "name=server_paymentservice" -q) | grep -i nanocpus
#in k8s default is
# "CpuPeriod": 100000,
# "CpuQuota": 20000,
docker inspect $(docker ps --filter "name=server_paymentservice" -q) | grep -E 'CpuPeriod|CpuQuota'

#k8s里，CPU 资源的分配是通过 cpu.requests 和 cpu.limits 控制的
#设置pod的cpus 2, 然后会重启，然后CPU Requests: 1(太大会pending), CPU Limits: 2（主要是设置这个）
#等他type 变成 running了再跑
kubectl set resources deployment paymentservice -n microservices-demo --limits=cpu=2 --requests=cpu=1
#这个命令会自动删除更新（要等一下等它重启更新）
#inspect会得到，如果 cpu.limits=2，输出应该类似
# "CpuPeriod": 100000, 是默认值（100ms）
# "CpuQuota": 200000,代表最大使用 2 个 CPU（CpuQuota / CpuPeriod = 2）
# 或者这样验证
# kubectl get pods -n microservices-demo|grep Running
#kubectl describe pod paymentservice-cd7bd96dc-9757f -n microservices-demo | grep -A 5 "Limits"
#kubectl describe deployment paymentservice -n microservices-demo | grep -A 5 "Limits" （这个更好，名字变了也可以用）

**细节**
server_frontend
kubectl set resources deployment paymentservice -n microservices-demo --limits=cpu=2 --requests=cpu=1
如何看有哪些deployment
kubectl get deployments --all-namespaces
paymentservice
emailservice 
shippingservice

#########################
# cpuset: "17,19"设置
cpuset-cpus="17,19" 的行为, Pod 不会独占 CPU 17 和 19, 它只会使用它实际需要的 CPU 资源。
其他 Pod 仍然可以使用 CPU 17 和 19


3️⃣ 手动绑定到 CPU 17 和 19—但 Kubernetes 可能在 Pod 重新调度后覆盖此设置（不会独占CPU）+node selector
kubectl get pod paymentservice-78d5d5c5c9-4tq2w -n microservices-demo -o jsonpath='{.status.containerStatuses[0].containerID}'

docker update --cpuset-cpus="17,19" a587df313da90ad3f98484d140dac5c58925ef56a057b9a91e9542ac58b57e0e

验证：
docker inspect --format '{{.HostConfig.CpusetCpus}}' a587df313da90ad3f98484d140dac5c58925ef56a057b9a91e9542ac58b57e0e