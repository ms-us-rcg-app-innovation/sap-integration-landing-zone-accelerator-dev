<!-- ABOUT THE PROJECT -->
# About The Project

We are excited to announce the release of the SAP integration accelerator. The purpose of the accelerator is to help customers modernize the way they surface and interact with SAP systems. This repository contains best practices, samples and reusable code to serve as starting points for your SAP integration projects.

## Core Prerequisites

* Azure Subscription
* VS Code
* Connectivity to SAP

## Contents

+ Integration Landing Zone Deployment Scripts
  + [Github Actions](https://github.com/ms-us-rcg-app-innovation/sap-integration-landing-zone-accelerator-dev/blob/main/docs/githubREADME.md)
  + [Powershell](https://github.com/ms-us-rcg-app-innovation/sap-integration-landing-zone-accelerator-dev/blob/main/docs/powershellREADME.md)
+ Configuring SAP Data Connector for LogicApps
+ SAP Credential Mapping
  + [JWT to Basic Credential Exchange](https://github.com/ms-us-rcg-app-innovation/sap-integration-landing-zone-accelerator-dev/blob/main/docs/JWTtoBasicReadme.md)
  + JWT to SAML Token Exchange
+ [Asyhronous Patterns](https://github.com/ms-us-rcg-app-innovation/sap-integration-landing-zone-accelerator-dev/blob/main/docs/asyncPatternREADME.md)
+ Synchronous Patterns
+ End to End Logging and Monitoring
+ Secret Management

## SAP Connectivity

Brief paragraph about SAP On premise connector

Link to Readme on setting up logic app with SAP

## Architecture

There are two main scenarios we considered for SAP integrations: Synchronous and Asynchronous.

### Synchronous Pattern

In the synchronous scenario we expose a REST or SOAP HTTP endpoint that can be called via an external consumer. The request will be processed by the deployed integration services with the SAP back end. A successfull response will return a 200 response once the data is processed and acknowledged by SAP

![Sync Pattern](https://github.com/ms-us-rcg-app-innovation/sap-integration-landing-zone-accelerator-dev/blob/main/diagrams/Sync1.png)

### Asynchronous Pattern

The asynchronous pattern can be triggered by either a que or http call. The purpose of the patter is to address high throughput scenarios where the client sends a message and expects a return response without having to wait for the message to be fully processed by the integration flow. 

![Async Pattern](https://github.com/ms-us-rcg-app-innovation/sap-integration-landing-zone-accelerator-dev/blob/main/diagrams/Async1.png)

### SAP Credential Exchange Patterns

As part of the SAP integration we are taking into consideration that the SAP instance (depending on kernel) may need to support modern authentication flows such as OAuth. To help address scenarios where the SAP instance relies on either Basic Authentication or SAML we also include a pattern for securely exchanging credential types that is transparent to the client.

#### JWT to Basic Credential Exchange

Modern applications supporting OAuth standard for access delegation can securely connect to SAP back end using a JWT to basic credential exchange pattern. The method utilizes APIM policy to capture and validate the JWT token against the identity provider endpoint. The token payload information can then be used to retreive additional back end credentials to interact with SAP endpoints.
+ [JWT to Basic Credential Exchange Walkthrough](https://github.com/ms-us-rcg-app-innovation/sap-integration-landing-zone-accelerator-dev/blob/main/docs/JWTtoBasicReadme.md)

<!-- ![JWTBasic](https://github.com/ms-us-rcg-app-innovation/sap-integration-landing-zone-accelerator-dev/blob/main/diagrams/JWTBasic.png) -->

#### JWT to SAML Exchange

TBD

<!-- ![JWTSAML](https://github.com/ms-us-rcg-app-innovation/sap-integration-landing-zone-accelerator-dev/blob/main/diagrams/JWTSAML.png) -->

## Getting Started

We will be utilizing several Azure services for our SAP integration. The base services are infrastructure as code via Bicep. There are two main methods for deploying the Bicep script.

  + [Powershell](https://github.com/ms-us-rcg-app-innovation/sap-integration-landing-zone-accelerator-dev/blob/main/docs/powershellREADME.md)
  + [Github Actions](https://github.com/ms-us-rcg-app-innovation/sap-integration-landing-zone-accelerator-dev/blob/main/docs/githubREADME.md)

The following services will be deployed by the landing zone template

+ Core Integration Services
  + [API Management](https://learn.microsoft.com/en-us/azure/api-management/api-management-key-concepts)
  + [Function App](https://learn.microsoft.com/en-us/azure/azure-functions/functions-overview)
  + [Logic App](https://learn.microsoft.com/en-us/azure/logic-apps/logic-apps-overview)
  + [Service Bus](https://learn.microsoft.com/en-us/azure/service-bus-messaging/service-bus-messaging-overview)
+ General Services
  + [Virtual Network](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-networks-overview)
  + [Storage Account](https://learn.microsoft.com/en-us/azure/storage/common/storage-introduction)
+ Secret Management
  + [Key Vault](https://learn.microsoft.com/en-us/azure/key-vault/general/overview)
+ Logging and Monitoring
  + [Log Analytics Workspace](https://learn.microsoft.com/en-us/azure/azure-monitor/overview)
  + [Application Insights](https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview?tabs=net)

## Addons

+ Comming Soon
  + Vnet Integration
  + Private DNS Zones
  + Azure Front Door
  + Plus More


## Notes
<!-- 
Integration Landing Zone Current State
- Main Branch: Deploys APIM, Service Bus, KeyVault, Networking, Function, powershell script helper
- Main Branch: GitHub Workflow to deploy Infra
- KarlDev: Initial Async LogicApp Scenario, Bicep, deployment workflow

Nike Colab Current State
- .devContainer
- JMeter Scripts
- APIM APIs & Policies
- Kafka Trigger Function
- Rest API Mock (Basic Auth)
- oData API Mock (Basic Auth)
- SOAP API Mock - needs basic Auth Added
- LookupDB
- Lookup Function
- Storage Q Functions
- Deployment Workflow Stubs

TODO
- Nike Value Drop: End to End message tracking docs, queries, workbooks, dashboards, deployment scripts
- Move: BasicAuth Mapping to Asset w/ deployment scripts
- Move: Mocks (Rest, oData, SOap)
- Move: JMeter scripts
- Move: Kafka Trigger to Asset w/ deployment scripts
- Move: Async Scenario to Asset (with and without Q) w/ deployment scripts
- SAML mapping scenario
- Auth mapping powerapp
- RFC, BAPI, iDOC connectivity w/deployment scripts (Note: on prem data connector required)
- Nike Value Drop: Transformation Examples (xslt and liquid) w/ deployment scripts
- infra as code for load testing
- deploy Jmeter scripts and assets
- Documentation Updates
- Testing
- Archive Nike Collab repo post disengage
- Add DevBox
- Add .DevContainer
- Add .code-workspace files where it makes sense
- Add Data Factory Scenarios - Needs Research


Senarios\Solutions
- Initial Env Testing (mocks) - pass basic/saml through apim
	- REST
	- ...
- Initial SAP Connectivity (move from mocks to sap)
	- Setup OPDC
	- Documentation for manual config
- AuthMapping (Basic/Saml)
- AuthMapping Management PowerApp
- Sync
	- LogicApp Example
	- Function Example
- Aysnc
	- LogicApp Example
	- Durable Function Example
- Event Streaming
- Data Integration

Asset Goal/Vision
- Deploy infrastructure needed for message based and data based integration with SAP.
- Include Deployable scenarios that demonstrate capabilities
- Include mocks for testing functional and performance to establish baselines prior to connecting with SAP
- Include Auth Mapping Solution

Asset Strategy Thoughts and Questions
Structure: 
We have a base set of artifacts and scenarios that sit on top.  I think the base artifacts should deploy the infrastructure, wire up monitoring.  I think each scenario should deploy infrastructure that is only used by that scenario and have documentation specific to that scenario. -->
## Retail Materials

## Architecture

## Solution Components

### Trademarks

Trademarks This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft trademarks or logos is subject to and must follow Microsoft’s Trademark & Brand Guidelines. Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship. Any use of third-party trademarks or logos are subject to those third-party’s policies.
