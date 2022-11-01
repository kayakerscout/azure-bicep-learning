# Azure Virtual Desktop Custom Configuration Setup
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

Goal is for this example to be deployable via portal interface and cloud shell.
## Usage