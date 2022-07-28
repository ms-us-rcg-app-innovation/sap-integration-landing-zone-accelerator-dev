targetScope='subscription'

// Parameters
@description('A short name for the workload being deployed alphanumberic only')
@maxLength(8)
param workloadName string

@description('The environment for which the deployment is being executed')
@allowed([
  'dev'
  'uat'
  'prod'
])

param environment string

param location string = deployment().location

// Variables
var resourceSuffix = '${workloadName}-${environment}-${location}-001'
var IntegrationResourceGroupName = 'rg-integration-${resourceSuffix}'

resource IntegrationRG 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: IntegrationResourceGroupName
  location: location
}

module networking './networking/networking.bicep' = {
  name: 'integration-vnet'
  scope: resourceGroup(IntegrationRG.name)
  params: {
    workloadName: workloadName
    deploymentEnvironment: environment
    location: location
  }
}

module logging './logging/logging.bicep' = {
  name: 'log-ws-app-ins'
  scope: resourceGroup(IntegrationRG.name)
  params: {
    workloadName: workloadName
    deploymentEnvironment: environment
    location: location
  }
}

module keyvault './keyvault/keyvault.bicep' = {
  name: 'keyvault'
  scope: resourceGroup(IntegrationRG.name)
  params: {
    workloadName: workloadName
    deploymentEnvironment: environment
    location: location
  }
}


