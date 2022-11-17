@minLength(3)
@maxLength(10)
@description('base to use in creating storage account name')
param storageAccountNameBase string = 'avdcustom'
param blobContainerName string = 'configuration'
param locationString string = resourceGroup().location
param sasExpire string = dateTimeAdd(utcNow('u'), 'P7D')

var storageAccountName = toLower('${storageAccountNameBase}${uniqueString(resourceGroup().id)}')
var serviceSasProperties = {
    keyToSign: 'key1'
    signedProtocol: 'https'
    signedResource: 'c'
    signedExpiry: sasExpire
    signedPermission: 'rw'
    canonicalizedResource: '/blob/${storageAccountName}/${blobContainerName}' 
  }


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

output blobEndpoint string = storageAccount.properties.primaryEndpoints.blob
output blogContainer string = storageAccount::blobSrv::blobContainer.name
output blobSas string = storageAccount.listServiceSAS('2022-05-01',serviceSasProperties).serviceSasToken
