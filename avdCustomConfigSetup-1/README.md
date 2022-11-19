# Azure Virtual Desktop Custom Configuration Setup
## Notes
### Note 1
Per [Azure Virtual Desktop Custom Configuration Breaking Change (https://techcommunity.microsoft.com/t5/azure-virtual-desktop/azure-virtual-desktop-custom-configuration-breaking-change/m-p/3568069)](https://techcommunity.microsoft.com/t5/azure-virtual-desktop/azure-virtual-desktop-custom-configuration-breaking-change/m-p/3568069)
the template parameter URL options for ARM template file
and ARM template parameter file will be removed. This will
replaced with a custom configuration PowerShell script.

Planning to continue working on this for the Bicep learning
opportunity.

### Note 2
This deployment template places a storage SAS token into
deployment output to allow for use in  deployment.
Confirm that is compatible with your security and
deployment practices before using.

## Summary
Automated setup of a storage account and blog storage to 
hold the files required for the "Azure Virtual Desktop -
Custom Configuration" available within the Azure Portal 
for adding Virtual Machines to an AVD host post and
described at
[https://github.com/Azure/RDS-Templates/tree/master/wvd-sh/arm-template-customization](https://github.com/Azure/RDS-Templates/tree/master/wvd-sh/arm-template-customization).
Scripted deployment will create the storage account and 
populate it with the required files from the example repo.
Files within the storage location can then be modified as
needed/desired.

Goal is for this example to be deployable via portal
interface with cloud shell usage if required.

## Usage
### Build ARM template from Bicep file
(example using the [bicep powershell module](https://www.powershellgallery.com/packages/Bicep/2.3.3))
Build-Bicep -Path .\avdConfig-setup.bicep
### Review parameters
Review the parameters, particularly numberOfVms,
virtualMachineIndex and vmNamePrefix. These are explained
further in the
[arm-template-customization](https://github.com/Azure/RDS-Templates/tree/master/wvd-sh/arm-template-customization)
README. The defaults parameter values for numberOfVms and
virtualMachineIndex assume deployment of a single VM at
index 0. No default is set for vmNamePrefix, you will be
prompted for this. 
### Deploy
#### Via Azure Portal
- Locate "Deploy a Custom Template" within the Azure
portal.
- Select "Build your own template in the
editor".
- Load file and select the ARM template.
- Once loaded, select Save.
- Review deployment details, particularly
numberOfVms and virtualMachineIndex.
- Populate values for Resource Group and Vm Name Prefix.
- Select "Review + create".
- Select Create.
#### or Via Azure Az Powershell Module 
New-AzResourceGroupDeployment -ResourceGroupName 'RESOURCE_GROUP_NAME' -TemplateFile .\avdConfig-setup.json -Name "avdCustomDeploy-$(Get-Date -format "yyyyMMdd'T'HHmmss'Z'")"

## Additional Learning Resources
- [Azure Deployment Scripts - Run any action you want as part of a template!](https://youtu.be/c4hTBTWyA_w) - [John Savill's YouTube Channel](https://www.youtube.com/@NTFAQGuy)
- [Generate SAS Tokens in ARM Templates](https://samcogan.com/generate-sas-tokens-in-arm-teamplates/) - Sam Cogan
- [Bicep Documentation, Resource functions for Bicep, list*](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/bicep-functions-resource#list) - Microsoft Learn
- [Azure REST API reference, Storage Accounts - List Account SAS](https://learn.microsoft.com/en-us/rest/api/storagerp/storage-accounts/list-account-sas?tabs=HTTP) - Microsoft Learn
- [Bicep Documentation, Date functions for Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/bicep-functions-date) - Microsoft Learn
