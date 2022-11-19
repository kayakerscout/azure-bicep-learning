@minLength(3)
@maxLength(10)
@description('base to use in creating storage account name')
param storageAccountNameBase string = 'avdcustom'
param blobContainerName string = 'configuration'
param locationString string = resourceGroup().location
param sasExpire string = dateTimeAdd(utcNow('u'), 'P1D')

param solutionParametersUrl string = 'https://raw.githubusercontent.com/Azure/RDS-Templates/master/wvd-sh/arm-template-customization/solution.parameters.json'
param solutionUrl string = 'https://raw.githubusercontent.com/Azure/RDS-Templates/master/wvd-sh/arm-template-customization/solution.json'
param scriptUrl string = 'https://raw.githubusercontent.com/Azure/RDS-Templates/master/wvd-sh/arm-template-customization/script.ps1'

param deploymentScriptExecutionLocation string = locationString
param azPowerShellVersion string = '8.3'

@maxLength(12)
param vmNamePrefix string
param numberOfVms int = 1
param virtualMachineIndex int = 0

var storageAccountName = toLower('${storageAccountNameBase}${uniqueString(resourceGroup().id)}')
var serviceSasProperties = {
    keyToSign: 'key1'
    signedProtocol: 'https'
    signedResource: 'c'
    signedExpiry: sasExpire
    signedPermission: 'rw'
    canonicalizedResource: '/blob/${storageAccountName}/${blobContainerName}' 
  }

var SasToken = storageAccount.listServiceSAS('2022-05-01',serviceSasProperties).serviceSasToken

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

resource populateStorageDeployScript 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'populateBlobContainer'
  location: deploymentScriptExecutionLocation
  kind: 'AzurePowerShell'
  properties: {
    azPowerShellVersion: azPowerShellVersion
    arguments: '-scriptUrl \\"${scriptUrl}\\" -templateUrl \\"${solutionUrl}\\" -parametersUrl \\"${solutionParametersUrl}\\" -namePrefixVm \\"${vmNamePrefix}\\" -numVms \\"${numberOfVms}\\" -indexVms \\"${virtualMachineIndex}\\"'
    environmentVariables: [
      {
        name: 'SasToken'
        secureValue: SasToken
      }
      {
        name: 'BlobUrl'
        secureValue: storageAccount.properties.primaryEndpoints.blob
      }
      {
        name: 'BlobContainerName'
        secureValue: storageAccount::blobSrv::blobContainer.name
      }
      {
        name: 'DEPLOYMENT_LOCATION'
        value: locationString
      }
    ]
    scriptContent: '''
    param([string] $scriptUrl,[string] $templateUrl,[string] $parametersUrl,[string] $namePrefixVm,[int] $numVms,[int] $indexVms)
    Invoke-WebRequest -UseBasicParsing -Uri $scriptUrl -OutFile "\.\script.ps1"
    Invoke-WebRequest -UseBasicParsing -Uri $templateUrl -OutFile "\.\solution.json"
    Invoke-WebRequest -UseBasicParsing -Uri $parametersUrl -OutFile "\.\solution.parameters.json"
    $stc = New-AzStorageContext -SasToken $env:SasToken -BlobEndpoint $env:BlobUrl
    Set-AzStorageBlobContent -File "\.\script.ps1" -Container $env:BlobContainerName -Context $stc -Force
    Set-AzStorageBlobContent -File "\.\solution.json" -Container $env:BlobContainerName -Context $stc -Force
    $parametersData = (Get-Content -Path "\.\solution.parameters.json" | ConvertFrom-Json)
    $parametersData.parameters.Location.value = $env:DEPLOYMENT_LOCATION
    $parametersData.parameters.NamePrefix.value = $namePrefixVm
    $parametersData.parameters.NumberOfVms.value = $numVms
    $parametersData.parameters.VirtualMachineIndex.value = $indexVms
    $parametersData.parameters.ScriptUri.value = "$($env:BlobUrl)/$($env:BlobContainerName)/script.ps1?$($env:SasToken)"
    $parametersData | ConvertTo-Json | Out-File -Path "\.\solution.parameters.json"
    Set-AzStorageBlobContent -File "\.\solution.parameters.json" -Container $env:BlobContainerName -Context $stc -Force
    '''
    timeout: 'PT30M'
    cleanupPreference: 'OnExpiration'
    retentionInterval: 'PT1H'
  }
} 


output blobEndpoint string = storageAccount.properties.primaryEndpoints.blob
output blogContainer string = storageAccount::blobSrv::blobContainer.name
output blobSas string = SasToken
