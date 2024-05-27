@description('The name prefix of the managed cluster resource.')
param prefix string = uniqueString(resourceGroup().id)

@description('The location of the managed cluster resource.')
param location string = resourceGroup().location

var clusterName = '${prefix}Aks'

resource aks 'Microsoft.ContainerService/managedClusters@2024-03-02-preview' = {
  name: clusterName
  location: location  
  sku: {
		name: 'Automatic'
  		tier: 'Standard'
  }
  properties: {
    agentPoolProfiles: [
      {
        name: 'systempool'
        count: 3
        vmSize: 'Standard_DS4_v2'
        osType: 'Linux'
        mode: 'System'
      }
    ]
  }
  identity: {
    type: 'SystemAssigned'
  }
}
