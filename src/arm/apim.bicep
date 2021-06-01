param location string
param name_prefix string

var apimName = '${name_prefix}-apim-${uniqueString(resourceGroup().id)}'

param capacity int = 0 // has to be 0 for Consumption tier
param email string = 'contoso@contoso.com'
param org string = 'Contoso'

resource apim 'Microsoft.ApiManagement/service@2020-06-01-preview' = {
  name: apimName
  location: location
  sku: {
    name: 'Consumption'
    capacity: capacity 
  }
  properties:{
    publisherEmail: email
    publisherName: org
  }
}

output apimName string = apim.name
