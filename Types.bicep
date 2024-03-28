@export()
type ResourceGroupType = {
  Name: string
  TagObject: object?
}

@export()
type AppServiceEnvironmentType = {
  Name: string
}

@export()
type AppServicePlanType = {
  Name: string
  Sku: ('IsolatedV2')
  SkuCode: ('I1V2')
  Kind: ('Linux' | 'Windows')
}

@export()
type AppServiceType = {
  Name: string?
  WindowsFxVersion: string
}
