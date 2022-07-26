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