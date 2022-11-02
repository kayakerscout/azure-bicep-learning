@minLength(3)
@maxLength(10)
@description('base to use in creating storage account name')
param storageAccountNameBase string = 'avdcustom'
param blobContainerName string = 'configuration'
param locationString string = resourceGroup().location

var storageAccountName = toLower('${storageAccountNameBase}${uniqueString(resourceGroup().id)}')

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: storageAccountName
  location: locationString
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    allowBlobPublicAccess: false
    allowSharedKeyAccess: true
    isNfsV3Enabled: false
    isSftpEnabled: false
    publicNetworkAccess: 'Enabled'
  }
  resource blobSrv 'blobServices@2022-05-01' = {
    name: 'default'
    properties: {
      containerDeleteRetentionPolicy: {
        enabled: false
      }
      deleteRetentionPolicy: {
        enabled: false
      }
      isVersioningEnabled: false
    }
    resource blobContainer 'containers@2022-05-01' = {
      name: blobContainerName
    }
  }
}

output blobUri string = '${storageAccount.properties.primaryEndpoints.blob}${storageAccount::blobSrv::blobContainer.name}'
