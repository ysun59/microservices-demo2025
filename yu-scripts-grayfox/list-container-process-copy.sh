#list-container-process-copy.sh
#!/bin/bash
#method 1
total=0
for containerId in \
  socialnetwork-home-timeline-redis-1 \
  socialnetwork-user-timeline-redis-1 \
  socialnetwork-post-storage-mongodb-1 \
  socialnetwork-social-graph-service-1 \
  socialnetwork-post-storage-service-1 \
  socialnetwork-url-shorten-service-1 \
  socialnetwork-social-graph-redis-1 \
  socialnetwork-media-service-1 \
  socialnetwork-post-storage-memcached-1 \
  socialnetwork-url-shorten-memcached-1 \
  socialnetwork-media-memcached-1 \
  socialnetwork-social-graph-mongodb-1 \
  socialnetwork-user-mongodb-1 \
  socialnetwork-media-mongodb-1 \
  socialnetwork-user-service-1 \
  socialnetwork-unique-id-service-1 \
  socialnetwork-user-memcached-1 \
  socialnetwork-user-timeline-mongodb-1 \
  socialnetwork-user-timeline-service-1 \
  socialnetwork-user-mention-service-1 \
  socialnetwork-home-timeline-service-1 \
  socialnetwork-jaeger-agent-1 \
  socialnetwork-url-shorten-mongodb-1 \
  socialnetwork-text-service-1 \
  socialnetwork-compose-post-service-1
do 
    echo "containerId is: $containerId"
    #根进程
    docker top $containerId
    docker top $containerId | tail -n +2 | wc -l
    # 在宿主机查看容器线程数（不进入容器）
    echo "method 4"
    mainPID=$(docker inspect -f '{{.State.Pid}}' $containerId)
    echo "mainPID is $mainPID"
    ls /proc/$mainPID/task
    ls /proc/$mainPID/task | wc -l
    count=$(ls /proc/$mainPID/task | wc -l)
    echo "Container $containerId: $count"
    total=$((total + count))
    echo "---------------"
done


for containerId in \
  socialnetwork-media-frontend-1 \
  socialnetwork-nginx-thrift-1 
do 
    echo "containerId is: $containerId"
    echo ""
    #根进程
    docker top $containerId
    count=$(docker top $containerId | tail -n +2 | wc -l)

    echo "Container $containerId: $count"
    total=$((total + count))
    echo "---------------"
done

echo "Total processes for microservice: $total"


#method 2
# total=0
# for containerId in \
#   hotel_reserv_rate_mmc \
#   hotel_reserv_profile_mmc \
#   hotel_reserv_reservation_mmc \
#   hotel_reserv_geo_mongo \
#   hotel_reserv_profile_mongo \
#   hotel_reserv_rate_mongo \
#   hotel_reserv_recommendation_mongo \
#   hotel_reserv_user_mongo \
#   hotel_reserv_reservation_mongo
# do 
#     echo "containerId is: $containerId"
#     #根进程
#     docker top $containerId
#     docker top $containerId | tail -n +2 | wc -l
#     # 在宿主机查看容器线程数（不进入容器）
#     echo "method 4"
#     mainPID=$(docker inspect -f '{{.State.Pid}}' $containerId)
#     echo "mainPID is $mainPID"
#     ls /proc/$mainPID/task
#     ls /proc/$mainPID/task | wc -l
#     count=$(ls /proc/$mainPID/task | wc -l)
#     echo "Container $containerId: $count"
#     total=$((total + count))
#     echo "---------------"
# done


# for containerId in \
#   hotelreservation-consul-1 \
#   hotel_reserv_geo \
#   hotel_reserv_recommendation \
#   hotel_reserv_user \
#   hotel_reserv_jaeger \
#   hotel_reserv_search \
#   hotel_reserv_rate \
#   hotel_reserv_reservation \
#   hotel_reserv_profile 
# do 
#     echo "containerId is: $containerId"
#     echo ""
#     #根进程
#     docker top $containerId
#     docker top $containerId | tail -n +2 | wc -l
#     echo "method 2 correct"
#     #根进程下面的进程，应该是这个是对的，得到的数字还要再-2，第一行和ps这个进程
#     docker exec $containerId ps -T
#     docker exec $containerId ps -T | wc -l
#     count=$(docker exec $containerId ps -T | wc -l)
#     count=$((count - 2))
#     echo "Container $containerId: $count"
#     total=$((total + count))
#     echo "---------------"
# done
# echo "Total processes for microservice: $total"


# method 3-非常多
#更详细的进程
    # docker exec $containerId sh -c "find /proc/*/task -type d 2>/dev/null"
    # docker exec $containerId sh -c "find /proc/*/task -type d 2>/dev/null | wc -l"
