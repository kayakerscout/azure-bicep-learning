@description('Azure location name to use for deployment, default is resource group location')
param loc string = resourceGroup().location
@description('Name of the vault')
param vaultName string
@description('AzureAD UserObjectId to give access to the created keyvault')
param deploymentUserObjId string
@description('AzureAD Tenant ID for the supplied userObjectId')
param deploymentUserObjTenant string

resource deploymentVault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: vaultName
  location: loc
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    accessPolicies: [
      {
        objectId: deploymentUserObjId
        permissions: {
          certificates: []
          keys: []
          secrets: ['all']
          storage: []
        }
        tenantId: deploymentUserObjTenant
      }
    ]
    enabledForDeployment: true
    enabledForDiskEncryption: false
    enabledForTemplateDeployment: true
    publicNetworkAccess: 'disabled'
  }
}
output deployedVaultName string = deploymentVault.name
