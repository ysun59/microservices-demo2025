#random-container-2.sh
#!/bin/bash

#设置cpuset
#设置给0，1，2，3； 4，5，6，7； 8，9，10，11，每个容器给4个core
#缺点，重启会被覆盖, 所以要先设置cpus，之后再设置cpuset
let n=0
for podPartName in \
  adservice \
  cartservice \
  checkoutservice \
  currencyservice \
  emailservice \
  frontend \
  paymentservice \
  productcatalogservice \
  recommendationservice \
  redis-cart \
  shippingservice
do 
    kubectl get pod -n microservices-demo -l app=$podPartName
    #或者过滤掉terminationg的，如果有多个符合条件的，都会列出，每个一行
    POD_NAME=$(kubectl get pod -n microservices-demo -l app=$podPartName | grep Running | grep -v Terminating | awk '{print $1}')
    echo "POD_NAME is" $POD_NAME
    CONTAINER_ID=$(kubectl get pod "$POD_NAME" -n microservices-demo -o jsonpath='{.status.containerStatuses[0].containerID}' | sed 's/docker:\/\///')
    echo "container id is " $CONTAINER_ID

    CPU_SET="$n,$((n+1)),$((n+2)),$((n+3))"
    echo "the ori cpuset setup is:"
    docker inspect --format '{{.HostConfig.CpusetCpus}}' $CONTAINER_ID
    echo "setup cpuset, curr cpuset setup is:"
    docker update --cpuset-cpus="$CPU_SET" "$CONTAINER_ID"
    docker inspect --format '{{.HostConfig.CpusetCpus}}' $CONTAINER_ID
    ((n += 4))
    echo "------------------------------------------------"
    echo ""
done
