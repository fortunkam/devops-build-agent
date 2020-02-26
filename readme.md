# Scripts for create a configured Azure DevOps Build agent 

The Setup.sh Azure CLI script creates a VM with a public IP (for the purposed of testing only) and then uses chocolatey to install a set of prequisites before finally installing and configuring the Agent to connecto Azure DevOps.

In order to try this yourself you will need your own Azure DevOps account and the ability to generate a Personal Access Token (PAT) from the Account settings. (You will be prompted for these when the script runs)

(And yes I get the irony of hosting the Azure DevOps Build agent script on github, but everything plays nicely together!)

Things I am doing differently in this project that I haven't done before

- Using Managed Identity on the VM to access the build scripts with minimal-ish (storage wide) permissions
- Use Chocolatey to bulk install software
- Pass parameters properly to my powershell script in a custom script extension  