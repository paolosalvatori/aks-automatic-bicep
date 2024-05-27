#/bin/bash

# Variables
source ./00-variables.sh

# Check if the cluster issuer already exists
result=$(kubectl get ClusterIssuer -o json | jq -r '.items[].metadata.name | select(. == "'$clusterIssuer'")')

if [[ -n $result ]]; then
	echo "[$clusterIssuer] cluster issuer already exists"
	exit
else
	# Create the cluster issuer
	echo "[$clusterIssuer] cluster issuer does not exist"
	echo "Creating [$clusterIssuer] cluster issuer..."
	cat cluster-issuer.yml | yq "(.spec.acme.email)|="\""$email"\" | kubectl apply -f -
fi