<!-- ABOUT THE PROJECT -->
# JWT to Basic Credential Exchange

In this scenario we tackle a challenge where a modern application utilizing OAuth needs to communicate with SAP configured for Basic Auth. Azure API Management service can be utilized to:

1. Validate the JWT Token
2. Look Up Basic Credentials based on token claims
3. Pass the Basic Credentials to SAP back end

![JWTBasic](https://github.com/ms-us-rcg-app-innovation/sap-integration-landing-zone-accelerator-dev/blob/main/diagrams/JWTBasic.png)

## APIM Policy

[APIM Policy Documentation / How To](https://learn.microsoft.com/en-us/azure/api-management/api-management-howto-policies)

### APIM Policy

The following policy will validate the received JWT token against the indentity provider. The incoming JWT token is passed as the "Authorization" header. As a result of successfull validation the content of the token is stored in a variable 'jwt-token' for use in subsequent policy blocks. 

```xml
	<validate-jwt header-name="Authorization" failed-validation-httpcode="401" failed-validation-error-message="Unauthorized. Access token is missing or invalid" output-token-variable-name="jwt-token">
		<openid-config url="<Identity Provider .well-known config URL>" />
	</validate-jwt>
```

We can also perform initial auth decisions based on the passed claims. In this case we are examening the audience claim and confirming the desired value is present. 

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

Assuming successfull JWT validation at this stage we have a variable with the JWT contents called 'jwt-token'. In order to differenciate levels of access we now need to use one or more properties/claims of the JWT token to perform a lookup of the corresponding credentials. 

In the following example we extract the subject of the token to perform the basic credential lookup.

```xml
<set-variable name="jwt_username_value" value="@(((Jwt)context.Variables["jwt-token"]).Subject)" />
```

We then use extracted subject and use it as a query parameter to pefrorm the lookup API call. The response is stored in the 'my-basic-creds' variable. 

```xml
<send-request mode="new" response-variable-name="my-basic-creds" timeout="60" ignore-error="true">
    <set-url>@($"https://functionapp-data-ingestion-demo-dev-dnet.azurewebsites.net/api/GetCredentialsHardcoded?username={(string)context.Variables["jwt_username_value"]}")</set-url>
    <set-method>GET</set-method>
</send-request>
```

The authorization header now can be changed from the JWT content to the basic credential retrieived from our lookup function.

```xml
<set-header name="Authorization" exists-action="override">
    <value>@("Basic "+((IResponse)context.Variables["my-basic-creds"]).Body.As<JObject>(preserveContent:true)["credentials"].ToString())</value>
</set-header>
```

The entire flow is transparent to the client/application as well as the SAP system. 