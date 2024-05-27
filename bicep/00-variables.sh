# Azure Subscription and Tenant
subscriptionId=$(az account show --query id --output tsv)
subscriptionName=$(az account show --query name --output tsv)
tenantId=$(az account show --query tenantId --output tsv)

# Variables
prefix="Shark"
acrName="${prefix,,}acr"
acrResourceGrougName="${prefix}RG"
location="eastus"
attachAcr=false


# NGINX Ingress Controller installed via Helm
nginxNamespace="ingress-basic"
nginxRepoName="ingress-nginx"
nginxRepoUrl="https://kubernetes.github.io/ingress-nginx"
nginxChartName="ingress-nginx"
nginxReleaseName="ingress-nginx"
nginxReplicaCount=3

# NGINX Ingress Controller installed via AKS application routing add-on
webAppRoutingNamespace="app-routing-system"
webAppRoutingServiceName="nginx"

# Certificate Manager
cmNamespace="cert-manager"
cmRepoName="jetstack"
cmRepoUrl="https://charts.jetstack.io"
cmChartName="cert-manager"
cmReleaseName="cert-manager"

# Cluster Issuer
email="paolos@microsoft.com"
clusterIssuer="letsencrypt-webapprouting"

# AKS Cluster
aksClusterName="${prefix}Aks"
aksResourceGroupName="${prefix}RG"

# Namespace
namespace="aks-store-demo"

# Ingress and DNS
dnsZoneName="babosbird.com"
dnsZoneResourceGroupName="DnsResourceGroup"
storeFrontSubdomain="atlasfront"
storeAdminSubdomain="atlasadmin"
ingressClassName="webapprouting.kubernetes.azure.com"