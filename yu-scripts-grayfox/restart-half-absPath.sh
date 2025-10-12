#restart-half-absPath.sh
#!/bin/bash


# kubectl get pods -n microservices-demo -o wide | grep Running

#verify1
# kubectl describe deployment adservice -n microservices-demo | grep -A 5 "Limits"

kubectl apply -f ~/yu/microservices-demo/release/kubernetes-manifests.yaml -n microservices-demo
sleep 35
kubectl get pods -A
kubectl get svc -A 

# change LoadBalancer
# kubectl -n microservices-demo patch svc frontend-external  -p '{"spec": {"type": "NodePort"}}'
# # verify LoadBalancer changed to NodePort
# kubectl get svc -A
# kubectl get pods -A



# each time different
#curl http://localhost:31675

# ./random-container1-cpusRandom.sh 

# source /root/yu/microservices-demo/src/loadgenerator/venv/bin/activate
# locust -f ~/yu/microservices-demo/src/loadgenerator/locustfile.py
# 打开chrome, http://grayfox.cs.binghamton.edu:8089/

# deactivate
# kubectl delete -f ~/yu/microservices-demo/release/kubernetes-manifests.yaml -n microservices-demo
