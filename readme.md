# Scripts for creating a configured Azure DevOps Build agent 

The Setup.sh Azure CLI script creates a VM with a public IP (for the purposed of testing only) and then uses chocolatey to install a set of prequisites before finally installing and configuring the Agent to connect to Azure DevOps.

In order to try this yourself you will need your own Azure DevOps account and the ability to generate a Personal Access Token (PAT) from the Account settings. (You will be prompted for these when the script runs)

(And yes I get the irony of hosting the Azure DevOps Build agent script on github, but everything plays nicely together!)

Things I am doing differently in this project that I haven't done before

- Using Managed Identity on the VM to access the build scripts with minimal-ish (storage wide) permissions
- Use Chocolatey to bulk install software
- Pass parameters properly to my powershell script in a custom script extension  

# Terraform scripts

As an alternative to the CLI script, in the /env folder are a set of terraform scripts to build a windows VM build agent with Visual Studio installed.

This has some differences from the CLI script.
- I am installing the same VS2019 components the microsoft hosted build agents use.
- It explicitly creates a vnet (not really needed and may remove in the future)
- I am explicity specifying the VM size

The project can be deployed using `terraform init` followed by `terraform apply -auto-approve`.  You will be prompted for the dev ops details same as the CLI script (or your can create a tfvars file/use the command line flags to pass the required parameters in).

The scripts it uses are based on the microsoft hosted build agent scripts, [found here](https://github.com/actions/virtual-environments/tree/master/images/win/scripts/Installers/Windows2019) 