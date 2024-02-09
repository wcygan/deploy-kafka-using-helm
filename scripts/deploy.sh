# Install the Kafka Helm chart
helm install example-kafka oci://registry-1.docker.io/bitnamicharts/kafka --version 26.8.4 -f values.yaml

# Create a service account for the dashboard
kubectl apply -f dashboard-adminuser.yaml

# Create a token for the dashboard and start the proxy
./scripts/token.sh