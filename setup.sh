#!/bin/bash
rg=devops-build-agent
loc=uksouth
resource_prefix="mfdevops"
vmname="$resource_prefix-agent"
diskname=$vmname-os-disk
publicipname=$vmname-publicip
storagename=$(echo $resource_prefix)scripts
container_name=scripts
uid=AzureAdmin

read -p 'Administrator Password for VM: ' pwd
read -p 'PAT Token for Azure DevOps: ' patToken
read -p 'Azure DevOps Url (e.g. https://dev.azure.com/PROJECTNAME): ' devOpsUrl
agentPool=SelfHost
agentName=$vmname


az group create -n $rg --location $loc

az network public-ip create \
    -n $publicipname \
    -g $rg \
    --sku Standard

#create a storage account
az storage account create \
    -g $rg -n $storagename

#get the keys
storagekey=$(az storage account keys list -g $rg -n $storagename --query "[?keyName=='key1'].value" --output tsv)

#create a blob container
az storage container create \
    --name $container_name \
    --public-access off \
    --account-name $storagename \
    --account-key $storagekey

#upload the files
az storage blob upload \
    -f ./InstallChocolateyComponents.ps1   \
    -c $container_name \
    -n "InstallChocolateyComponents.ps1" \
    --account-name $storagename \
    --account-key $storagekey

# #upload the files
az storage blob upload \
    -f ./InstallAgent.ps1   \
    -c $container_name \
    -n "InstallAgent.ps1" \
    --account-name $storagename \
    --account-key $storagekey

subscriptionid=$(az account list --query "[?name=='mafortun AIRS Subscription'].id" --output tsv)
scope="/subscriptions/$subscriptionid/resourceGroups/$rg/providers/Microsoft.Storage/storageAccounts/$storagename"

az vm create \
    -n $vmname \
    -g $rg \
    --public-ip-address $publicipname \
    --os-disk-name $diskname \
    --admin-username $uid \
    --admin-password $pwd \
    --assign-identity '[system]' \
    --image Win2019Datacenter

objectId=$(az vm identity show --name $vmname -g $rg --query principalId --output tsv) 

az role assignment create --assignee $objectId --role "Storage Blob Data Reader" --scope $scope

containeruri="https://$storagename.blob.core.windows.net/$container_name"
installuri="$containeruri/InstallChocolateyComponents.ps1"

prefix='{"fileUris": ["'
suffix='"] }'
testsettings="$prefix$installuri$suffix"

protected_settings='{"commandToExecute": "powershell.exe -ExecutionPolicy Unrestricted -File InstallChocolateyComponents.ps1 ", "managedIdentity" : {}}'

# Use CustomScript extension to install the chocolatey components.
az vm extension set \
    --publisher Microsoft.Compute \
    --version 1.8 \
    --name CustomScriptExtension \
    --vm-name $vmname  \
    --resource-group $rg \
    --settings "$testsettings" \
    --protected-settings "$protected_settings"

installuri="$containeruri/InstallAgent.ps1"

prefix='{"fileUris": ["'
suffix='"] }'
testsettings="$prefix$installuri$suffix"

s1='{"commandToExecute": "powershell.exe -ExecutionPolicy Unrestricted -File InstallAgent.ps1 '
s2='", "managedIdentity" : {}}'
protected_settings="$s1-patToken $patToken -devopsUrl $devOpsUrl -agentPool $agentPool -agentName $agentName$s2"

echo $protected_settings

# Use CustomScript extension to create a file at the wwwroor.
az vm extension set \
    --publisher Microsoft.Compute \
    --version 1.8 \
    --name CustomScriptExtension \
    --vm-name $vmname  \
    --resource-group $rg \
    --settings "$testsettings" \
    --protected-settings "$protected_settings"



