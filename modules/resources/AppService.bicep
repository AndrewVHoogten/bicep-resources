param name string
param location string
param appServicePlanId string
param appServiceEnvironmentId string
param windowsFxVersion string

resource AppService 'Microsoft.Web/sites@2022-09-01' = {
  name: name
  location: location
  properties: {
    serverFarmId: appServicePlanId
    siteConfig: {
      publicNetworkAccess: 'Enabled'
      //linuxFxVersion: 'node|14-lts'
      windowsFxVersion: windowsFxVersion
    }
    hostingEnvironmentProfile: {
      id: appServiceEnvironmentId
    }
  }
}
