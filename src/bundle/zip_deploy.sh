#!/bin/bash

uri=`az webapp deployment list-publishing-credentials --ids $1 -o tsv --query scmUri`
curl -X POST --data-binary @$2 $uri/api/zipdeploy?api-version=2020-12-01

integrationKey=$(az eventgrid topic key list --name $4 -g $3 --query "key1" --output tsv)
az functionapp config appsettings set --ids $1  --settings "INTEGRATION_KEY=${integrationKey}"