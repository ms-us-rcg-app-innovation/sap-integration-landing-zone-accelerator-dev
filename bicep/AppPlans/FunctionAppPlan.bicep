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
var functionAppPlan_name = '${workloadName}-FunctionPlan-${deploymentEnvironment}-${uniquetoken}'
var FunctionApp_Storage_Name = toLower('${workloadName}funcstor${deploymentEnvironment}${uniquetoken}')

resource storageAccounts_WorkflowPlanStorage 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: FunctionApp_Storage_Name
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
var functionPlanStoragePrimaryKey = listKeys(storageAccounts_WorkflowPlanStorage.id, storageAccounts_WorkflowPlanStorage.apiVersion).keys[0].value
var functionPlanStorageprimaryConnStr = 'DefaultEndpointsProtocol=https;AccountName=${FunctionApp_Storage_Name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${functionPlanStoragePrimaryKey}'


//Need to deploy the app plan here


//var workflowPlanResourceId = workflowplan_serverfarms.id

output functionPlanStoragePrimaryKey string = functionPlanStoragePrimaryKey
output functionPlanStorageprimaryConnStr string = functionPlanStorageprimaryConnStr
//output workflowPlanResourceId string = workflowPlanResourceId
