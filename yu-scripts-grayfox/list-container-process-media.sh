#list-container-process-media.sh
#!/bin/bash
#method 1

# MediaMicroservice has 33 containers, 41 vCPUS.
# We set 29 containers to 1 cpus, set 2 containers to 2 cpus, set 2 containers to 4 cpus

total=0
for containerId in \
  mediamicroservices-review-storage-mongodb-1 \
  mediamicroservices-user-review-mongodb-1 \
  mediamicroservices-movie-review-mongodb-1 \
  mediamicroservices-unique-id-service-1 \
  mediamicroservices-text-service-1 \
  mediamicroservices-rating-service-1 \
  mediamicroservices-user-service-1 \
  mediamicroservices-review-storage-service-1 \
  mediamicroservices-user-review-service-1 \
  mediamicroservices-movie-review-service-1 \
  mediamicroservices-rating-redis-1 \
  mediamicroservices-movie-review-redis-1 \
  mediamicroservices-user-review-redis-1 \
  mediamicroservices-movie-id-memcached-1 \
  mediamicroservices-user-memcached-1 \
  mediamicroservices-review-storage-memcached-1 \
  mediamicroservices-cast-info-memcached-1 \
  mediamicroservices-plot-memcached-1 \
  mediamicroservices-movie-info-memcached-1 \
  mediamicroservices-movie-id-mongodb-1 \
  mediamicroservices-user-mongodb-1 \
  mediamicroservices-cast-info-mongodb-1 \
  mediamicroservices-plot-mongodb-1 \
  mediamicroservices-movie-info-mongodb-1 \
  mediamicroservices-cast-info-service-1 \
  mediamicroservices-plot-service-1 \
  mediamicroservices-movie-info-service-1 \
  mediamicroservices-dns-media-1 \
  mediamicroservices-jaeger-1 \
  mediamicroservices-movie-id-service-1 \
  mediamicroservices-compose-review-memcached-1 \
  mediamicroservices-compose-review-service-1
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
  mediamicroservices-nginx-web-server-1 
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
