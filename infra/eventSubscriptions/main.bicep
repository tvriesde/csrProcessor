targetScope = 'resourceGroup'
var abbrs = loadJsonContent('../abbreviations.json')

param location string = 'eastus'
param environment string = 'dev'
param application string = 'csrprocessor'

var systemTopicName = '${abbrs.eventGridDomainsTopics}${application}-${environment}-${location}'
var functionAppName = '${abbrs.webSitesFunctions}${application}-${environment}-${location}'

resource eventSubscription 'Microsoft.EventGrid/systemTopics/eventSubscriptions@2020-10-15-preview' = {
  name: '${systemTopicName}/keyvaulkSubscription'
  properties: {
    destination: {
      endpointType: 'AzureFunction'
      properties:{
        resourceId: resourceId('Microsoft.Web/sites/functions', functionAppName, 'csrProcessor')
      }
    }
  }
}
