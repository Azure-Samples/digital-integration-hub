param apimName string
param apiName string = 'webapi'

// replace below link to be the api definition of the web app
param oaslink string = 'https://raw.githubusercontent.com/Bec-Lyons/itemsapi/main/openapi.json'

resource webapi 'Microsoft.ApiManagement/service/apis@2020-06-01-preview'= {
  name: '${apimName}/${apiName}'
  properties: {
    format: 'openapi-link'
    value: oaslink
    path: 'items'
  }
}
