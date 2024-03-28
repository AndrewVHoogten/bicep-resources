targetScope = 'resourceGroup'

param appServiceEnvironmentName string
param appServiceEnvironmentInboundIpAddrress string

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: '${appServiceEnvironmentName}.appserviceenvironment.net'
  location: 'global'
  properties: {}
}

resource vnetlink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: privateDnsZone
  name: 'to-Hub'
  location: 'global'
  properties: {
    virtualNetwork: {
      #disable-next-line use-resource-id-functions
      id: '/subscriptions/cf5c1670-9ff1-4ea4-9af3-a650ad3a2a44/resourceGroups/rg-networking-hub-prd-weu-001/providers/Microsoft.Network/virtualNetworks/vnet-hub-prd-weu-001'
    }
    registrationEnabled: false
  }
}

resource webrecord 'Microsoft.Network/privateDnsZones/A@2020-06-01' = {
  parent: privateDnsZone
  name: '*'
  properties: {
    ttl: 3600
    aRecords: [
      {
        ipv4Address: appServiceEnvironmentInboundIpAddrress
      }
    ]
  }
}
