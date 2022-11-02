<!-- ABOUT THE PROJECT -->
# Powershell Deployment
Executing the deployment of bicep defined resources will require azure CLI to be installed
  + [Installing AZ CLI for Powershell](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)

```powershell
# Set Azure Region 
# To generate a list of available regions you can execute: az account list-locations -o table
$LOCATION = "Location Name Here"

# Set Starting Bicep
$BICEP_FILE="main.bicep"

# Log Into Azure
az login

# Set SUB to RAM AIRS
az account set --subscription "SubscriptionID"

# deploy the bicep file directly
az deployment sub  create --name testintegrationdeployment --template-file $BICEP_FILE --parameters parameters.json --location $LOCATION -o json
```

## parameters.json

The parameters.json file contains prefixes to label and differenciate between deployment types
There are two provided labels
+ workloadName - Labels the purpose of the deployment (ex. Demo, POC, ETC)
+ environment - Stage of the deployment (Development, Production, Testing, ETC)

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "workloadName" :{ 
            "value": "demo"
        },
        "environment" :{ 
            "value": "dev"
        }
    }
}
```

## Contents

### Trademarks

Trademarks This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft trademarks or logos is subject to and must follow Microsoft’s Trademark & Brand Guidelines. Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship. Any use of third-party trademarks or logos are subject to those third-party’s policies.
