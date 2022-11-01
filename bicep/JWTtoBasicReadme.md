<!-- ABOUT THE PROJECT -->
# JWT to Basic Credential Exchange

In this scenario we tackle a challenge where a modern application utilizing OAuth needs to communicate with SAP configured for Basic Auth. Azure API Management service can be utilized to:

1. Validate the JWT Token
2. Look Up Basic Credentials based on token claims
3. Pass the 

and through policy retrieve the corresponding username/password pair. 


In a case where a modern application utilizes the OAuth standard 

Depending on SAP version / configuration it may be advantageous to 

Many SAP integration scenarios may require enabling support for basic credentials when it comes to communicating with the SAP back end. Supported auth models vary based on SAP version and deployment. In cases where the SAP back end relies on basic credentia methodology (username/password) we can 

## APIM Policy

