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
