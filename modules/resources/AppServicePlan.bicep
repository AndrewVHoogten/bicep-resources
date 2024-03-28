param appServicePlanName string

param location string

param sku string = 'IsolatedV2'
param skuCode string = 'I1V2'

param kind string

param appServiceEnvironmentId string

resource AppServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: appServicePlanName
  location: location
  sku: {
    tier: sku
    name: skuCode
  }
  kind: kind
  properties: {
    hostingEnvironmentProfile: {
      id: appServiceEnvironmentId
    }
    reserved: true
  }
}

output ResourceName string = AppServicePlan.name
output ResourceId string = AppServicePlan.id
