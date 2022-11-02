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
## Usage