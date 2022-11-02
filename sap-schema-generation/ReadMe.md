# Schema Generation

## Overview
To send/receive RFC, BAPI, iDoc messages/files to/from sap you need to understand message formats.  You can extract XML Schemas from SAP for the specific functions you wish to integrate with.

The SAP Connector uses the On-Premise Data Gateway to connect.  You will need to create and configure that resource as a pre requisite.

### Azure Components Used
- VM
- On Premise Data Gateway
- Logic App Standard
- Storage Account - LogicApp
- Storage Account - Schemas

### Visual Studio Code Extensions Used
- Azure Tools - Microsoft
- Azure Logic Apps (Standard) - Microsoft
- Bicep - Microsoft
- REST Client - Huachao Mao

### High Level Architecture

The user submits an HTTP request containing an array of SAP Schemas to be generated.  The LogicApp fetches the schemas and writes them to a storage account.  A test file with a sample request can be found in TestFiles\GenerateSchemas.http

![](images/GenerateSchemaOverview.png)


### Flow Detail

When a request is received the workflow will loop through the list of schemas to be generated.  For each schema, a call will be made to SAP.

The call to SAP will return an array of schemas.  For each schema the workflow will check to see if it already exists and if it does, remove it, then create the schema within the Blob Container.

![](images/GenerateSchemaFlowDetail.png)

## Deployment
The solution uses components deployed as a part of the base deployment.  Please ensure that that environment has been deployed first.

Kick of infrastructure deployment to your default subscription with by running the deployment script .\deploymentscript.ps1.  If you would rather deploy the infrastructure independent of the app code or if you run into an issue with the script, you can use the following commands to deploy the scenario

```az deployment sub create --location <location> -f bicep\main.bicep ```

Kick off infrastructure deployment to a specified subscription
```az deployment sub create --location <location> --subscription <subscription> -f bicep\main.bicep ```

To deploy the application, you need to simply zip the project and deploy it as a function app.
``` az functionapp deploy --resource-group sap-integration-lz-schemaGen-dev -n schemaGen-dev-667mu --src-path c:/test/testlogicappdeploy.zip ```

### On Prem Data Gateway
Use the bastion host to access the VM which will host your on prem data gateway(opdg) and open a browser and download the file found here; https://www.microsoft.com/en-us/download/details.aspx?id=53127.  Once installed, you will be asked to authenticate against azure to finsh the setup.

To use the SAP connector there are several prerequisits that need to be installed on the opdg computer, and you will need to make sure that the SAP user being used has the correct permissions within SAP.  For details, please see the documentation; https://learn.microsoft.com/en-us/azure/logic-apps/logic-apps-using-sap-connector.  Here is a link to the SAP connector for .NET; https://support.sap.com/en/product/connectors/msnet.html.


You will need to obtain\create the onPrem data gateway's external id.  This will be used to connect the Azure API connection with the OnPrem Data Gateway.  The external id is in the following format

```  /subscriptions/<subscriptionid>/resourceGroups/<resourcegroup where deployed>/providers/Microosft.Web/connectionGateways/<gateway name>  ```

You  can find the external id by running the OnPrem data gateway application, selecting diagnostics and exporting the logs.  Open the GatewayClusters.txt file in notepad.  The external/resourceId will be in the metadata field which is in the same json object as the gatewayId.

Once you have the externalId, you need to go to the Azure API Connection and edit its configuration.  You will see an empty 'Data Gateway' field.  drop the externalId in that field and save your changes.  The connector will validate the information and return an error if there is a problem.  

## Configuring Local Development Environment
There are a couple of settings we need to change in connections.json, local.settings.json, and parameters.json.  These changes will allow you to test and debug your application locally.

NOTE: not sure if I have to update these changes prior to zipping and deploying the workflow to the logicapp.... 

## Testing and using
Run the azure storage emulator locally on your machine.  This is required by the logicapp.  Alternatively, you can point your locally running logicApp to an azure storage account.

There is a test file located in the root directory which will post three actionURIs to the service which will generate and store several schemas in your storage account.

In visual studio code, debug the application to start a local instance

You will need to update the URI used by the test file to point to your locally running instance of the workflow and have the appropriate keys.  Right click on the workflow.json file in the GenerateSchemas folder and select 'Overview'.  NOTE: your workflow must be running for Overview to work.  This will show you the URI to the locally running instance.  Copy the URI and overwrite the one in the test file.

If you have the REST client extension by Huachao Mao installed, you should see a send link appear above the URL.  You can also use that URL and payload in another other tool, such as Postman.

After invoking the logicApp, if everything is configured correctly, you should have three folders in your storage account container and two schemas in each folder.  NOTE: that these must exist on SAP and the credentials used to access SAP must be able to access them.

## Understanding and Using Generated Schemas
The generated schemas will typically have two files per RFC/BAPI/iDOC.  rfc.xsd and types.xsd.  rfc.xsd represents the interface you are calling and the types.xsd file represents the tables used by the interface.

Unless you have an XML tool that can generate sample xml from linked xsd files, you are going to have to do some manual work.

Manually create an xml file based on the rfc.xsd.  Anywhere you see a node referencing a type, note the type, we will be able to generate them and then copy the values to build out the sample document.

use https://www.liquid-technologies.com/online-xsd-to-xml-converter do build out sample XML from the types.rfc file.

## TODO
- Automate OPDG install and configure
- Automate SAP Prereq install
- Capture outputs from infra deploy and pass to app deploy
- Configure Monitoring
- powershell to deploy application