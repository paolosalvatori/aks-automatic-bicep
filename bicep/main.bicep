@description('Specifies the name prefix of the managed cluster resource.')
param prefix string = uniqueString(resourceGroup().id)

@description('Specifies whether name resources are in CamelCase, UpperCamelCase, or KebabCase.')
@allowed([
  'CamelCase'
  'UpperCamelCase'
  'KebabCase'
])
param letterCaseType string = 'UpperCamelCase'

@description('Specifies the location of the resource.')
param location string = resourceGroup().location

@description('Specifies the resource tags.')
param tags object = {
  IaC: 'Bicep'
}

@description('Specifies the name of the AKS cluster.')
param aksClusterName string = letterCaseType == 'UpperCamelCase'
  ? '${toUpper(first(prefix))}${toLower(substring(prefix, 1, length(prefix) - 1))}Aks'
  : letterCaseType == 'CamelCase' ? '${toLower(prefix)}Aks' : '${toLower(prefix)}-aks'

@description('Specifies the unique name of of the system node pool profile in the context of the subscription and resource group.')
param systemAgentPoolName string = 'system'

@description('Specifies the vm size of nodes in the system node pool.')
param systemAgentPoolVmSize string = 'Standard_DS5_v2'

@description('Specifies the OS Disk Size in GB to be used to specify the disk size for every machine in the system agent pool. If you specify 0, it will apply the default osDisk size according to the vmSize specified.')
param systemAgentPoolOsDiskSizeGB int = 100

@description('Specifies the OS disk type to be used for machines in a given agent pool. Allowed values are Ephemeral and Managed. If unspecified, defaults to Ephemeral when the VM supports ephemeral OS and has a cache disk larger than the requested OSDiskSizeGB. Otherwise, defaults to Managed. May not be changed after creation. Managed or Ephemeral')
@allowed([
  'Ephemeral'
  'Managed'
])
param systemAgentPoolOsDiskType string = 'Ephemeral'

@description('Specifies the number of agents (VMs) to host docker containers in the system node pool. Allowed values must be in the range of 1 to 100 (inclusive). The default value is 1.')
param systemAgentPoolAgentCount int = 3

@description('Specifies the unique name of of the user mode node pool profile in the context of the subscription and resource group.')
param userAgentPoolName string = 'user'

@description('Specifies the vm size of nodes in the user mode node pool.')
param userAgentPoolVmSize string = 'Standard_DS5_v2'

@description('Specifies the OS Disk Size in GB to be used to specify the disk size for every machine in the user mode agent pool. If you specify 0, it will apply the default osDisk size according to the vmSize specified.')
param userAgentPoolOsDiskSizeGB int = 100

@description('Specifies the OS disk type to be used for machines in a given agent pool. Allowed values are Ephemeral and Managed. If unspecified, defaults to Ephemeral when the VM supports ephemeral OS and has a cache disk larger than the requested OSDiskSizeGB. Otherwise, defaults to Managed. May not be changed after creation. Managed or Ephemeral')
@allowed([
  'Ephemeral'
  'Managed'
])
param userAgentPoolOsDiskType string = 'Ephemeral'

@description('Specifies the number of agents (VMs) to host docker containers in the user mode node pool. Allowed values must be in the range of 1 to 100 (inclusive). The default value is 1.')
param userAgentPoolAgentCount int = 3

@description('Specifies the name of the Log Analytics Workspace.')
param logAnalyticsWorkspaceName string = letterCaseType == 'UpperCamelCase'
  ? '${toUpper(first(prefix))}${toLower(substring(prefix, 1, length(prefix) - 1))}Workspace'
  : letterCaseType == 'CamelCase' ? '${toLower(prefix)}Workspace' : '${toLower(prefix)}-workspace'

@description('Specifies the service tier of the workspace: Free, Standalone, PerNode, Per-GB.')
@allowed([
  'Free'
  'Standalone'
  'PerNode'
  'PerGB2018'
])
param logAnalyticsSku string = 'PerGB2018'

@description('Specifies the workspace data retention in days. -1 means Unlimited retention for the Unlimited Sku. 730 days is the maximum allowed for all other Skus.')
param logAnalyticsRetentionInDays int = 60

@description('Specifies the name of the Azure Monitor managed service for Prometheus resource.')
param prometheusName string = letterCaseType == 'UpperCamelCase'
  ? '${toUpper(first(prefix))}${toLower(substring(prefix, 1, length(prefix) - 1))}Prometheus'
  : letterCaseType == 'CamelCase' ? '${toLower(prefix)}Prometheus' : '${toLower(prefix)}-prometheus'

@description('Specifies whether or not public endpoint access is allowed for the Azure Monitor managed service for Prometheus resource.')
@allowed([
  'Enabled'
  'Disabled'
])
param dataCollectionEndpointPublicNetworkAccess string = 'Enabled'

@description('Specifies the name of the Azure Managed Grafana resource.')
param grafanaName string = letterCaseType == 'UpperCamelCase'
  ? '${toUpper(first(prefix))}${toLower(substring(prefix, 1, length(prefix) - 1))}Grafana'
  : letterCaseType == 'CamelCase' ? '${toLower(prefix)}Grafana' : '${toLower(prefix)}-grafana'

@description('Specifies the sku of the Azure Managed Grafana resource.')
param grafanaSkuName string = 'Standard'

@description('Specifies the api key setting of the Azure Managed Grafana resource.')
@allowed([
  'Disabled'
  'Enabled'
])
param grafanaApiKey string = 'Enabled'

@description('Specifies the scope for dns deterministic name hash calculation.')
@allowed([
  'TenantReuse'
])
param grafanaAutoGeneratedDomainNameLabelScope string = 'TenantReuse'

@description('Specifies whether the Azure Managed Grafana resource uses deterministic outbound IPs.')
@allowed([
  'Disabled'
  'Enabled'
])
param grafanaDeterministicOutboundIP string = 'Disabled'

@description('Specifies the the state for enable or disable traffic over the public interface for the the Azure Managed Grafana resource.')
@allowed([
  'Disabled'
  'Enabled'
])
param grafanaPublicNetworkAccess string = 'Enabled'

@description('The zone redundancy setting of the Azure Managed Grafana resource.')
@allowed([
  'Disabled'
  'Enabled'
])
param grafanaZoneRedundancy string = 'Disabled'

@description('Specifies the user object id for the cluster admin.')
@secure()
param userObjectId string

resource logWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: logAnalyticsWorkspaceName
  location: location
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    sku: {
      name: logAnalyticsSku
    }
    retentionInDays: logAnalyticsRetentionInDays
  }
}

resource prometheusWorkspace 'Microsoft.Monitor/accounts@2023-04-03' = {
  name: prometheusName
  location: location
}

resource grafanaDashboard 'Microsoft.Dashboard/grafana@2023-09-01' = {
  name: grafanaName
  location: location
  tags: tags
  sku: {
    name: grafanaSkuName
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    apiKey: grafanaApiKey
    autoGeneratedDomainNameLabelScope: grafanaAutoGeneratedDomainNameLabelScope
    deterministicOutboundIP: grafanaDeterministicOutboundIP
    publicNetworkAccess: grafanaPublicNetworkAccess
    zoneRedundancy: grafanaZoneRedundancy

    grafanaIntegrations: {
      azureMonitorWorkspaceIntegrations: [
        {
          azureMonitorWorkspaceResourceId: prometheusWorkspace.id
        }
      ]
    }
  }
}

resource mmonitoringReaderRole 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: '43d0d8ad-25c7-4714-9337-8ba259a9fe05'
  scope: subscription()
}

resource monitoringDataReaderRole 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: 'b0d8363b-8ddd-447d-831f-62ca05bff136'
  scope: subscription()
}

resource grafanaAdminRole 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: '22926164-76b3-42b3-bc55-97df8dab3e41'
  scope: subscription()
}

// Assign the Grafana Admin role to the Microsoft Entra ID user at the Azure Managed Grafana resource scope
resource grafanaAdminRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(subscription().id, resourceGroup().id, userObjectId, 'Grafana Admin')
  scope: grafanaDashboard
  properties: {
    principalId: userObjectId
    principalType: 'User'
    roleDefinitionId: grafanaAdminRole.id
  }
}

// Assign the Monitoring Reader role to the Azure Managed Grafana system-assigned managed identity at the workspace scope
resource monitoringReaderRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(grafanaDashboard.name, prometheusWorkspace.name, mmonitoringReaderRole.id)
  scope: prometheusWorkspace
  properties: {
    roleDefinitionId: mmonitoringReaderRole.id
    principalId: grafanaDashboard.identity.principalId
    principalType: 'ServicePrincipal'
  }
}

// Assign the Monitoring Data Reader role to the Azure Managed Grafana system-assigned managed identity at the workspace scope
resource monitoringDataReaderRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(grafanaDashboard.name, prometheusWorkspace.name, monitoringDataReaderRole.id)
  scope: prometheusWorkspace
  properties: {
    roleDefinitionId: monitoringDataReaderRole.id
    principalId: grafanaDashboard.identity.principalId
    principalType: 'ServicePrincipal'
  }
}

resource aksCluster 'Microsoft.ContainerService/managedClusters@2024-03-02-preview' = {
  name: aksClusterName
  location: location
  tags: tags
  sku: {
    name: 'Automatic'
    tier: 'Standard'
  }
  properties: {
    agentPoolProfiles: [
      {
        name: systemAgentPoolName
        count: systemAgentPoolAgentCount
        vmSize: systemAgentPoolVmSize
        osDiskSizeGB: systemAgentPoolOsDiskSizeGB
        osDiskType: systemAgentPoolOsDiskType
        osType: 'Linux'
        mode: 'System'
        securityProfile: {
          sshAccess: 'Disabled'
          enableVTPM: false
          enableSecureBoot: false
        }
      }
      {
        name: userAgentPoolName
        count: userAgentPoolAgentCount
        vmSize: userAgentPoolVmSize
        osDiskSizeGB: userAgentPoolOsDiskSizeGB
        osDiskType: userAgentPoolOsDiskType
        osType: 'Linux'
        mode: 'User'
        securityProfile: {
          sshAccess: 'Disabled'
          enableVTPM: false
          enableSecureBoot: false
        }
      }
    ]
    addonProfiles: {
      omsagent: {
        enabled: true
        config: {
          logAnalyticsWorkspaceResourceID: logWorkspace.id
          useAADAuth: 'true'
        }
      }
    }
    azureMonitorProfile: {
      metrics: {
        enabled: true
        kubeStateMetrics: {
          metricLabelsAllowlist: '*'
          metricAnnotationsAllowList: '*'
        }
      }
      containerInsights: {
        enabled: true
        logAnalyticsWorkspaceResourceId: logWorkspace.id
      }
    }
  }
  identity: {
    type: 'SystemAssigned'
  }
}

resource azureKubernetesServiceRBACClusterAdmin 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: 'b1ff04bb-8a4e-4dc4-8eb5-8693973ce19b'
  scope: subscription()
}

resource clusterAdminRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(subscription().id, resourceGroup().id, userObjectId, 'Azure Kubernetes Service RBAC Cluster Admin')
  scope: aksCluster
  properties: {
    principalId: userObjectId
    principalType: 'User'
    roleDefinitionId: azureKubernetesServiceRBACClusterAdmin.id
  }
}

resource dataCollectionEndpoint 'Microsoft.Insights/dataCollectionEndpoints@2022-06-01' = {
  name: 'MSProm-${location}-${aksCluster.name}'
  location: location
  kind: 'Linux'
  properties: {
    description: 'Data Collection Endpoint for Prometheus'
    networkAcls: {
      publicNetworkAccess: dataCollectionEndpointPublicNetworkAccess
    }
  }
}

resource dataCollectionRuleAssociationEndpoint 'Microsoft.Insights/dataCollectionRuleAssociations@2022-06-01' = {
  name: 'configurationAccessEndpoint'
  scope: aksCluster
  properties: {
    dataCollectionEndpointId: dataCollectionEndpoint.id
  }
}

resource dataCollectionRuleMSCI 'Microsoft.Insights/dataCollectionRules@2022-06-01' = {
  name: 'MSCI-${location}-${aksCluster.name}'
  location: location
  tags: tags
  kind: 'Linux'
  properties: {
    dataSources: {
      syslog: []
      extensions: [
        {
          streams: [
            'Microsoft-ContainerInsights-Group-Default'
          ]
          extensionName: 'ContainerInsights'
          extensionSettings: {
            dataCollectionSettings: {
              interval: '1m'
              namespaceFilteringMode: 'Off'
              enableContainerLogV2: true
            }
          }
          name: 'ContainerInsightsExtension'
        }
      ]
    }
    destinations: {
      logAnalytics: [
        {
          workspaceResourceId: logWorkspace.id
          name: 'ciworkspace'
        }
      ]
    }
    dataFlows: [
      {
        streams: [
          'Microsoft-ContainerInsights-Group-Default'
        ]
        destinations: [
          'ciworkspace'
        ]
      }
    ]
  }
}

resource dataCollectionRuleAssociationMSCI 'Microsoft.Insights/dataCollectionRuleAssociations@2022-06-01' = {
  name: 'MSCI-${location}-${aksCluster.name}'
  scope: aksCluster
  properties: {
    dataCollectionRuleId: dataCollectionRuleMSCI.id
  }
}

resource dataCollectionRuleMSProm 'Microsoft.Insights/dataCollectionRules@2022-06-01' = {
  name: 'MSProm-${location}-${aksCluster.name}'
  location: location
  tags: tags
  kind: 'Linux'
  properties: {
    dataCollectionEndpointId: dataCollectionEndpoint.id
    dataSources: {
      prometheusForwarder: [
        {
          streams: [
            'Microsoft-PrometheusMetrics'
          ]
          name: 'PrometheusDataSource'
        }
      ]
    }
    destinations: {
      monitoringAccounts: [
        {
          accountResourceId: prometheusWorkspace.id
          name: 'MonitoringAccount1'
        }
      ]
    }
    dataFlows: [
      {
        streams: [
          'Microsoft-PrometheusMetrics'
        ]
        destinations: [
          'MonitoringAccount1'
        ]
      }
    ]
  }
}

resource dataCollectionRuleAssociationMSProm 'Microsoft.Insights/dataCollectionRuleAssociations@2022-06-01' = {
  name: 'MSProm-${location}-${aksCluster.name}'
  scope: aksCluster
  properties: {
    dataCollectionRuleId: dataCollectionRuleMSProm.id
  }
}

resource prometheusK8sRules 'Microsoft.AlertsManagement/prometheusRuleGroups@2023-03-01' = {
  name: 'KubernetesRecordingRulesRuleGroup - ${aksCluster.name}'
  location: location
  properties: {
    enabled: true
    description: 'Kubernetes Recording Rules RuleGroup'
    clusterName: aksCluster.name
    scopes: [
      prometheusWorkspace.id
      aksCluster.id
    ]
    interval: 'PT1M'
    rules: [
      {
        record: 'node_namespace_pod_container:container_cpu_usage_seconds_total:sum_irate'
        expression: 'sum by (cluster, namespace, pod, container) (irate(container_cpu_usage_seconds_total{job="cadvisor", image!=""}[5m])) * on (cluster, namespace, pod) group_left(node) topk by (cluster, namespace, pod) (1, max by(cluster, namespace, pod, node) (kube_pod_info{node!=""}))'
      }
      {
        record: 'node_namespace_pod_container:container_memory_working_set_bytes'
        expression: 'container_memory_working_set_bytes{job="cadvisor", image!=""}* on (namespace, pod) group_left(node) topk by(namespace, pod) (1, max by(namespace, pod, node) (kube_pod_info{node!=""}))'
      }
      {
        record: 'node_namespace_pod_container:container_memory_rss'
        expression: 'container_memory_rss{job="cadvisor", image!=""}* on (namespace, pod) group_left(node) topk by(namespace, pod) (1, max by(namespace, pod, node) (kube_pod_info{node!=""}))'
      }
      {
        record: 'node_namespace_pod_container:container_memory_cache'
        expression: 'container_memory_cache{job="cadvisor", image!=""}* on (namespace, pod) group_left(node) topk by(namespace, pod) (1, max by(namespace, pod, node) (kube_pod_info{node!=""}))'
      }
      {
        record: 'node_namespace_pod_container:container_memory_swap'
        expression: 'container_memory_swap{job="cadvisor", image!=""}* on (namespace, pod) group_left(node) topk by(namespace, pod) (1, max by(namespace, pod, node) (kube_pod_info{node!=""}))'
      }
      {
        record: 'cluster:namespace:pod_memory:active:kube_pod_container_resource_requests'
        expression: 'kube_pod_container_resource_requests{resource="memory",job="kube-state-metrics"} * on (namespace, pod, cluster)group_left() max by (namespace, pod, cluster) ((kube_pod_status_phase{phase=~"Pending|Running"} == 1))'
      }
      {
        record: 'namespace_memory:kube_pod_container_resource_requests:sum'
        expression: 'sum by (namespace, cluster) (sum by (namespace, pod, cluster) (max by (namespace, pod, container, cluster) (kube_pod_container_resource_requests{resource="memory",job="kube-state-metrics"}) * on(namespace, pod, cluster) group_left() max by (namespace, pod, cluster) (kube_pod_status_phase{phase=~"Pending|Running"} == 1)))'
      }
      {
        record: 'cluster:namespace:pod_cpu:active:kube_pod_container_resource_requests'
        expression: 'kube_pod_container_resource_requests{resource="cpu",job="kube-state-metrics"} * on (namespace, pod, cluster)group_left() max by (namespace, pod, cluster) ((kube_pod_status_phase{phase=~"Pending|Running"} == 1))'
      }
      {
        record: 'namespace_cpu:kube_pod_container_resource_requests:sum'
        expression: 'sum by (namespace, cluster) (sum by (namespace, pod, cluster) (max by (namespace, pod, container, cluster) (kube_pod_container_resource_requests{resource="cpu",job="kube-state-metrics"}) * on(namespace, pod, cluster) group_left() max by (namespace, pod, cluster) (kube_pod_status_phase{phase=~"Pending|Running"} == 1)))'
      }
      {
        record: 'cluster:namespace:pod_memory:active:kube_pod_container_resource_limits'
        expression: 'kube_pod_container_resource_limits{resource="memory",job="kube-state-metrics"} * on (namespace, pod, cluster)group_left() max by (namespace, pod, cluster) ((kube_pod_status_phase{phase=~"Pending|Running"} == 1))'
      }
      {
        record: 'namespace_memory:kube_pod_container_resource_limits:sum'
        expression: 'sum by (namespace, cluster) (sum by (namespace, pod, cluster) (max by (namespace, pod, container, cluster) (kube_pod_container_resource_limits{resource="memory",job="kube-state-metrics"}) * on(namespace, pod, cluster) group_left() max by (namespace, pod, cluster) (kube_pod_status_phase{phase=~"Pending|Running"} == 1)))'
      }
      {
        record: 'cluster:namespace:pod_cpu:active:kube_pod_container_resource_limits'
        expression: 'kube_pod_container_resource_limits{resource="cpu",job="kube-state-metrics"} * on (namespace, pod, cluster)group_left() max by (namespace, pod, cluster) ( (kube_pod_status_phase{phase=~"Pending|Running"} == 1) )'
      }
      {
        record: 'namespace_cpu:kube_pod_container_resource_limits:sum'
        expression: 'sum by (namespace, cluster) (sum by (namespace, pod, cluster) (max by (namespace, pod, container, cluster) (kube_pod_container_resource_limits{resource="cpu",job="kube-state-metrics"}) * on(namespace, pod, cluster) group_left() max by (namespace, pod, cluster) (kube_pod_status_phase{phase=~"Pending|Running"} == 1)))'
      }
      {
        record: 'namespace_workload_pod:kube_pod_owner:relabel'
        expression: 'max by (cluster, namespace, workload, pod) ((label_replace(label_replace(kube_pod_owner{job="kube-state-metrics", owner_kind="ReplicaSet"}, "replicaset", "$1", "owner_name", "(.*)") * on(replicaset, namespace) group_left(owner_name) topk by(replicaset, namespace) (1, max by (replicaset, namespace, owner_name) (kube_replicaset_owner{job="kube-state-metrics"})), "workload", "$1", "owner_name", "(.*)"  )))'
        labels: {
          workload_type: 'deployment'
        }
      }
      {
        record: 'namespace_workload_pod:kube_pod_owner:relabel'
        expression: 'max by (cluster, namespace, workload, pod) ((label_replace(kube_pod_owner{job="kube-state-metrics", owner_kind="DaemonSet"}, "workload", "$1", "owner_name", "(.*)")))'
        labels: {
          workload_type: 'daemonset'
        }
      }
      {
        record: 'namespace_workload_pod:kube_pod_owner:relabel'
        expression: 'max by (cluster, namespace, workload, pod) ((label_replace(kube_pod_owner{job="kube-state-metrics", owner_kind="StatefulSet"}, "workload", "$1", "owner_name", "(.*)")))'
        labels: {
          workload_type: 'statefulset'
        }
      }
      {
        record: 'namespace_workload_pod:kube_pod_owner:relabel'
        expression: 'max by (cluster, namespace, workload, pod) ((label_replace(kube_pod_owner{job="kube-state-metrics", owner_kind="Job"}, "workload", "$1", "owner_name", "(.*)")))'
        labels: {
          workload_type: 'job'
        }
      }
      {
        record: ':node_memory_MemAvailable_bytes:sum'
        expression: 'sum(node_memory_MemAvailable_bytes{job="node"} or (node_memory_Buffers_bytes{job="node"} + node_memory_Cached_bytes{job="node"} + node_memory_MemFree_bytes{job="node"} + node_memory_Slab_bytes{job="node"})) by (cluster)'
      }
      {
        record: 'cluster:node_cpu:ratio_rate5m'
        expression: 'sum(rate(node_cpu_seconds_total{job="node",mode!="idle",mode!="iowait",mode!="steal"}[5m])) by (cluster) /count(sum(node_cpu_seconds_total{job="node"}) by (cluster, instance, cpu)) by (cluster)'
      }
    ]
  }
}

resource prometheusNodeRules 'Microsoft.AlertsManagement/prometheusRuleGroups@2023-03-01' = {
  name: 'NodeRecordingRulesRuleGroup - ${aksCluster.name}'
  location: location
  properties: {
    enabled: true
    description: 'Node Recording Rules RuleGroup'
    clusterName: aksCluster.name
    scopes: [
      prometheusWorkspace.id
      aksCluster.id
    ]
    interval: 'PT1M'
    rules: [
      {
        record: 'instance:node_num_cpu:sum'
        expression: 'count without (cpu, mode) (node_cpu_seconds_total{job="node",mode="idle"})'
      }
      {
        record: 'instance:node_cpu_utilisation:rate5m'
        expression: '1 - avg without (cpu) (sum without (mode) (rate(node_cpu_seconds_total{job="node", mode=~"idle|iowait|steal"}[5m])))'
      }
      {
        record: 'instance:node_load1_per_cpu:ratio'
        expression: '(node_load1{job="node"}/  instance:node_num_cpu:sum{job="node"})'
      }
      {
        record: 'instance:node_memory_utilisation:ratio'
        expression: '1 - ((node_memory_MemAvailable_bytes{job="node"} or (node_memory_Buffers_bytes{job="node"} + node_memory_Cached_bytes{job="node"} + node_memory_MemFree_bytes{job="node"} + node_memory_Slab_bytes{job="node"})) / node_memory_MemTotal_bytes{job="node"})'
      }
      {
        record: 'instance:node_vmstat_pgmajfault:rate5m'
        expression: 'rate(node_vmstat_pgmajfault{job="node"}[5m])'
      }
      {
        record: 'instance_device:node_disk_io_time_seconds:rate5m'
        expression: 'rate(node_disk_io_time_seconds_total{job="node", device!=""}[5m])'
      }
      {
        record: 'instance_device:node_disk_io_time_weighted_seconds:rate5m'
        expression: 'rate(node_disk_io_time_weighted_seconds_total{job="node", device!=""}[5m])'
      }
      {
        record: 'instance:node_network_receive_bytes_excluding_lo:rate5m'
        expression: 'sum without (device) (rate(node_network_receive_bytes_total{job="node", device!="lo"}[5m]))'
      }
      {
        record: 'instance:node_network_transmit_bytes_excluding_lo:rate5m'
        expression: 'sum without (device) (rate(node_network_transmit_bytes_total{job="node", device!="lo"}[5m]))'
      }
      {
        record: 'instance:node_network_receive_drop_excluding_lo:rate5m'
        expression: 'sum without (device) (rate(node_network_receive_drop_total{job="node", device!="lo"}[5m]))'
      }
      {
        record: 'instance:node_network_transmit_drop_excluding_lo:rate5m'
        expression: 'sum without (device) (rate(node_network_transmit_drop_total{job="node", device!="lo"}[5m]))'
      }
    ]
  }
}
