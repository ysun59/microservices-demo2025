#test.sh
#!/bin/bash

# # #看pod里有几个容器
# # for POD in $(kubectl get pods -n microservices-demo | grep Running | awk '{print $1}'); do
# # 	kubectl describe pod $POD  -n microservices-demo | grep -E "Container ID|Name"
# # 	echo ""
# # done

# docker ps --filter "name=k8s_server_frontend" --format "{{.ID}}"


# #manually set spread limit of frontend using docker update --cpus 1 CONTAINER
# #限制容器的spread limit
# for fcId in \
#   hotelreservation-consul-1 \
#   hotel_reserv_geo \
#   hotel_reserv_recommendation \
#   hotel_reserv_user \
#   hotel_reserv_jaeger \
#   hotel_reserv_rate_mmc \
#   hotel_reserv_profile_mmc \
#   hotel_reserv_geo_mongo \
#   hotel_reserv_profile_mongo \
#   hotel_reserv_rate_mongo \
#   hotel_reserv_recommendation_mongo \
#   hotel_reserv_reservation_mongo \
#   hotel_reserv_user_mongo
# do 
#     containerId=$(docker inspect --format '{{.Id}}' $fcId)
#     echo "$fcId's container Id is $containerId"
#     echo 1 > "/sys/fs/cgroup/cpu/docker/${containerId}/cpu.max_cpu_distribution"
#     max_cpu_distribution=$(cat "/sys/fs/cgroup/cpu/docker/${containerId}/cpu.max_cpu_distribution")
#     echo "$fcId's max distributation $max_cpu_distribution"
# done



# #部分容器名
# k8s_server_frontend会有一个exited,一个么有
# loadgenerator的话check的不要

# for fcId in \
  # k8s_server_adservice \
  # k8s_server_cartservice \
  # k8s_server_checkoutservice \
  # k8s_server_currencyservice \
  # k8s_server_emailservice \
  # k8s_server_frontend \
  # k8s_main_loadgenerator \
  # k8s_server_paymentservice \
  # k8s_server_productcatalogservice \
  # k8s_server_recommendationservice \
  # k8s_redis_redis-cart \
  # k8s_server_shippingservice
# do 
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
    echo 2 > "/sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod${uID}.slice/${containerId}/cpu.max_cpu_distribution"
    max_cpu_distribution=$(cat "/sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod${uID}.slice/${containerId}/cpu.max_cpu_distribution")
    echo "$fcId's curr max distributation $max_cpu_distribution"
    echo "============================================"
done



# 对应paymentservice的容器id是41462858e0d8bd1d54097b0755e7de84c9776f2e9a1debadcaa497b6c5078216


# #完整的容器id
# docker ps --filter "name=$fcId" --format "{{.ID}}" | xargs docker inspect --format '{{.Id}}'


# /sys/fs/cgroup/cpu/kubepods.slice/kubepods-burstable.slice
# kubepods-besteffort.slice/kubepods-besteffort-pod0d279dcc_7ad7_4422_bfa4_180d38b83ca7.slice/fde7324e7e56881ccc12d0011648ce89d403d4d89b77b426e3b34d99c4b7cb6d/


# k8s_main_loadgenerator's container Id is e297b9fa35185affab20b7b0fc28421747a289944b19a64183f01b3ca094d36b
# 对应kubepods-burstable-pod29227497_356a_4ebb_aba2_a1b522d9b4dc.slice/d955b512ca7b9e1459c96e2b2f490795b4b9be672530bd33c4a6a57147ae032c

# kubectl get pod --all-namespaces -o json | jq '.items[] | select(.status.containerStatuses[] | .containerID == "e297b9fa35185affab20b7b0fc28421747a289944b19a64183f01b3ca094d36b") | .metadata.name'
# kubectl get pods --all-namespaces -o json | jq '.items[] | select(.status.containerStatuses[] | .containerID == "fde7324e7e56881ccc12d0011648ce89d403d4d89b77b426e3b34d99c4b7cb6d") | .metadata.uid'


# UID
# docker inspect e297b9fa35185affab20b7b0fc28421747a289944b19a64183f01b3ca094d36b --format '{{.Config.Labels}}' | grep -oP 'io.kubernetes.pod.uid:\K\S+'
# docker inspect e297b9fa35185affab20b7b0fc28421747a289944b19a64183f01b3ca094d36b --format '{{.Config.Labels}}' | grep -oP 'io.kubernetes.pod.uid:\K\S+' | sed 's/-/_/g'

# kubepods-burstable-pod571de7be-484c-416a-94a5-7dee548273d7.slice
# kubepods-burstable-pod571de7be_484c_416a_94a5_7dee548273d7.slice