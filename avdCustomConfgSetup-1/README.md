# Azure Virtual Desktop Custom Configuration Setup
## Note
Per [Azure Virtual Desktop Custom Configuration Breaking Change (https://techcommunity.microsoft.com/t5/azure-virtual-desktop/azure-virtual-desktop-custom-configuration-breaking-change/m-p/3568069)](https://techcommunity.microsoft.com/t5/azure-virtual-desktop/azure-virtual-desktop-custom-configuration-breaking-change/m-p/3568069)
the template parameter URL options for ARM template file
and ARM template parameter file will be removed. This will
replaced with a custom configuration PowerShell script.

Will continue to develop this for the Bicep learning
opportunity.

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

## Additional Resources
- [Azure Deployment Scripts - Run any action you want as part of a template!](https://youtu.be/c4hTBTWyA_w) - [John Savill's YouTube Channel](https://www.youtube.com/@NTFAQGuy)
- [Generate SAS Tokens in ARM Templates](https://samcogan.com/generate-sas-tokens-in-arm-teamplates/) - Sam Cogan
- [Bicep Documentation, Resource functions for Bicep, list*](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/bicep-functions-resource#list) - Microsoft Learn
- [Azure REST API reference, Storage Accounts - List Account SAS](https://learn.microsoft.com/en-us/rest/api/storagerp/storage-accounts/list-account-sas?tabs=HTTP) - Microsoft Learn
- [Bicep Documentation, Date functions for Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/bicep-functions-date) - Microsoft Learn

## Usage