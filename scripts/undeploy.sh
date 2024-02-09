helm delete example-kafka
kubectl delete -f dashboard-adminuser.yaml
kubectl delete pod example-kafka-client --wait=false