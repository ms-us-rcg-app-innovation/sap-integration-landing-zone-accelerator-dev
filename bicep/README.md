<!-- ABOUT THE PROJECT -->
# Powershell Deployment

```powershell
# Set Azure Region
$LOCATION = "centralus"

# Set Starting Bicep
$BICEP_FILE="main.bicep"

# Log Into Azure
az login

# Set SUB to RAM AIRS
az account set --subscription "86f1b5b3-6a61-4667-b8af-23f9a870b657"

# deploy the bicep file directly
az deployment sub  create --name testintegrationdeployment --template-file $BICEP_FILE --parameters parameters.json --location $LOCATION -o json

# delete a deployment
az deployment sub  delete  --name testintegrationdeployment

# az ad sp create-for-rbac --name "integration-landing-zone-app-dev" --role contributor --scopes /subscriptions/86f1b5b3-6a61-4667-b8af-23f9a870b657 --sdk-auth

# Delete any stuck deployments
az webapp deployment source delete --name <APPNAME> --resource-group <RGNAME>
```


## Core Prerequisites

## Contents

## Getting Started

## Addons

## Security

## Testing

## Retail Materials

## Architecture

## Solution Components

### Trademarks

Trademarks This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft trademarks or logos is subject to and must follow Microsoft’s Trademark & Brand Guidelines. Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship. Any use of third-party trademarks or logos are subject to those third-party’s policies.
