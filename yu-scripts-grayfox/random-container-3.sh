#random-container-3.sh
#!/bin/bash


#k8s里，CPU 资源的分配是通过 cpu.requests 和 cpu.limits 控制的
#设置pod的cpus 2, 然后会重启，然后CPU Requests: 1(太大会pending,不设置 --requests=cpu=1了), CPU Limits: 2（主要是设置这个）
#等他type 变成 running了再跑
kubectl set resources deployment paymentservice -n microservices-demo --limits=cpu=2
#这个命令会自动删除更新（要等一下等它重启更新）
#inspect会得到，如果 cpu.limits=2，docker inspect $(docker ps --filter "name=server_paymentservice" -q) | grep -E 'CpuPeriod|CpuQuota'输出应该类似
# "CpuPeriod": 100000, 是默认值（100ms）
# "CpuQuota": 200000,代表最大使用 2 个 CPU（CpuQuota / CpuPeriod = 2）
# 或者这样验证
# 看有哪些pod, kubectl get pods -n microservices-demo|grep Running
kubectl describe deployment paymentservice -n microservices-demo | grep -A 5 "Limits"  #这个更好，名字变了也可以用）

**细节**
如何看有哪些deployment
kubectl get deployments --all-namespaces
paymentservice
emailservice 
shippingservice
loadgenerator

#这个里面有2个容器
docker ps -a | grep "loadgenerator" #(看一共有哪些容器)
kubectl describe deployment loadgenerator -n microservices-demo | grep -A 5 "Limits" 
kubectl get deployment loadgenerator -n microservices-demo -o jsonpath='{range .spec.template.spec.containers[*]}{.name}{"\n"}{.resources}{"\n"}{end}'

kubectl set resources deployment loadgenerator -n microservices-demo --limits=cpu=3
kubectl describe deployment loadgenerator -n microservices-demo | grep -A 5 "Limits" #验证发现2个都设置了




#总结
#第一句话设置，第二句话验证，就可以了。
kubectl set resources deployment shippingservice -n microservices-demo --limits=cpu=2
kubectl describe deployment shippingservice -n microservices-demo | grep -A 5 "Limits"  #这个更好，名字变了也可以用）


#########################
# cpuset: "17,19"设置
cpuset-cpus="17,19" 的行为, Pod 不会独占 CPU 17 和 19, 它只会使用它实际需要的 CPU 资源。
其他 Pod 仍然可以使用 CPU 17 和 19
缺点：重启会被覆盖


3️⃣ 手动绑定到 CPU 17 和 19—但 Kubernetes 可能在 Pod 重新调度后覆盖此设置（不会独占CPU）+node selector
kubectl get pod paymentservice-68848c7456-qznnj -n microservices-demo -o jsonpath='{.status.containerStatuses[0].containerID}'

docker update --cpuset-cpus="17,19" d7ccca2be22a74f15edb2d77643223aad3987dd32bfc51c9f5328e6b39b87257

验证：
docker inspect --format '{{.HostConfig.CpusetCpus}}' d7ccca2be22a74f15edb2d77643223aad3987dd32bfc51c9f5328e6b39b87257

真正脚本
#找到running状态的最后一个，就是最新的
kubectl get pod -n microservices-demo -l app=paymentservice --field-selector=status.phase=Running -o jsonpath='{.items[-1:].metadata.name}'
#或者过滤掉terminationg的，如果有多个符合条件的，都会列出，每个一行
kubectl get pod -n microservices-demo -l app=paymentservice | grep Running | grep -v Terminating | awk '{print $1}'


POD_NAME=$(kubectl get pod -n microservices-demo -l app=paymentservice --field-selector=status.phase=Running -o jsonpath='{.items[-1:].metadata.name}')
CONTAINER_ID=$(kubectl get pod "$POD_NAME" -n microservices-demo -o jsonpath='{.status.containerStatuses[0].containerID}' | sed 's/docker:\/\///')
docker update --cpuset-cpus="17,19" "$CONTAINER_ID"


这句话好像所有这个名字pod都出来了,所以换了个写法只列出running的
kubectl get pods -n microservices-demo -l app=paymentservice


