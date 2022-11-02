<!-- ABOUT THE PROJECT -->
# Asynchronous  Communication

An asynchronous methods return a response to the caller immediately before the completion of its processing. In this SAP integration flow we demonstrate two patterns for Asynchronous message processing. 

1. Sync -> Async
   + ![Message Trigger](https://github.com/ms-us-rcg-app-innovation/sap-integration-landing-zone-accelerator-dev/blob/main/diagrams/messageTrigger.png)
2. Async -> Async

## Prerequisites

+ VS Code with [Azure Functions Extension](https://code.visualstudio.com/docs/azure/extensions)
+ Bicep defined infrastructure deployed
  + [Github Actions](https://github.com/ms-us-rcg-app-innovation/sap-integration-landing-zone-accelerator-dev/blob/main/docs/githubREADME.md)
  + [Powershell](https://github.com/ms-us-rcg-app-innovation/sap-integration-landing-zone-accelerator-dev/blob/main/docs/powershellREADME.md)
+ [Azure Functions Core Tools](https://learn.microsoft.com/en-us/azure/azure-functions/functions-run-local?tabs=v4%2Cwindows%2Ccsharp%2Cportal%2Cbash#v2)