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

param appInsightsInstrumentationKey string

var functionAppName = 'functionapp-scenario2win-${workloadName}-${deploymentEnvironment}'
var appServiceName = 'appservice-scenario2win-${workloadName}-${deploymentEnvironment}'

// remove dashes for storage account name
var storageAccountName = 'functa${workloadName}${deploymentEnvironment}'

var appTags = {
  AppID: 'myfunc 2a'
  AppName: 'My Function App 2a'
}

// Storage Account
resource storageAccount 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'  
    }
  kind: 'StorageV2'
  properties: {
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
      keySource: 'Microsoft.Storage'
    }
    accessTier: 'Hot'
  }
  tags: appTags
}

// Blob Services for Storage Account
resource blobServices 'Microsoft.Storage/storageAccounts/blobServices@2019-06-01' = {
  parent: storageAccount

  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
    deleteRetentionPolicy: {
      enabled: true
      days: 7
    }
  }
}

resource appService 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: appServiceName
  // properties:{
  //   reserved: true
  // }
  location: location
  kind: 'windows'
  sku: {
    name: 'S1'
  }
}

// Function App
resource functionApp 'Microsoft.Web/sites@2020-06-01' = {
  name: functionAppName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  kind: 'functionapp'
  properties: {    
    httpsOnly: true
    serverFarmId: appService.id
    clientAffinityEnabled: true
    siteConfig: {
      pythonVersion: '3.8'
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(storageAccount.id, storageAccount.apiVersion).keys[0].value}'
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~3'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'python'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: functionAppName
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(storageAccount.id, storageAccount.apiVersion).keys[0].value}'
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appInsightsInstrumentationKey
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value:'InstrumentationKey=${appInsightsInstrumentationKey}'
        }
      ]
    }
  }


}

// Function App Binding
resource functionAppBinding 'Microsoft.Web/sites/hostNameBindings@2020-06-01' = {
  parent: functionApp

  name: '${functionApp.name}.azurewebsites.net'
  properties: {
    siteName: functionApp.name
    hostNameType: 'Verified'
  }
}
