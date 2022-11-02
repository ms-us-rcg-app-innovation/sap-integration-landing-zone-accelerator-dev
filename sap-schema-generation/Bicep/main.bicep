
targetScope = 'subscription'

@description('The environment for which the deployment is being executed')
@allowed([
  'dev'
  'uat'
  'prod'
])
param environment string

param uniqueSuffix string = ''

param location string = deployment().location

param adminUsername string

@minLength(12)
@secure()
param adminPassword string

// Variables
var workloadName = 'schemaGen'
var resourceSuffix = '${workloadName}-${environment}'
var SchemaGeneratorResourceGroupName = 'sap-integration-lz-${resourceSuffix}${uniqueSuffix}'

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

//if we can query azure for the externalid of the gateway, would want to pass it in here
//May be a way to query the graph; https://learn.microsoft.com/en-us/azure/governance/resource-graph/samples/starter?tabs=azure-cli
//this query shows that I have a gateway, don't know how to inspect the object; az graph query -q "project id, type, location | where type =~ 'microsoft.web/connectionGateways' | summarize count() by location | top 3 by count_"
module apiConnection 'apiConnections.jsonc' ={
  name: 'apiConnections'
  scope: resourceGroup(IntegrationSchemaGenRG.name)
  params: {

  }
}

module genSchemaLogicApp 'LogicApp.bicep' = {
  name: 'genSchemaLogicApp'
  scope: resourceGroup(IntegrationSchemaGenRG.name)
  params: {
    AzureBlob_connectionString: schemaStorage.outputs.schemaStorageConnectionString
    deploymentEnvironment: environment
    location: location
    workloadName: workloadName
  }
}
