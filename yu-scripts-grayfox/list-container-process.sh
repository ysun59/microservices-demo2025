#list-container-process.sh
#!/bin/bash

# hotel_reserv_reservation_mmc
# hotel_reserv_rate_mmc
# hotel_reserv_profile_mmc
# OCI runtime exec failed: exec failed: unable to start container process: exec: "ps": executable file not found in $PATH: unknown
# sh: 1: ps: not found
# Container hotel_reserv_profile_mmc: 0

# 所有进程数目
# ps -eo pid | wc -l
# ls /proc | grep '^[0-9]' | wc -l
#532， wrk 489


# 通过容器名得到进程数：
# docker exec -it zen_boyd ps aux --no-headers | wc -l
# docker exec -it zen_boyd ps -e --no-headers | wc -l
# (会多一个,因为ps aux也会算进去)

# docker top zen_boyd | tail -n +2 | wc -l

total=0
# for containerId in $(docker ps -q"); do
for containerId in $(docker ps --format "{{.Names}}"); do
    echo "containerId is: $containerId"
    # docker exec -it $containerId ps aux
    echo ""
    #根进程
    docker top $containerId
    docker top $containerId | tail -n +2 | wc -l
    echo "method 2 correct"
    #根进程下面的进程，应该是这个是对的，得到的数字还要再-2，第一行和ps这个进程
    docker exec $containerId ps -T
    docker exec $containerId ps -T | wc -l
    echo "method 3"
    #更详细的进程
    # docker exec $containerId sh -c "find /proc/*/task -type d 2>/dev/null"
    docker exec $containerId sh -c "find /proc/*/task -type d 2>/dev/null | wc -l"

    docker top $containerId -eo pid,ppid,comm,nlwp


# 在宿主机查看容器线程数（不进入容器）
    echo "method 4"
    mainPID=$(docker inspect -f '{{.State.Pid}}' $containerId)
    echo "mainPID is $mainPID"
    ls /proc/$mainPID/task | wc -l

    echo "method 5"
    mainPID=$(docker inspect -f '{{.State.Pid}}' $containerId)
    consulPID=$(ps -e -o pid,ppid,cmd | awk -v ppid=$mainPID '$2 == ppid && $3 ~ /consul/ { print $1 }')
    ls /proc/$consulPID/task | wc -l




# #   count=$(docker exec $containerId sh -c "ls /proc | grep '^[0-9]' | wc -l")
# #   docker exec -it $containerId ps aux --no-headers
#   
# #   docker exec $containerId sh -c "ps "
#     docker exec -it $containerId ps aux

#   count=$(docker exec $containerId sh -c "ps | tail -n +2 | wc -l")
#   echo "Container $containerId: $count"

#   total=$((total + count))
  echo "---------------"
done
echo "Total processes for microservice: $total"
