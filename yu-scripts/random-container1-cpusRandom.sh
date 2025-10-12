#random-container-2.sh
#!/bin/bash

# 这个代码，好像是设置k8s里面的cpus的，设置成1，2，4，32不等
# 名字这么取，好像是因为1让代表设置cpus，2让代表设置cpuset，3让代表设置custom我们的方法，所以
# 其中loadgenerator里2个容器都限制了，包括exited的k8s_frontend-check_loadgenerator
# loadgenerator删掉了，因为这个机器里好像没有
# 需要等一会等它重启，生效
for deploymentsName in \
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
    echo "ori setup is:"
    kubectl describe deployment $deploymentsName -n microservices-demo | grep -A 5 "Limits"
    # kubectl set resources deployment $deploymentsName -n microservices-demo --limits=cpu=1
    kubectl set resources deployment $deploymentsName -n microservices-demo --limits=cpu=2
    # kubectl set resources deployment $deploymentsName -n microservices-demo --limits=cpu=4
    # kubectl set resources deployment $deploymentsName -n microservices-demo --limits=cpu=32
    echo "after setup limits=cpu, curr setup is:"
    kubectl describe deployment $deploymentsName -n microservices-demo | grep -A 5 "Limits"
    echo "------------------------------------------------"
    echo ""
done
sleep 35
kubectl get pods -A 