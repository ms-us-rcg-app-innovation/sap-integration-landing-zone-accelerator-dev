<!-- ABOUT THE PROJECT -->
# About The Project

We are excited to announce the release of the SAP integration accelerator. The purpose of the accelerator is to help customers modernize the way they surface and interact with SAP systems. This repository contains best practices, samples and reusable code to serve as starting points for your SAP integration projects.

## Core Prerequisites

* Azure Subscription
* VS Code
* Connectivity to SAP - **INSERT LINK TO GUIDE?**

## Contents

+ Integration Landing Zone Deployment Scripts
+ Configuring SAP Data Connector for LogicApps
+ SAP Credential Mapping
  + JWT to Basic Credential Exchange
  + JWT to SAML Token Exchange
+ Asyhronous Patterns
+ Synchronous Pattern
+ End to End Logging and Monitoring
+ Secret Management

## Getting Started

+ Deploying Landing Zone Services
+ 

## Addons

## Security

## Testing

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
We have a base set of artifacts and scenarios that sit on top.  I think the base artifacts should deploy the infrastructure, wire up monitoring.  I think each scenario should deploy infrastructure that is only used by that scenario and have documentation specific to that scenario.
## Retail Materials

## Architecture

## Solution Components

### Trademarks

Trademarks This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft trademarks or logos is subject to and must follow Microsoft’s Trademark & Brand Guidelines. Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship. Any use of third-party trademarks or logos are subject to those third-party’s policies.
