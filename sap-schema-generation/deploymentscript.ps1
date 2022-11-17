# Set Azure Region
$LOCATION = "eastus"

# Set starting Bicep
$BICEP_FILE = ".\Bicep\main.bicep"

#choose to mark this as a dev environment vs uat or prod
$resourceSuffix = "dev"

#use this if you have multiple people deploying to the same subscription, change this for each deployment
$uniqueSuffix = ""

$deploymentName = "powershelldeployment"

$resourcegroup = "sap-integration-lz-$resourceSuffix$uniqueSuffix"

Write-Output "starting up"

Write-Output "deploying infrastructure...."
### Deploy the bicep into th users default subscription
$deployoutput = az deployment sub create -l $LOCATION -n $deploymentName -f $BICEP_FILE -p environment=$resourceSuffix adminUsername=someuser adminPassword='Password$123' uniqueSuffix=$uniqueSuffix

### will work on automating this further later, the final manual steps are fairly workable... if this picks up in popularity
### will make sense to complete the automation

### read output into variables
 #$sapConnectionRuntimeUrl = (Get-AzResourceGroupDeployment -ResourceGroupName $resourcegroup -Name $deploymentName>).Outputs.sapConnectionRuntimeUrl.value

### To enable local development
     ### Modify LogicApp\Parameters.json to include runtimeURL
     ### Modify connections.json to include the storage account connection string
     ### MAYBE - Modify connections.json to create unknown api connection id for sap
     ###         Thought is that this would refresh the token once you open the designer

     ### see: https://devblogs.microsoft.com/scripting/working-with-json-data-in-powershell/
     ### see: https://techcommunity.microsoft.com/t5/core-infrastructure-and-security/parsing-json-with-powershell/ba-p/2768721

### Write-Output "creating deployment package"

### Zip LogicApp folder for deployment
### Compress-Archive .\LogicApp\*.* deploymentPackage.Zip

### Deploy LogicApp (function deployment)
### should look something like: az functionapp deploy --resource-group sap-integration-lz-schemaGen-uat -n schemaGen-uat-fkb5w --src-path ./deploymentPackage.zip --type zip