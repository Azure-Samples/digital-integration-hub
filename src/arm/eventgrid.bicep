param location string
param name_prefix string

var eventgrid_name = '${name_prefix}-eventgrid-${uniqueString(resourceGroup().id)}'

resource eventgrid 'Microsoft.EventGrid/topics@2020-10-15-preview' = {
  location : location
  name: eventgrid_name
  kind: 'Azure'
  sku: {
    name: 'Basic'
  }
  identity: {
    type: 'None'
  }
  properties: {
    inputSchema: 'EventGridSchema'
    publicNetworkAccess: 'Enabled'
  }
}

output eventgrid_endpoint string = eventgrid.properties.endpoint
output eventgrid_name string = eventgrid.name
