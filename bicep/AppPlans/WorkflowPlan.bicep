@description('The environment for which the deployment is being executed')
@allowed([
  'dev'
  'uat'
  'prod'
])
param deploymentEnvironment string
// param OnPremDataConnector string

@description('Location for all resources.')
param location string = resourceGroup().location

param workloadName string = 'main'

var uniquetoken = substring(uniqueString(resourceGroup().id),0,5)
var LogicAppPlan_name = '${workloadName}-WorkflowPlan-${deploymentEnvironment}-${uniquetoken}'
var LogicApp_Storage_Name = toLower('${workloadName}wfstor${deploymentEnvironment}${uniquetoken}')

resource storageAccounts_WorkflowPlanStorage 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: LogicApp_Storage_Name
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'Storage'
  properties: {
    minimumTlsVersion:'TLS1_2'
    allowBlobPublicAccess: false
    supportsHttpsTrafficOnly: true
    encryption: {
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource:'Microsoft.Storage'
    }
  }
}
//Build the storage account connection string
var workflowPlanStoragePrimaryKey = listKeys(storageAccounts_WorkflowPlanStorage.id, storageAccounts_WorkflowPlanStorage.apiVersion).keys[0].value
var workflowPlanStorageprimaryConnStr = 'DefaultEndpointsProtocol=https;AccountName=${LogicApp_Storage_Name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${workflowPlanStoragePrimaryKey}'


resource workflowplan_serverfarms 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: LogicAppPlan_name
  location: location
  sku: {
    name: 'WS1'
    tier: 'WorkflowStandard'
    size: 'WS1'
    family: 'WS'
    capacity: 1
  }
  kind: 'elastic'
  properties: {
    perSiteScaling: false
    elasticScaleEnabled: true
    maximumElasticWorkerCount: 20
    isSpot: false
    reserved: false
    isXenon: false
    hyperV: false
    targetWorkerCount: 0
    targetWorkerSizeId: 0
    zoneRedundant: false
  }
}

var workflowPlanResourceId = workflowplan_serverfarms.id

output workflowPlanStoragePrimaryKey string = workflowPlanStoragePrimaryKey
output workflowPlanStorageprimaryConnStr string = workflowPlanStorageprimaryConnStr
output workflowPlanResourceId string = workflowPlanResourceId
