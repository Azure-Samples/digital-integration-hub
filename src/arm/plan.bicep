param name_prefix string
param location string

var webfarm_name = '${name_prefix}-webfarm-${uniqueString(resourceGroup().id)}'
var workflowplan_name = '${name_prefix}-workflowplan-${uniqueString(resourceGroup().id)}'

resource webapi_farm_azure 'Microsoft.Web/serverfarms@2020-06-01' ={
  name: concat(webfarm_name, '-azure')
  location: location
  kind: 'linux'
  sku: {
    name: 'P1V2'
  }
  properties: {
    reserved: true
  }
}

resource workflow_farm_azure 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: concat(workflowplan_name, '-azure')
  location: location
  kind: 'windows'
  sku: {
    tier:'WorkflowStandard'
    name:'WS1'
  }
}

output func_plan_id string = webapi_farm_azure.id
output la_plan_id string = workflow_farm_azure.id
