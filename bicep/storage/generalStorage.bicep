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

param workloadName string = 'genstorage'

var uniquetoken = substring(uniqueString(resourceGroup().id),0,5)
var Storage_Name = toLower('${workloadName}${deploymentEnvironment}${uniquetoken}')

output storageName string = Storage_Name

resource storageAccounts_Storage 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: Storage_Name
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

// No need for a container used by multiple scenarios just yet
//
// resource Container 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-05-01' = {
//   name: '${storageAccounts_Storage.name}/default/schemas'
//   properties: {
//     publicAccess: 'None'
//     metadata: {}
//   }
// }

//there is no connection string property so it has to be generated
var storagePrimaryKey = listKeys(storageAccounts_Storage.id, storageAccounts_Storage.apiVersion).keys[0].value
var storageprimaryConnStr = 'DefaultEndpointsProtocol=https;AccountName=${Storage_Name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storagePrimaryKey}'

output GeneralStoragePrimaryKey string = storagePrimaryKey
output GeneralStorageConnectionString string = storageprimaryConnStr
