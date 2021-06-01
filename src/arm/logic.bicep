param location string
param name_prefix string
param appSettings_insights_key string
param appSettings_eventgrid_endpoint string
param workflow_plan string 

var eventgrid_connection_name = '${name_prefix}-eventgrid-connection'
var eventgrid_connection_accesspolicy = '${name_prefix}-eventgrid-accesspolicy'
var storage_name = '${uniqueString(resourceGroup().id)}stor'
var logic_name = '${name_prefix}-logic-${uniqueString(resourceGroup().id)}'

resource storage_account 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: storage_name
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_RAGRS'
  }
}

resource logic 'Microsoft.Web/sites@2020-06-01' = {
  name: logic_name
  location: location
  kind: 'workflowapp,functionapp'
  identity:{
    type:'SystemAssigned'
  }
  properties: {
    siteConfig: {
      netFrameworkVersion: 'v4.6'
      appSettings: [
        {
          name: 'WEBSITES_PORT'
          value: '80'
        }
        {
          name: 'K8SE_FUNCTIONS_TRIGGERS'
          value: '{"hostJson":{"version":"2.0","logging":{"applicationInsights":{"samplingExcludedTypes":"Request","samplingSettings":{"isEnabled":true}},"logLevel":{"Host.Triggers.Workflow":"Debug"}}},"functionsJson":{}}'
        }
        {
          name: 'APP_KIND'
          value: 'workflowApp'
        }
        {
          name: 'FUNCTION_APP_EDIT_MODE'
          value: 'readOnly'
        }
        {
          name: 'AzureFunctionsJobHost__extensionBundle__id'
          value: 'Microsoft.Azure.Functions.ExtensionBundle.Workflows'
        }
        {
          name: 'AzureFunctionsJobHost__extensionBundle__version'
          value: '[1.*, 2.0.0)'
        }
        {
          name: 'FUNCTIONS_V2_COMPATIBILITY_MODE'
          value: 'true'
        }
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storage_account.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(storage_account.id, storage_account.apiVersion).keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storage_account.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(storage_account.id, storage_account.apiVersion).keys[0].value}'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'node'
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~3'
        }
        {
          name: 'WEBSITE_NODE_DEFAULT_VERSION'
          value: '~12'
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: '${appSettings_insights_key}'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: logic_name
        }
        {
          name:'EVENTGRID_CONNECTION_RUNTIMEURL'
          value: ''
        }
        {
          name:'WORKFLOWS_SUBSCRIPTION_ID'
          value: subscription().subscriptionId
        }
        {
          name:'WORKFLOWS_RESOURCE_GROUP_NAME'
          value: resourceGroup().name
        }
        {
          name:'WORKFLOWS_LOCATION_NAME'
          value: location
        }
        {
          name:'INTEGRATION_PATH'
          value: ''
        }
      ]
    }
    serverFarmId: workflow_plan
    clientAffinityEnabled: false
  }
}

output logic_name string = logic.name
output logic_hostname string = logic.properties.hostNames[0]
output logicAppSystemAssignedIdentityTenantId string = logic.identity.tenantId
output logicAppSystemAssignedIdentityObjectId string = logic.identity.principalId
