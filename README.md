# Deploy and AKS Automatic cluster using Bicep

This project shows how to deploy an AKS automatic cluster configured with the following resources:

- [Azure Managed Prometheus](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/prometheus-metrics-overview) for metric collection.
- [Azure Managed Grafana](https://learn.microsoft.com/en-us/azure/managed-grafana/overview) for visualization
- [Container insights](https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-overview) for log collection

## What is Azure Kubernetes Service (AKS) Automatic?

[Azure Kubernetes Service (AKS) Automatic](https://learn.microsoft.com/en-us/azure/aks/intro-aks-automatic) offers an experience that makes the most common tasks on Kubernetes fast and frictionless, while preserving the flexibility, extensibility, and consistency of Kubernetes. Azure takes care of your cluster setup, including node management, scaling, security, and preconfigured settings that follow AKS well-architected recommendations. Automatic clusters dynamically allocate compute resources based on your specific workload requirements and are tuned for running production applications.

- **Production ready by default:** Clusters are preconfigured for optimal production use, suitable for most applications. They offer fully managed node pools that automatically allocate and scale resources based on your workload needs. Pods are bin packed efficiently, to maximize resource utilization.

- **Built-in best practices and safeguards:** AKS Automatic clusters have a hardened default configuration, with many cluster, application, and networking security settings enabled by default. AKS automatically patches your nodes and cluster components while adhering to any planned maintenance schedules.

- **Code to Kubernetes in minutes:** Go from a container image to a deployed application that adheres to best practices patterns within minutes, with access to the comprehensive capabilities of the Kubernetes API and its rich ecosystem.

## Deployment

You can find Bicep module and Bash scripts to deploy the AKS Automatic cluster via [Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview?tabs=bicep) and the companion [AKS Store](https://github.com/Azure-Samples/aks-store-demo) application. For more information, see [Quickstart: Deploy an Azure Kubernetes Service (AKS) Automatic cluster](https://learn.microsoft.com/en-us/azure/aks/learn/quick-kubernetes-automatic-deploy?pivots=bicep).