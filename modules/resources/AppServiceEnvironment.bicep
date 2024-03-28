param appServiceEnvironmentName string
param location string
param publicOrPrivateLz string
param environment string

resource targetSubnet 'Microsoft.Network/virtualNetworks/subnets@2023-09-01' existing = {
  name: 'vnet-spoke-${publicOrPrivateLz}-${environment}-weu-001/sn-appenv-${publicOrPrivateLz}-${environment}-weu-001'
  scope: resourceGroup('rg-networking-spoke-${publicOrPrivateLz}-${environment}-weu-001')
}

resource asev3 'Microsoft.Web/hostingEnvironments@2022-03-01' = {
  name: appServiceEnvironmentName
  location: location
  kind: 'ASEV3'
  properties: {
    dedicatedHostCount: 0
    clusterSettings: [
      {
        name: 'DisableTls1.0'
        value: '1'
      }
    ]
    internalLoadBalancingMode: 'Web, Publishing'
    virtualNetwork: {
      id: targetSubnet.id
    }
    zoneRedundant: false

  }
}

resource asev3config 'Microsoft.Web/hostingEnvironments/configurations@2022-03-01' = {
  name: 'networking'
  parent: asev3
  properties: {
    allowNewPrivateEndpointConnections: false
    ftpEnabled: false
    remoteDebugEnabled: true
  }
}

output ResourceId string = asev3.id
output IpV4Address string = asev3config.properties.internalInboundIpAddresses[0]
