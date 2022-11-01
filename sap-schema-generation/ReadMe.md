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

Kick of infrastructure deployment to your default subscription with

```az deployment sub create --location <location> -f bicep\main.bicep ```

Kick off infrastructure deployment to a specified subscription
```az deployment sub create --location <location> --subscription <subscription> -f bicep\main.bicep ```

### On Prem Data Gateway
Use the bastion host to access the VM which will host your on prem data gateway(opdg) and open a browser and download the file found here; https://www.microsoft.com/en-us/download/details.aspx?id=53127.  Once installed, you will be asked to authenticate against azure to finsh the setup.

To use the SAP connector there are several prerequisits that need to be installed on the opdg computer, and you will need to make sure that the SAP user being used has the correct permissions within SAP.  For details, please see the documentation; https://learn.microsoft.com/en-us/azure/logic-apps/logic-apps-using-sap-connector.  Here is a link to the SAP connector for .NET; https://support.sap.com/en/product/connectors/msnet.html.


Obtain the Gateway InstalationID and write it down for later use.

## Use
There is a test file located in the TestFiles directory which will post three actionURIs to the service which will generate and store several schemas in your storage account.

## Understanding and Using Generated Schemas

## TODO
- Automate OPDG install and configure
- Automate SAP Prereq install
- Capture outputs from infra deploy and pass to app deploy
- Configure Monitoring
- powershell to deploy application