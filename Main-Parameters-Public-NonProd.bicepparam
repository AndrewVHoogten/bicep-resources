using 'Main.bicep'

//environmentParameters
param location = 'westeurope'
param publicOrPrivateLz = 'pub'
param environment = 'test'
param environmentSubscriptionId = '3c59e20f-1178-4405-a44b-3c093dcf529c'

param environmentResourceGroupObject = {
  Name: 'rg-sharedappinfra-pub-nonprod-weu-001'
}

param appServiceEnvironmentObject = {
  Name: 'ase-pub-nonprod-weu-001'
}

param appServicePlanObject = {
  Kind: 'Windows'
  Name: 'asp-pub-test-weu-windows-001'
  Sku: 'IsolatedV2'
  SkuCode: 'I1V2'
}

param appName = 'navigate'

param appServiceFrontEndObject = {
  WindowsFxVersion: 'node|18-lts'
}

param appServiceBackEndObject = {
  WindowsFxVersion: 'dotnetcore|7.0'
}
