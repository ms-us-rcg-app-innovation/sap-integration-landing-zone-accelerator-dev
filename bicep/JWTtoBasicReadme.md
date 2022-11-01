<!-- ABOUT THE PROJECT -->
# JWT to Basic Credential Exchange

In this scenario we tackle a challenge where a modern application utilizing OAuth needs to communicate with SAP configured for Basic Auth. Azure API Management service can be utilized to:

1. Validate the JWT Token
2. Look Up Basic Credentials based on token claims
3. Pass the Basic Credentials to SAP back end

![JWTBasic](https://github.com/ms-us-rcg-app-innovation/sap-integration-landing-zone-accelerator-dev/blob/main/diagrams/JWTBasic.png)

## APIM Policy

+ [APIM Policy](https://learn.microsoft.com/en-us/azure/api-management/api-management-howto-policies)

and through policy retrieve the corresponding username/password pair. 



