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

param location string = resourceGroup().location

var uniquetoken = substring(uniqueString(resourceGroup().id),0,5)
var testHarnessAccountName = 'testharness${workloadName}${deploymentEnvironment}${uniquetoken}'

// Create storages
resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: testHarnessAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

// Create container
resource idoccontainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' =  {
  name: '${storageAccount.name}/default/idoc'
  properties: {
    publicAccess: 'None'
    metadata: {}
  }
}
resource soapcontainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' =  {
  name: '${storageAccount.name}/default/idoc'
  properties: {
    publicAccess: 'None'
    metadata: {}
  }
}
resource errorcontainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' =  {
  name: '${storageAccount.name}/default/idoc'
  properties: {
    publicAccess: 'None'
    metadata: {}
  }
}

output storageAccountName string = testHarnessAccountName
output storageAccountId string = storageAccount.id
