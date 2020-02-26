# Scripts for create a configured Azure DevOps Build agent 

The Setup.sh Azure CLI script creates a VM with a public IP (for the purposed of testing only) and then uses chocolatey to install a set of prequisites before finally installing and configuring the Agent to connecto Azure DevOps.

In order to try this yourself you will need your own Azure DevOps account and the ability to generate a Personal Access Token (PAT) from the Account settings. (You will be prompted for these when the script runs)