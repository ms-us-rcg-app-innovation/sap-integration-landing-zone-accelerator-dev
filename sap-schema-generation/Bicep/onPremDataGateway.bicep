// See this link; https://stackoverflow.com/questions/45797141/deploy-on-premise-data-gateway-on-azure-vm-via-arm
// See this link; https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deployment-script-bicep
// looks like we can install the OPDG and also script the client install 
// needs research

param adminUsername string

@minLength(12)
@secure()
param adminPassword string

var location = resourceGroup().location
var OSVersion = 'win11-21h2-pro'
var vmName = 'opdg-vm'
var addressPrefix = '10.0.0.0/16'
var nicName = 'opdgVMNic'
var subnetName = 'Subnet'
var subnetPrefix = '10.0.0.0/24'
var vnetName = 'opdgVNET'
var networkSecurityGroupName = 'default-NSG'
var vmSize =  'Standard_D2s_v5'
var azureBastionSubnetAddressPrefix = '10.0.1.0/26'

resource securityGroup 'Microsoft.Network/networkSecurityGroups@2021-02-01' = {
  name: networkSecurityGroupName
  location: location
  properties: {
    securityRules: []
  }
}

resource vn 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: subnetPrefix
          networkSecurityGroup: {
            id: securityGroup.id
          }
        }
      }
      {
        name: 'AzureBastionSubnet'
        properties:{
          addressPrefix: azureBastionSubnetAddressPrefix
        }
      }
    ]
  }
}

// resource bastion_subnet 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
//   name: '${vnetName}/AzureBastionSubnet'
//   dependsOn:[vn]
//   properties: {
//       addressPrefix: azureBastionSubnetAddressPrefix
//   }
// }

resource bastion_public_ip 'Microsoft.Network/publicIPAddresses@2020-11-01' = {
  name: 'opdg-bastion-pip'
  location: location
  sku: {
      name: 'Standard'
  }
  properties: {
      publicIPAddressVersion: 'IPv4'
      publicIPAllocationMethod: 'Static'
  }
}

resource nic 'Microsoft.Network/networkInterfaces@2021-02-01' = {
  name: nicName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          // publicIPAddress: {
          //   id: pip.id  //remove once bastion is up and running
          // }
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', vn.name, subnetName)
          }
        }
      }
    ]
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'microsoftwindowsdesktop'
        offer: 'windows-11'
        sku: OSVersion
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
      }
      dataDisks: [
        {
          diskSizeGB: 1023
          lun: 0
          createOption: 'Empty'
        }
      ]
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
  }
}

resource bastion 'Microsoft.Network/bastionHosts@2020-11-01' = {
  name: 'opdg-bastion'
  location: location
  sku: {
      name: 'Basic'
  }
  properties: {
      ipConfigurations: [
          {
              name: 'IpConf'
              properties: {
                  privateIPAllocationMethod: 'Dynamic'
                  publicIPAddress: {
                      id: bastion_public_ip.id
                  }
                  subnet: {
                      //id: bastion_subnet.id
                      id: resourceId('Microsoft.Network/virtualNetworks/subnets', vn.name, 'AzureBastionSubnet')
                  }
              }
          }
      ]
  }
}

