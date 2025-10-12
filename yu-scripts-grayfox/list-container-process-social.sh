#list-container-process-social.sh
#!/bin/bash
#method 1

# SocialNetwork has 27 containers, 40 vCPUS.
# We set 18 containers to 1 cpus, set 7 containers to 2 cpus, set 2 containers to 4 cpus

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
