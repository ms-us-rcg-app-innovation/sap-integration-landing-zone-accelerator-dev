<!-- ABOUT THE PROJECT -->
# JWT to Basic Credential Exchange

In this scenario we tackle a challenge where a modern application utilizing OAuth needs to communicate with SAP configured for Basic Auth. Azure API Management service can be utilized to:

1. Validate the JWT Token
2. Look Up Basic Credentials based on token claims
3. Pass the Basic Credentials to SAP back end

![JWTBasic](https://github.com/ms-us-rcg-app-innovation/sap-integration-landing-zone-accelerator-dev/blob/main/diagrams/JWTBasic.png)

## APIM Policy

[APIM Policy Documentation / How To](https://learn.microsoft.com/en-us/azure/api-management/api-management-howto-policies)

As part of the deployment script APIM policies are deployed as fragments. 

[APIM Policy Fragments](https://learn.microsoft.com/en-us/azure/api-management/policy-fragments)

### APIM Policy Overview

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
<set-variable name="jwt_cred_value" value="@(((Jwt)context.Variables["jwt-token"]).Subject)" />
```

We then use extracted subject and use it as a query parameter to pefrorm the lookup API call. The response is stored in the 'my-basic-creds' variable. 

```xml
<send-request mode="new" response-variable-name="my-basic-creds" timeout="60" ignore-error="true">
    <set-url>@($"https://lookupFunctionURL.azurewebsites.net/api/FunctionName?username={(string)context.Variables["jwt_cred_value"]}")</set-url>
    <set-method>GET</set-method>
</send-request>
```

The authorization header now can be changed from the JWT content to the basic credential retrieived from our lookup function.

```xml
<set-header name="Authorization" exists-action="override">
    <value>@("Basic "+((IResponse)context.Variables["my-basic-creds"]).Body.As<JObject>(preserveContent:true)["credentials"].ToString())</value>
</set-header>
```

The entire flow is transparent to the client/application as well as the SAP system resulting in a complete auth integration pattern.

### High Throughput Considerations

The JWT to Basic auth mapping utilizes APIM's ability to call REST API's during policy evaulation. It is important to note that the policy is evaluated with every call to the API. In scenarios requiring high throughput it may be beneficial to utilize APIM's internal cache to store the credential mapping in lieu of performing the lookup call each policy execution.

First we check if the basic credential value already exists in cache. If the lookup results in a hit the cached value will be used as the authorization header.
If the cache lookup is a miss we will make a call to the lookup function and for subsequent calls store the result in APIM cache. 

```xml
<cache-lookup-value key="@((string)context.Variables["jwt_cred_value"])" default-value="CredCacheMiss" variable-name="cachedcreds" caching-type="internal" />
<choose>
    <when condition="@((string)context.Variables["cachedcreds"] !="CredCacheMiss")">
        <set-header name="Authorization" exists-action="override">
            <value>@("Basic "+(string)context.Variables["cachedcreds"])</value>
        </set-header>
    </when>
    <when condition="@((string)context.Variables["cachedcreds"] =="CredCacheMiss")">
        <send-request mode="new" response-variable-name="my-id" timeout="10" ignore-error="true">
            <set-url>@($"https://lookupFunctionURL.azurewebsites.net/api/FunctionName?username={(string)context.Variables["jwt_cred_value"]}")</set-url>
            <set-method>GET</set-method>
        </send-request>
        <set-variable name="BasicAuthCreds" value="@(((IResponse)context.Variables["my-id"]).Body.As<JObject>(preserveContent:true)["credentials"].ToString())" />
        <cache-store-value key="@((string)context.Variables["jwt_cred_value"])" value="@(((IResponse)context.Variables["my-id"]).Body.As<JObject>(preserveContent:true)["credentials"].ToString())" duration="900" caching-type="internal" />
        <set-header name="Authorization" exists-action="override">
            <value>@("Basic "+((IResponse)context.Variables["my-id"]).Body.As<JObject>(preserveContent:true)["credentials"].ToString())</value>
        </set-header>
    </when>
</choose>
```

## Azure Function Code



