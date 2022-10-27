@description('The name of an existing keyvault to populate with the deployment secrets')
param existingKeyvault string
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


resource kvLocalSecret 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  name: '${existingKeyvault}/${localAdminUser}'
  properties: {
    value: localAdminPass
    attributes: {
      enabled: true
    }
  }
}
resource kvDomainSecret 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  name: '${existingKeyvault}/${domainJoinUser}'
  properties: {
    value: domainJoinPass
    attributes: {
      enabled: true
    }
  }
}
