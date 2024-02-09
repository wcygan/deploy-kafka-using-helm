echo "Creating token for kubernetes dashboard"
TOKEN=$(kubectl -n kubernetes-dashboard create token admin-user)

# Check if pbcopy exists
if command -v pbcopy > /dev/null; then
    echo $TOKEN
    echo $TOKEN | pbcopy
    echo "Token copied to clipboard"
else
    echo "pbcopy not found, printing token"
    echo $TOKEN
fi

echo "Starting the proxy for kubernetes dashboard, access it at http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/"
kubectl proxy