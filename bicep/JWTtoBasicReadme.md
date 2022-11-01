<!-- ABOUT THE PROJECT -->
# JWT to Basic Credential Exchange

In this scenario we tackle a challenge where a modern application utilizing OAuth needs to communicate with SAP configured for Basic Auth. Azure API Management service can be utilized to:

1. Validate the JWT Token
2. Look Up Basic Credentials based on token claims
3. Pass the Basic Credentials to SAP back end

![JWTBasic](https://github.com/ms-us-rcg-app-innovation/sap-integration-landing-zone-accelerator-dev/blob/main/diagrams/JWTBasic.png)

## APIM Policy

+ [APIM Policy](https://learn.microsoft.com/en-us/azure/api-management/api-management-howto-policies)

### APIM Policy

The following policy will validate the received JWT token against the indentity provider. The incoming JWT token is passed as the "Authorization" header. As a result of successfull validation the content of the token is stored in a variable 'jwt-token' for use in subsequent policy blocks. 

```xml
	<validate-jwt header-name="Authorization" failed-validation-httpcode="401" failed-validation-error-message="Unauthorized. Access token is missing or invalid" output-token-variable-name="jwt-token">
		<openid-config url="<Identity Provider .well-known config URL>" />
	</validate-jwt>
```

We can also perform auth decisions based on the passed claims. In this case we are examening the audience claim and confirming the desired value is present. 

```xml
	<validate-jwt header-name="Authorization" failed-validation-httpcode="401" failed-validation-error-message="Unauthorized. Access token is missing or invalid" output-token-variable-name="jwt-token">
		<openid-config url="<Identity Provider .well-known config URL>" />
		<required-claims>
			<claim name="aud">
				<value>api://default</value>
			</claim>
		</required-claims>
	</validate-jwt>
```