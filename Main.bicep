targetScope = 'managementGroup'

import {ResourceGroupType, AppServiceEnvironmentType,AppServicePlanType,AppServiceType} from 'Types.bicep'

param connectivitySubscriptionId string = 'cf5c1670-9ff1-4ea4-9af3-a650ad3a2a44'
param environmentSubscriptionId string

@allowed( [
  'accept'
  'test'
  'prd'
])
param environment string

@allowed([
  'pub'
  'priv'
])
param publicOrPrivateLz string

param location string

param environmentResourceGroupObject ResourceGroupType

param appServiceEnvironmentObject AppServiceEnvironmentType
param appServicePlanObject AppServicePlanType
param appName string
param appServiceFrontEndObject AppServiceType
param appServiceBackEndObject AppServiceType

resource HubDnsResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' existing =  {
  scope: subscription(connectivitySubscriptionId)
  name: 'rg-networking-hub-dns-prd-weu-001'
}

module EnvironmentResourceGroup 'modules/resources/ResourceGroup.bicep' = {
  scope: subscription(environmentSubscriptionId)
  name: environmentResourceGroupObject.Name
  params: {
    location: location
    name: environmentResourceGroupObject.Name
  }
}

//todo abstract tagobject
module AppResourceGroup 'modules/resources/ResourceGroup.bicep' = {
  scope: subscription(environmentSubscriptionId)
  name: 'rg-${appName}-${environment}-weu-001'
  params: {
    location: location
    name: 'rg-${appName}-${environment}-weu-001'
    tags: {
      ApplicationName:'Navigate'
      ApplicationOwner: 'Nancy.Mazur@eesc.europa.eu'
      Committee: 'EESC'
    }
  }
}

module AppServiceEnvironment 'modules/resources/AppServiceEnvironment.bicep' = {
  scope: resourceGroup(environmentSubscriptionId,EnvironmentResourceGroup.name)
  name: appServiceEnvironmentObject.Name
  params: {
    appServiceEnvironmentName: appServiceEnvironmentObject.Name
    environment: environment
    location: location
    publicOrPrivateLz: publicOrPrivateLz 
  }
}

module PrivateDnsZoneAse 'modules/resources/PrivateDnsZoneAse.bicep' = {
  scope: HubDnsResourceGroup
  name: 'PrivateDnsZone-${appServiceEnvironmentObject.Name}'
  params: {
    appServiceEnvironmentName: appServiceEnvironmentObject.Name
    appServiceEnvironmentInboundIpAddrress: AppServiceEnvironment.outputs.IpV4Address
  }
}

module AppServicePlan 'modules/resources/AppServicePlan.bicep' = {
  scope: resourceGroup(environmentSubscriptionId,EnvironmentResourceGroup.name)
  name: appServicePlanObject.Name
  params: {
    appServiceEnvironmentId: AppServiceEnvironment.outputs.ResourceId
    appServicePlanName: appServicePlanObject.Name
    kind: appServicePlanObject.Kind
    location: location
  }
}

module FrontEnd 'modules/resources/AppService.bicep' = {
  name: '${appName}-frontend-weu-${environment}-01'
  scope: resourceGroup(environmentSubscriptionId,AppResourceGroup.name)
  params: {
    name: '${appName}-frontend-weu-${environment}-01'
    location: location
    appServicePlanId: AppServicePlan.outputs.ResourceId
    appServiceEnvironmentId: AppServiceEnvironment.outputs.ResourceId
    windowsFxVersion: appServiceFrontEndObject.WindowsFxVersion
  }
}

module BackEnd 'modules/resources/AppService.bicep' = {
  name: '${appName}-backend-weu-${environment}-01'
  scope: resourceGroup(environmentSubscriptionId,AppResourceGroup.name)
  params: {
    name: '${appName}-backend-weu-${environment}-01'
    location: location
    appServicePlanId: AppServicePlan.outputs.ResourceId
    appServiceEnvironmentId: AppServiceEnvironment.outputs.ResourceId
    windowsFxVersion: appServiceBackEndObject.WindowsFxVersion
  }
}
