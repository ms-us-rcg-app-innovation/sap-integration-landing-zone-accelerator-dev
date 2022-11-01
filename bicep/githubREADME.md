<!-- ABOUT THE PROJECT -->
# GitHub Actions Deployment
Executing the deployment of bicep defined resources will require azure CLI to be installed
  + [Deploy Bicep files by using GitHub Actions](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deploy-github-actions?tabs=userlevel%2CCLI)

```yml
name: 'AzureBicepDeploy'
 
on:
  workflow_dispatch:

  push:
    branches:
    - workflow-new

  pull_request:
    branches:
    - main
    paths:
    - 'bicep/'
 
jobs:
  validate_bicep:
    name: "Validate Bicep files"
    runs-on: ubuntu-latest
    steps:
      - name: Checkout the code
        uses: actions/checkout@v2

      - name: Validate that bicep builds
        run: az bicep build -f main.bicep
        working-directory: ./bicep

  build-and-deploy:
      runs-on: ubuntu-latest
      needs: validate_bicep

      steps:

        # Checkout code
      - name: Checkout the code
        uses: actions/checkout@main

      - name: Install yq to parse yaml file
        run: |
          sudo wget -O /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/v4.5.0/yq_linux_amd64
          sudo chmod +x /usr/local/bin/yq
    
      - name: Parse config.yaml as output to GitHub Actions matrix
        run: |
          echo "config=$(yq e ./bicep/config.yml -j -I=0)" >> $GITHUB_ENV  
  
      - name: Write deployment information to log
        run: |
          echo "Deploying to ${{ fromJson(env.config).AZURE_LOCATION }} with name prefix ${{ fromJson(env.config).RESOURCE_NAME_PREFIX }} and environment tag ${{ fromJson(env.config).ENVIRONMENT_TAG }}"
        # Log into Azure
      - uses: azure/login@v1
        with:
          creds: ${{ secrets.AZURE_CREDENTIALS }}

      - name: Run Preflight Validation
        working-directory: ./bicep
        run: |
            az deployment sub validate \
              --location ${{ fromJson(env.config).AZURE_LOCATION }} \
              --parameters workloadName=${{ fromJson(env.config).RESOURCE_NAME_PREFIX }} environment=${{ fromJson(env.config).ENVIRONMENT_TAG }} \
              --template-file main.bicep
 
        # Deploy Bicep file, need to point parameters to the main.parameters.json location
      - name: deploy
        uses: azure/arm-deploy@v1
        with:
          subscriptionId: ${{ secrets.AZURE_SUBSCRIPTION }}
          scope: subscription
          region: ${{ fromJson(env.config).AZURE_LOCATION }}
          template: ./bicep/main.bicep
          parameters: > 
            workloadName=${{ fromJson(env.config).RESOURCE_NAME_PREFIX }} environment=${{ fromJson(env.config).ENVIRONMENT_TAG }} 
```

## config.yml

The config.yml file contains prefixes to label and differenciate between deployment types
There are two provided labels
+ DEPLOYMENT_NAME - Labels the deployment
+ ENVIRONMENT_TAG - Stage of the deployment (Development, Production, Testing, ETC)
+ RESOURCE_NAME_PREFIX - Stage of the deployment (Development, Production, Testing, ETC)
+ AZURE_LOCATION - Geographical  

```yml
AZURE_LOCATION: 'centralus'
RESOURCE_NAME_PREFIX: 'demo'
ENVIRONMENT_TAG: 'dev'
DEPLOYMENT_NAME: 'testintegrationdeployment'
}
```

## Contents

### Trademarks

Trademarks This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft trademarks or logos is subject to and must follow Microsoft’s Trademark & Brand Guidelines. Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship. Any use of third-party trademarks or logos are subject to those third-party’s policies.
