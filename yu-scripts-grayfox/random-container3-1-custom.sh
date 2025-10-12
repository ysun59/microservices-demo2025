#random-container3-1-custom.sh
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
#     kubectl set resources deployment $deploymentsName -n microservices-demo --limits=cpu=2
#     echo "after setup limits=cpu, curr setup is:"
#     kubectl describe deployment $deploymentsName -n microservices-demo | grep -A 5 "Limits"
#     echo "------------------------------------------------"
#     echo ""
# done
# sleep 10

####################################################################
#设置我们的方法
for fcId in \
  k8s_server_adservice \
  k8s_server_cartservice \
  k8s_server_checkoutservice \
  k8s_server_currencyservice \
  k8s_server_emailservice \
  k8s_server_frontend \
  k8s_main_loadgenerator \
  k8s_server_paymentservice \
  k8s_server_productcatalogservice \
  k8s_server_recommendationservice \
  k8s_redis_redis-cart \
  k8s_server_shippingservice
do 
    containerId=$(docker ps --filter "name=$fcId" --format "{{.ID}}" | xargs docker inspect --format '{{.Id}}')
    echo "$fcId's container Id is $containerId"

    uID=$(docker inspect ${containerId} --format '{{.Config.Labels}}' | grep -oP 'io.kubernetes.pod.uid:\K\S+' | sed 's/-/_/g')
    echo "UID is $uID"    

    max_cpu_distribution=$(cat "/sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod${uID}.slice/${containerId}/cpu.max_cpu_distribution")
    echo "$fcId's ori max distributation $max_cpu_distribution"
    echo "/sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod${uID}.slice/${containerId}/cpu.max_cpu_distribution"
    echo 1 > "/sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod${uID}.slice/${containerId}/cpu.max_cpu_distribution"
    # echo 4 > "/sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod${uID}.slice/${containerId}/cpu.max_cpu_distribution"
    max_cpu_distribution=$(cat "/sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod${uID}.slice/${containerId}/cpu.max_cpu_distribution")
    echo "$fcId's curr max distributation $max_cpu_distribution"
    echo "============================================"
done