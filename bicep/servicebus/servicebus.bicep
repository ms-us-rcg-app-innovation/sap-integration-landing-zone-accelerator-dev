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

var serviceBusNamespaceName = 'sap-integration-${workloadName}-${deploymentEnvironment}'
var serviceBusQueueName = 'sb-inbound-queue-${workloadName}-${deploymentEnvironment}'

resource serviceBusNamespace 'Microsoft.ServiceBus/namespaces@2017-04-01' = {
  name: serviceBusNamespaceName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {}
}

resource serviceBusQueue 'Microsoft.ServiceBus/namespaces/queues@2017-04-01' = {
  parent: serviceBusNamespace
  name: serviceBusQueueName
  properties: {
    lockDuration: 'PT5M'
    maxSizeInMegabytes: 1024
    requiresDuplicateDetection: false
    requiresSession: false
    defaultMessageTimeToLive: 'P10675199DT2H48M5.4775807S'
    deadLetteringOnMessageExpiration: false
    duplicateDetectionHistoryTimeWindow: 'PT10M'
    maxDeliveryCount: 10
    autoDeleteOnIdle: 'P10675199DT2H48M5.4775807S'
    enablePartitioning: false
    enableExpress: false
  }
}
