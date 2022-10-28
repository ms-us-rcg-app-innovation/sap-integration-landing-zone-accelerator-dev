<!-- ABOUT THE PROJECT -->
# Github Actions Deployment
GitGub workflow is defined as part of this repository. The workflow depends on RBAC for being able to execute deployments inside an Azure subscription

Depending on your access level to Azure 

```powershell

```

## parameters.json

The parameters.json file contains prefixes to label and differenciate between deployment types
There are two provided labels
+ workloadName - Labels the purpose of the deployment (ex. Demo, POC, ETC)
+ environment - Stage of the deployment (Development, Production, Testing, ETC)

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "workloadName" :{ 
            "value": "demo"
        },
        "environment" :{ 
            "value": "dev"
        }
    }
}
```

## Contents

### Trademarks

Trademarks This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft trademarks or logos is subject to and must follow Microsoft’s Trademark & Brand Guidelines. Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship. Any use of third-party trademarks or logos are subject to those third-party’s policies.
