targetScope = 'subscription'

param location string = 'eastus'
param privateDnsZoneName string = 'privatelink.vaultcore.azure.net'
param environment string = 'dev'
param application string = 'csrprocessor'
param tags object  = {}
 
var abbrs = loadJsonContent('../abbreviations.json')
var resourceToken = toLower(uniqueString(subscription().id, environment, location))

resource rg 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: '${abbrs.resourcesResourceGroups}${application}-${environment}-${location}'
  location: location
  tags: tags
}
module vnet 'modules/network.bicep' = {
  name: 'vnet'
  scope: rg
  params: {
    location: location
    tags: tags
    name: '${abbrs.networkVirtualNetworks}${application}-${environment}-${location}'
    privateDnsZoneName: privateDnsZoneName
  }
}

module keyvault 'modules/keyvault.bicep' = {
  name: 'keyvault'
  scope: rg
  params: {
    location: location
    tags: tags
    subnetId: vnet.outputs.subnetPrivateEndpointsId
    privateEndpointName: '${abbrs.privateEndpoints}${application}-${environment}-${location}'
    privateDnsZoneId: vnet.outputs.privateDnsZoneId
    name: 'vault${resourceToken}'
    topicName: '${abbrs.eventGridDomainsTopics}${application}-${environment}-${location}'
  }
}

module functionApp 'modules/function.bicep' = {
  name: 'functionApp'
  scope: rg
  params: {
    functionAppName: '${abbrs.webSitesFunctions}${application}-${environment}-${location}'
    hostingPlanName: '${abbrs.webServerFarms}${application}-${environment}-${location}'
    applicationInsightsName: '${abbrs.eventGridDomainsTopics}${application}-${environment}-${location}'
    functionWorkerRuntime: 'node'
    storageAccountType: 'Standard_LRS'
    systemTopicName: keyvault.outputs.systemTopicName
    location: location
    tags: tags
  }
}

module roleassignment 'modules/roleassignment.bicep' = {
  name: 'roleassignment'
  scope: rg
  params: {
    principalId: functionApp.outputs.principalId
    roleDefinitionId:'a4417e6f-fecd-4de8-b567-7b0420556985'
    keyVaultName: 'vault${resourceToken}'
  }
}

