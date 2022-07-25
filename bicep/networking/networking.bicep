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

param IntegrationVnetAddressPrefix string = '172.0.0.0/16'

param GatewaySubnetAddressPrefix string = '172.0.1.0/24'
param APIManagementSubnetAddressPrefix string = '172.0.2.0/24'
param AppSubnetAddressPrefix string = '172.0.3.0/24'
param DataSourceSubnetAddressPrefix string = '172.0.3.0/24'


// Variables
var OwnerTagValue = 'IntegrationLandingZoneTeam'


var IntegrationVnetName = 'integration-vnet-${workloadName}-${deploymentEnvironment}-${location}'

var GatewaySubnetName = 'snet-gw-${workloadName}-${deploymentEnvironment}-${location}'
var APIManagementSubnetName = 'snet-apim-${workloadName}-${deploymentEnvironment}-${location}'
var AppSubnetName = 'snet-app-${workloadName}-${deploymentEnvironment}-${location}'
var DataSourceSubnetName = 'snet-datasrc-${workloadName}-${deploymentEnvironment}-${location}'

var GatewayNSG = 'nsg-gw-${workloadName}-${deploymentEnvironment}-${location}'
var APIManagementNSG = 'nsg-apim-${workloadName}-${deploymentEnvironment}-${location}'
var AppNSG = 'nsg-app-${workloadName}-${deploymentEnvironment}-${location}'
var DataSourceNSG = 'nsg-datasrc-${workloadName}-${deploymentEnvironment}-${location}'

// Resources - VNet - SubNets
resource IntegrationVnet 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: IntegrationVnetName
  location: location
  tags: {
    Owner: OwnerTagValue
    // CostCenter: costCenter
  }
  properties: {
    addressSpace: {
      addressPrefixes: [
        IntegrationVnetAddressPrefix
      ]
    }
    enableVmProtection: false
    enableDdosProtection: false
    subnets: [
      {
        name: GatewaySubnetName
        properties: {
          addressPrefix: GatewaySubnetAddressPrefix
          networkSecurityGroup: {
            id: GatewayNSG1.id
          }
        }
      }
      {
        name: APIManagementSubnetName
        properties: {
          addressPrefix: APIManagementSubnetAddressPrefix
          networkSecurityGroup: {
            id: APIManagementNSG1.id
          }
        }
      }
      {
        name: AppSubnetName
        properties: {
          addressPrefix: AppSubnetAddressPrefix
          networkSecurityGroup: {
            id: AppNSG1.id
          }
        }
      }
      {
        name: DataSourceSubnetName
        properties: {
          addressPrefix: DataSourceSubnetAddressPrefix
          networkSecurityGroup: {
            id: DataSourceNSG1.id
          }
        }
      }
    ]
  }
}

resource GatewayNSG1 'Microsoft.Network/networkSecurityGroups@2020-06-01' = {
  name: GatewayNSG
  location: location
  properties: {
    securityRules: [
      
    ]
  }
}

resource APIManagementNSG1 'Microsoft.Network/networkSecurityGroups@2020-06-01' = {
  name: APIManagementNSG
  location: location
  properties: {
    securityRules: [

    ]
  }
}

resource AppNSG1 'Microsoft.Network/networkSecurityGroups@2020-06-01' = {
  name: AppNSG
  location: location
  properties: {
    securityRules: [
      
    ]
  }
}

resource DataSourceNSG1 'Microsoft.Network/networkSecurityGroups@2020-06-01' = {
  name: DataSourceNSG
  location: location
  properties: {
    securityRules: [
      {
        name: 'SSH'
        properties: {
          priority: 2000
          direction: 'Inbound'
          sourceAddressPrefix: '64.53.253.86/32'
          protocol: 'Tcp'
          destinationPortRange: '*'
          access: 'Allow'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

// Outputs

output IntegrationVnetName string = IntegrationVnetName
output IntegrationVnetId string = IntegrationVnet.id

output GatewaySubnetName string = GatewaySubnetName  
output GatewaySubnetId string = '${IntegrationVnet.id}/subnets/${GatewaySubnetName}'  

output APIManagementSubnetName string = APIManagementSubnetName  
output APIManagementSubnetId string = '${IntegrationVnet.id}/subnets/${APIManagementSubnetName}'  

output AppSubnetName string = AppSubnetName  
output AppSubnetId string = '${IntegrationVnet.id}/subnets/${AppSubnetName}'  


