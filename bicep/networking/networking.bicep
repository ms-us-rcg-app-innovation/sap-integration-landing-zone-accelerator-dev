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

param IntegrationVnetAddressPrefix string = '192.168.0.0/16'

param GatewaySubnetAddressPrefix string = '192.168.1.0/24'
param APIManagementSubnetAddressPrefix string = '192.168.2.0/24'
param AppSubnetAddressPrefix string = '192.168.3.0/24'



// Variables
var OwnerTagValue = 'IntegrationLandingZoneTeam'


var IntegrationVnetName = 'integration-vnet-${workloadName}-${deploymentEnvironment}-${location}'

var GatewaySubnetName = 'snet-gw-${workloadName}-${deploymentEnvironment}-${location}'
var APIManagementSubnetName = 'snet-apim-${workloadName}-${deploymentEnvironment}-${location}'
var AppSubnetName = 'snet-app-${workloadName}-${deploymentEnvironment}-${location}'


var GatewayNSG = 'nsg-gw-${workloadName}-${deploymentEnvironment}-${location}'
var APIManagementNSG = 'nsg-apim-${workloadName}-${deploymentEnvironment}-${location}'
var AppNSG = 'nsg-app-${workloadName}-${deploymentEnvironment}-${location}'


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



// Outputs

output IntegrationVnetName string = IntegrationVnetName
output IntegrationVnetId string = IntegrationVnet.id

output GatewaySubnetName string = GatewaySubnetName  
output GatewaySubnetId string = '${IntegrationVnet.id}/subnets/${GatewaySubnetName}'  

output APIManagementSubnetName string = APIManagementSubnetName  
output APIManagementSubnetId string = '${IntegrationVnet.id}/subnets/${APIManagementSubnetName}'  

output AppSubnetName string = AppSubnetName  
output AppSubnetId string = '${IntegrationVnet.id}/subnets/${AppSubnetName}' 



