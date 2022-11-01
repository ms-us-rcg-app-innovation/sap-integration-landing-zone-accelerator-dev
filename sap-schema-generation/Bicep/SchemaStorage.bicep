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

param workloadName string = 'schemaGen'

var uniquetoken = substring(uniqueString(resourceGroup().id),0,5)
var schema_Storage_Name = toLower('${workloadName}${deploymentEnvironment}${uniquetoken}')

output storageName string = schema_Storage_Name

resource storageAccounts_SchemaStorage 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: schema_Storage_Name
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

resource schemaContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-05-01' = {
  name: '${storageAccounts_SchemaStorage.name}/default/schemastorage'
  properties: {
    publicAccess: 'None'
    metadata: {}
  }
}
