#!/bin/bash

# echo -e "NAMESPACE\tPOD\t\t\tCONTAINER\tPROCESS_COUNT"

# # 获取所有运行中的 pod
# kubectl get pods --all-namespaces --field-selector=status.phase=Running -o json | \
# jq -r '.items[] | [.metadata.namespace, .metadata.name, (.spec.containers[]?.name)] | @tsv' | \
# while IFS=$'\t' read -r namespace pod container; do
#   # 先尝试 sh，如果 sh 不存在，再尝试 bash
#   count=$(kubectl exec -n "$namespace" -c "$container" "$pod" -- sh -c "ls /proc | grep '^[0-9]\+$' | wc -l" 2>/dev/null)

#   if [[ -z "$count" ]]; then
#     count=$(kubectl exec -n "$namespace" -c "$container" "$pod" -- bash -c "ls /proc | grep '^[0-9]\+$' | wc -l" 2>/dev/null)
#   fi

#   if [[ -z "$count" ]]; then
#     count="(cannot access shell)"
#   fi

#   printf "%s\t%s\t%s\t\t%s\n" "$namespace" "$pod" "$container" "$count"
# done

##########################

# #!/bin/bash

# echo -e "NAMESPACE\tPOD\t\t\tCONTAINER\tPROCESS_COUNT"

# total=0

# # 遍历所有 Running 且未 Terminating 的容器
# kubectl get pods --all-namespaces -o json | \
# jq -r '
#   .items[]
#   | select(.status.phase == "Running")
#   | select(.metadata.deletionTimestamp == null)
#   | . as $pod
#   | .status.containerStatuses[]?
#   | select(.state.running != null)
#   | [$pod.metadata.namespace, $pod.metadata.name, .name]
#   | @tsv' | while IFS=$'\t' read -r namespace pod container; do

#   # 尝试 sh
#   count=$(kubectl exec -n "$namespace" -c "$container" "$pod" -- sh -c "ls /proc | grep '^[0-9]\+$' | wc -l" 2>/dev/null)

#   # 如果失败，再试 bash
#   if [[ -z "$count" ]]; then
#     count=$(kubectl exec -n "$namespace" -c "$container" "$pod" -- bash -c "ls /proc | grep '^[0-9]\+$' | wc -l" 2>/dev/null)
#   fi

#   # 清除空格和换行
#   count=$(echo "$count" | tr -d '\r' | tr -d '\n' | xargs)

#   # 判断是否为纯数字
#   if [[ "$count" =~ ^[0-9]+$ ]]; then
#     total=$((total + count))
#     printf "%s\t%s\t%s\t\t%s\n" "$namespace" "$pod" "$container" "$count"
#   else
#     printf "%s\t%s\t%s\t\t(no shell)\n" "$namespace" "$pod" "$container"
#   fi
# done

# echo -e "\n👉 Total running processes (accessible containers only): $total"
###########################
NAMESPACE=microservices-demo

for POD in $(kubectl get pods -n $NAMESPACE --field-selector=status.phase=Running -o jsonpath='{.items[*].metadata.name}'); do
  echo "Checking Pod: $POD"

  # 获取第一个容器名
  CONTAINER=$(kubectl get pod $POD -n $NAMESPACE -o jsonpath='{.spec.containers[0].name}')

  # 检查容器中是否有 /bin/sh
  if kubectl exec -n $NAMESPACE $POD -c $CONTAINER -- test -x /bin/sh 2>/dev/null; then
    PROC_COUNT=$(kubectl exec -n $NAMESPACE $POD -c $CONTAINER -- /bin/sh -c "ls /proc | grep '^[0-9]\\+\$' | wc -l")
    echo "Pod $POD ($CONTAINER) has $PROC_COUNT processes"
  else
    echo "Pod $POD ($CONTAINER) has no shell available, skipping..."
  fi

  echo ""
done
