# Scenario Overview
Storage account file drops are used to simulate connectivity to external systems.

HTTP Client submits a request and immediately receives a response.

Workflow continues to process the request.

Script checks to see if we want to test error processing.

If no errors
Message is sent to simulated SAP endpoint
Workflow pauses for 5 seconds
Message is sent to simulated SOAP endpoint

If error
Message is sent to simulated error handler
Workflow is terminated with error

## TODO
Leverage Custom Tracking Properties
Leverage Custom Tracking ID
Leverage SOAP endpoint
Leverage Azure Adapter and OnPrem Data Connector for SAP endpoint
Implement Simple Mapping Example
Implement JSON to XML conversion
Create Test Data Folder with test messages up to 100mb
Create simple Log Analytics Queries and Alerts
Create simple dashboard widgets
Create bicep for resources required by scenario

# Notes

## Stateful
Stateful workflows use external storage.  Storage transactions are subject to storage pricing.

Logic Apps run asynchronous operation pattern.  After an HTTP action calls or sends a request to an endpoint, the service/system returns a 202 Accepted.

Stores run history, inputs, and outputs

Managed connector triggers are availabile and allowd

Supports Chunking

Supports Asynchronous operations

Edit default Max run duration in host configuration

Handles large messages

## Stateless
Doesn't store run history, inputs, or outputs by default.  Can be configured for development and debug purposes only.

Managed connector triggers are unavailable or not allowed.

No support for chunking

No support for asynchronous operations

Best for workflows with max duration under 5min

Best for handling small message sizes (under 64k)

## Nested behavior differences
Patterns: Asynchronous polling patter, Syncronous Patter (fire & forget), Trigger and wait.

## Strict Network and Firewall traffic permissions
you can optionally allow traffic from Service Tags and use the same level of restrictions or policies as Azure App Service.... you will ned to find and use the fully qualified domain names of your connections.

https://docs.microsoft.com/en-us/azure/logic-apps/create-single-tenant-workflows-azure-portal#firewall-setup

https://docs.microsoft.com/en-us/azure/logic-apps/create-single-tenant-workflows-visual-studio-code#firewall-setup



