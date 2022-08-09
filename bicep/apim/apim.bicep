// Parameters
@description('A short name for the workload being deployed')
param workloadName string

@description('The environment for which the deployment is being executed')
@allowed([
  'dev'
  'uat'
  'prod'
])
param deploymentEnvironment string

param location string

var apiManagementServiceName = 'apim-${workloadName}-${deploymentEnvironment}'

var publisherEmail = 'arekbar@microsoft.com'

var publisherName = 'Arek Bar'

param sku string = 'Developer'

param skuCount int = 1

resource apiManagementService 'Microsoft.ApiManagement/service@2021-08-01' = {
  name: apiManagementServiceName
  location: location
  sku: {
    name: sku
    capacity: skuCount
  }
  properties: {
    publisherEmail: publisherEmail
    publisherName: publisherName
  }
}
