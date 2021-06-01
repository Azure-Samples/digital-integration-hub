param location string
param name_prefix string
@secure()
param postgres_adminPassword string

module monitoring './monitoring.bicep' = {
  name: 'monitoring_deploy'
  params:{
    location: location
    name_prefix: name_prefix
  }
}

module postgres './postgres.bicep' = {
  name: 'postgres_deploy'
  params:{
    location: location
    name_prefix: name_prefix
    workspace_id: monitoring.outputs.workspace_id
    administratorLoginPassword: postgres_adminPassword
  }
}

module eventgrid './eventgrid.bicep' = {
  name: 'eventgrid_deploy'
  params:{
    location: location
    name_prefix: name_prefix
  }
}

module plan './plan.bicep' = {
  name: 'plan_deploy'
  params:{
    location: location
    name_prefix: name_prefix
  }
}

module logic './logic.bicep' = {
  name: 'logic_deploy'
  params:{
    location: location
    name_prefix: name_prefix
    appSettings_insights_key: monitoring.outputs.instrumentation_key
    appSettings_eventgrid_endpoint:eventgrid.outputs.eventgrid_endpoint
    workflow_plan: plan.outputs.la_plan_id
  }
}

module function './function.bicep' = {
  name: 'function_deploy'
  params:{
    location: location
    name_prefix: name_prefix
    workspace_id: monitoring.outputs.workspace_id
    appSettings_insights_key: monitoring.outputs.instrumentation_key
    appSettings_eventgrid_endpoint:eventgrid.outputs.eventgrid_endpoint
    webapp_plan: plan.outputs.func_plan_id
    funcAppSettings_pghost: postgres.outputs.pg_host
    funcAppSettings_pguser: postgres.outputs.pg_user
    funcAppSettings_pgdb: postgres.outputs.pg_db
    funcAppSettings_pgpassword: postgres_adminPassword
  }
}

module apim './apim.bicep' = {
  name: 'apim_deploy'
  params:{
    location: location
    name_prefix: name_prefix
  }
}

output eventgrid_endpoint string = eventgrid.outputs.eventgrid_endpoint
output eventgrid_name string = eventgrid.outputs.eventgrid_name
output function_id string = function.outputs.function_id
output logic_name string = logic.outputs.logic_name
output postgres_host string = postgres.outputs.pg_host
output postgres_user string = postgres.outputs.pg_user
output postgres_db string = postgres.outputs.pg_db
output apimName string = apim.outputs.apimName
output logicAppSystemAssignedIdentityTenantId string = logic.outputs.logicAppSystemAssignedIdentityTenantId
output logicAppSystemAssignedIdentityObjectId string = logic.outputs.logicAppSystemAssignedIdentityObjectId

