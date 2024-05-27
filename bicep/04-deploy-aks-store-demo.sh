#!/bin/bash

# for more information, see https://learn.microsoft.com/en-us/azure/aks/learn/quick-kubernetes-automatic-deploy

# Variables
source ./00-variables.sh

# Check if namespace exists in the cluster
result=$(kubectl get namespace -o jsonpath="{.items[?(@.metadata.name=='$namespace')].metadata.name}")

if [[ -n $result ]]; then
  echo "$namespace namespace already exists in the cluster"
else
  echo "$namespace namespace does not exist in the cluster"
  echo "creating $namespace namespace in the cluster..."
  kubectl create namespace $namespace
fi

# Deploy the store demo application
kubectl apply -n $namespace -f aks-store-all-in-one-ingress.yaml