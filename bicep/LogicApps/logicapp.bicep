//Deploy App Service Workflow Plan, LogicApp Workflow configured with vNet integration and private endpoint
//TODO: Wire up and Deploy OnPrem connector

param workloadName string
param workspaceId string
param appInsightsInstrumentationKey string
param deploymentEnvironment string
// param OnPremDataConnector string

param vNetSubnetId_vNetIntegration string // = '/subscriptions/412b86d9-242b-452c-8273-a4da78837adc/resourceGroups/dscg/providers/Microsoft.Network/virtualNetworks/dscgvnet/subnets/default'
param vNetSubnetId_privateEndpoint string // = '/subscriptions/412b86d9-242b-452c-8273-a4da78837adc/resourceGroups/dscg/providers/Microsoft.Network/virtualNetworks/dscgvnet/subnets/test2'

@description('Location for all resources.')
param location string = resourceGroup().location

var uniquetoken = substring(uniqueString(resourceGroup().id),0,5)
var LogicAppPlan_name = 'LogicAppAppPlan-${workloadName}-${deploymentEnvironment}-${uniquetoken}'
var LogicApp_Name = 'Scenario1-${workloadName}-${deploymentEnvironment}-${uniquetoken}'

resource serverfarms_LogicAppAppPlan 'Microsoft.Web/serverfarms@2021-03-01' = {
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
resource workflowPlanDiagnostics 'microsoft.insights/diagnosticSettings@2017-05-01-preview' = {
  name: 'WorkflowLogs-${workloadName}-${deploymentEnvironment}'
  scope: serverfarms_LogicAppAppPlan 
  properties: {
    workspaceId: workspaceId
    metrics:[
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
  }
}

resource sites_karlrisslogicappdemo_name_resource 'Microsoft.Web/sites@2021-03-01' = {
  name: LogicApp_Name
  location: location
  tags: {
    'hidden-link: /app-insights-resource-id': '/subscriptions/412b86d9-242b-452c-8273-a4da78837adc/resourceGroups/FunctionsLogicAppDemo/providers/Microsoft.Insights/components/karlrisslogicappdemo'
  }
  kind: 'functionapp,workflowapp'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    enabled: true
    hostNameSslStates: [
      {
        name: '${LogicApp_Name}.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Standard'
      }
      {
        name: '${LogicApp_Name}.scm.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Repository'
      }
    ]
    serverFarmId: serverfarms_LogicAppAppPlan.id
    reserved: false
    isXenon: false
    hyperV: false
    siteConfig: {
      numberOfWorkers: 1
      acrUseManagedIdentityCreds: false
      alwaysOn: false
      http20Enabled: false
      functionAppScaleLimit: 0
      minimumElasticInstanceCount: 1
      appSettings:[
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appInsightsInstrumentationKey
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: appInsightsInstrumentationKey
        }
      ]
    }
    scmSiteAlsoStopped: false
    clientAffinityEnabled: false
    clientCertEnabled: false
    clientCertMode: 'Required'
    hostNamesDisabled: false
    customDomainVerificationId: '9F56E18D7E69FCB9F9AE37419489448EB9D7D089287069AB687898D5CD3E29CA'
    containerSize: 1536
    dailyMemoryTimeQuota: 0
    httpsOnly: true
    redundancyMode: 'None'
    storageAccountRequired: false
    keyVaultReferenceIdentity: 'SystemAssigned'
    //virtualNetworkSubnetId: vNetSubnetId_vNetIntegration
  }
}

// resource privateEndpoint 'Microsoft.Network/privateEndpoints@2021-05-01'= {
//   name: '${Prefix}_PE_${uniquetoken}'
//   location: location
//   properties:{
//     subnet:{
//       id: vNetSubnetId_privateEndpoint
//     }
//     privateLinkServiceConnections: [
//       {
//         name: '${Prefix}_PE_${uniquetoken}'
//         properties:{
//           privateLinkServiceId: sites_karlrisslogicappdemo_name_resource.id
//           groupIds:['sites']
//         }
//       }
//     ]
//   }
// }
