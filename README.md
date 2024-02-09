## Kafka on Kubernetes

This is an example of how to deploy [Kafka](https://kafka.apache.org/) on Kubernetes using Kafka's [Kraft](https://developer.confluent.io/learn/kraft/) mode.

[bitnamicharts/kafka](https://github.com/bitnami/charts/blob/main/bitnami/kafka/README.md) is used to deploy Kafka on Kubernetes.

## Prerequisites

Install these tools:

- [Helm](https://helm.sh/)
- [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [Minikube](https://minikube.sigs.k8s.io/docs/start/) (Optional)
  - Run `minikube start` to start a local Kubernetes cluster (if you don't have a cluster already)

## Quickstart

Add the Bitnami repository to Helm:

```
helm repo add bitnami https://charts.bitnami.com/bitnami
```

Run [deploy.sh](./scripts/deploy.sh) to deploy Kafka on your cluster:

```
./scripts/deploy.sh
```

When you're finished, run [undeploy.sh](./scripts/undeploy.sh) to remove Kafka from your cluster:

```
./scripts/undeploy.sh
```

## Testing the deployment

To test the deployment, you can use the [Kafka console producer and consumer](https://kafka.apache.org/quickstart) to send and receive messages.

```
kubectl run example-kafka-client --restart='Never' --image docker.io/bitnami/kafka:3.6.1-debian-11-r4 --namespace default --command -- sleep infinity
kubectl exec --tty -i example-kafka-client --namespace default -- bash
```

Once you've opened a shell in the `example-kafka-client` pod, you can use the Kafka console producer and consumer to send and receive messages.

To send messages:

```
kafka-console-producer.sh \
            --broker-list example-kafka-controller-0.example-kafka-controller-headless.default.svc.cluster.local:9092,example-kafka-controller-1.example-kafka-controller-headless.default.svc.cluster.local:9092,example-kafka-controller-2.example-kafka-controller-headless.default.svc.cluster.local:9092 \
            --topic test
```

To receive messages:

```
kafka-console-consumer.sh \
            --bootstrap-server example-kafka.default.svc.cluster.local:9092 \
            --topic test \
            --from-beginning
```

## Command Explanation

Within [deploy.sh](./scripts/deploy.sh), the following commands are used to deploy Kafka on Kubernetes:

1. Add the Bitnami repository to Helm:

```
helm install example-kafka oci://registry-1.docker.io/bitnamicharts/kafka --version 26.8.4 -f values.yaml
```

This command installs the `example-kafka` release using the `bitnami/kafka` chart from the Bitnami repository with [version 26.8.4](https://artifacthub.io/packages/helm/bitnami/kafka/26.8.5). The [values.yaml](values.yaml) file is used to configure the chart.

2. Create a Kubernetes service account and cluster role binding for the Kubernetes dashboard:

```
kubectl apply -f dashboard-adminuser.yaml
```

3. Get the Kubernetes dashboard token:

```
kubectl -n kubernetes-dashboard create token admin-user
```

This command creates a token for the `admin-user` service account in the `kubernetes-dashboard` namespace. The token is used to authenticate to the Kubernetes dashboard.

4. Proxy the Kubernetes dashboard:

```
kubectl proxy
```

This command starts a proxy server for the Kubernetes API server. The proxy server allows you to access the Kubernetes dashboard from your local machine.

You can access the dashboard at http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/.