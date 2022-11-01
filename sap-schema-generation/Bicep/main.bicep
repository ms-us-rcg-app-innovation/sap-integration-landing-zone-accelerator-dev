
targetScope = 'subscription'

@description('The environment for which the deployment is being executed')
@allowed([
  'dev'
  'uat'
  'prod'
])
param environment string

param location string = deployment().location

param adminUsername string

@minLength(12)
@secure()
param adminPassword string

// Variables
var workloadName = 'schemaGen'
var resourceSuffix = '${workloadName}-${environment}' //-${location}-001' this seems overkill
var SchemaGeneratorResourceGroupName = 'sap-integration-lz-${resourceSuffix}'

resource IntegrationSchemaGenRG 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: SchemaGeneratorResourceGroupName
  location: location
}

module onPremDataGateway 'onPremDataGateway.bicep' = {
  name: 'OnPremDataGateway'
  scope:resourceGroup(IntegrationSchemaGenRG.name)
  params: {
    adminUsername: adminUsername
    adminPassword: adminPassword
    location: location
  }
}

module schemaStorage 'SchemaStorage.bicep' = {
  name: 'schemaStorage'
  scope: resourceGroup(IntegrationSchemaGenRG.name)
  params:{
    deploymentEnvironment: environment
    location: location
    workloadName: workloadName
  }
}

module genSchemaLogicApp 'LogicApp.bicep' = {
  name: 'genSchemaLogicApp'
  scope: resourceGroup(IntegrationSchemaGenRG.name)
  params: {
    deploymentEnvironment: environment
    location: location
    workloadName: workloadName
  }
}
