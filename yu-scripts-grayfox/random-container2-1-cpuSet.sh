#random-container-2-1-cpuSet.sh
#!/bin/bash

#其中loadgenerator里2个容器都限制了，包括exited的k8s_frontend-check_loadgenerator
#需要等一会等它重启，生效
# for deploymentsName in \
  # adservice \
  # cartservice \
  # checkoutservice \
  # currencyservice \
  # emailservice \
  # frontend \
  # loadgenerator \
  # paymentservice \
  # productcatalogservice \
  # recommendationservice \
  # redis-cart \
  # shippingservice
# do 
#     echo "ori setup is:"
#     kubectl describe deployment $deploymentsName -n microservices-demo | grep -A 5 "Limits"
#     kubectl set resources deployment $deploymentsName -n microservices-demo --limits=cpu=1
#     echo "after setup limits=cpu, curr setup is:"
#     kubectl describe deployment $deploymentsName -n microservices-demo | grep -A 5 "Limits"
#     echo "------------------------------------------------"
#     echo ""
# done
# sleep 10


####################################################################
#设置cpuset
#缺点，重启会被覆盖
let n=0
for podPartName in \
  adservice \
  cartservice \
  checkoutservice \
  currencyservice \
  emailservice \
  frontend \
  loadgenerator \
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

    # CPU_SET="$n,$((n+2))"
    CPU_SET="$n"
    echo "the ori cpuset setup is:"
    docker inspect --format '{{.HostConfig.CpusetCpus}}' $CONTAINER_ID
    echo "setup cpuset, curr cpuset setup is:"
    docker update --cpuset-cpus="$CPU_SET" "$CONTAINER_ID"
    docker inspect --format '{{.HostConfig.CpusetCpus}}' $CONTAINER_ID
    # ((n += 4))
    ((n += 2))
    echo "------------------------------------------------"
    echo ""
done