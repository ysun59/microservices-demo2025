#restart-half.sh
#!/bin/bash

systemctl stop kubelet.service
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
systemctl status kubelet.service

systemctl start kubelet.service
sleep 40
kubectl get pods -n microservices-demo -o wide | grep Running

#verify1
# kubectl describe deployment adservice -n microservices-demo | grep -A 5 "Limits"

# cd /root/yu/microservices-demo/src/loadgenerator/venv
# source bin/activate
# cd ..
# locust
# 打开chrome，http://128.226.119.92:8089/
