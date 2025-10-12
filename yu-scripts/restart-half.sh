#restart-half.sh
#!/bin/bash

#kill old online boutique containers, and start new one
# 清缓存删除
kubectl delete -f /home/yu/k8s/microservices-demo/release/kubernetes-manifests-yu.yaml -n microservices-demo
kubectl get pods -A


sudo systemctl stop kubelet.service
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
# sudo systemctl status kubelet.service

# cVQHGMEe7QhH4Q
sudo systemctl start kubelet.service
sleep 5
sleep 120

# 不存在就创建命名空间
# kubectl get ns microservices-demo >/dev/null 2>&1 || kubectl create ns microservices-demo


cd ~/k8s/microservices-demo/
kubectl apply -f ./release/kubernetes-manifests-yu.yaml -n microservices-demo  
sleep 60
kubectl get pods -A

kubectl get svc frontend-external -n microservices-demo
kubectl -n microservices-demo patch svc frontend-external -p '{"spec":{"type":"NodePort"}}'
kubectl get pods -A


kubectl get pods -n microservices-demo -o wide | grep Running
kubectl get svc -A | grep frontend-external


# # 设置cpus和cpuset
/home/yu/k8s/microservices-demo/yu-scripts/random-container1-cpusRandom.sh
/home/yu/k8s/microservices-demo/yu-scripts/random-container2-2-cpuSet.sh

#verify1
# kubectl describe deployment adservice -n microservices-demo | grep -A 5 "Limits"

# source /home/yu/k8s/locust-venv/bin/activate
# cd /home/yu/k8s/microservices-demo/src/loadgenerator
# locust

# 开一个新的窗口
# ssh -L 38089:192.168.132.31:8089 yu@kaesi.dev (38089随便的)
# 打开chrome，http://localhost:38089/ （和ssh写的对应）
