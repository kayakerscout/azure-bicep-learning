@description('AzureAD UserObjectId to give access to the created keyvault')
param deploymentUserObjId string
@description('AzureAD Tenant ID for the supplied userObjectId')
param deploymentUserObjTenant string
@description('Name of the vault, without prefix or postfix')
@minLength(1)
@maxLength(7)
param vaultBaseName string
@description('Name to give the local administrator account during deployment')
param localAdminUser string
@description('Password to set for the local admin user during deployment')
@secure()
param localAdminPass string
@description('Name of a domain account to use to join the deployed system to an AD domain')
param domainJoinUser string
@description('Password for the supplied domain user for domain join activities')
@secure()
param domainJoinPass string


param loc string = resourceGroup().location

module kvcreate 'keyvault-create.bicep' = {
  name: 'keyvaultCreate'
  params: {
    loc: loc
    deploymentUserObjId: deploymentUserObjId
    deploymentUserObjTenant: deploymentUserObjTenant
    vaultName: 'kv-${vaultBaseName}-${uniqueString(resourceGroup().id)}'
  }
}

module kvPopulate 'keyvault-populate.bicep' = {
  name: 'keyvaultPopulate'
  params: {
    domainJoinPass: domainJoinPass
    domainJoinUser: domainJoinUser
    existingKeyvault: kvcreate.outputs.deployedVaultName
    localAdminPass: localAdminPass
    localAdminUser: localAdminUser
  }
}
