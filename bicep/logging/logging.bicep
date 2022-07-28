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

var logAnalyticsNamespaceName = 'log-analytics-${workloadName}-${deploymentEnvironment}'
var appInsightsName = 'app-insights-${workloadName}-${deploymentEnvironment}'
var logStorageAccountName = 'logstorage${workloadName}${deploymentEnvironment}'

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-08-01' = {
  name: logAnalyticsNamespaceName
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 120
    features: {
      searchVersion: 1
      legacy: 0
      enableLogAccessUsingOnlyResourcePermissions: true
    }
  }
}

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: location
  kind: 'string'
  tags: {
    displayName: 'AppInsight'
  }
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: '/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup().name}/providers/Microsoft.OperationalInsights/workspaces/${logAnalyticsNamespaceName}'
  }
}

// storage account
resource storageAccount 'Microsoft.Storage/storageAccounts@2020-08-01-preview' = {
  name: logStorageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    allowSharedKeyAccess: true
    largeFileSharesState: 'Disabled'
    networkAcls: {
      resourceAccessRules: []
      bypass: 'AzureServices'
      virtualNetworkRules: []
      ipRules: []
      defaultAction: 'Deny'
    }
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
}

output LogAnalyticsWorkspaceName string = logAnalyticsNamespaceName
output LogAnalyticsWorkspaceId string = logAnalyticsWorkspace.id

output appInsightsName string = appInsightsName
output appInsightsId string = appInsights.id

output storageAccountName string = logStorageAccountName
output storageAccountId string = storageAccount.id
