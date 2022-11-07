# Set Azure Region
$LOCATION = "centralus"

# Set starting Bicep
$BICEP_FILE = ".\Bicep\main.bicep"

#choose to mark this as a dev environment vs uat or prod
$resourceSuffix = "uat"

#use this if you have multiple people deploying to the same subscription, change this for each deployment
$uniqueSuffix = ""

$deploymentName = "powershelldeployment"

Write-Output "starting up"

Write-Output "deploying infrastructure...."
### Deploy the bicep into th users default subscription
$deployoutput = az deployment sub create -l $LOCATION -n $deploymentName -f $BICEP_FILE -p environment=$resourceSuffix  uniqueSuffix=$uniqueSuffix
