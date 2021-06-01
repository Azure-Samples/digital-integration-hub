#!/bin/bash

az functionapp deployment source config-zip \
    --resource-group $1 \
    --name $2 \
    --src $3
integrationKey=$(az eventgrid topic key list --name $4 -g $1 --query "key1" --output tsv)

integrationPath="/subscriptions/${6}/resourceGroups/${1}/providers/Microsoft.EventGrid/topics/${4}"

az functionapp config appsettings set --name $2 --resource-group $1 --settings "EVENTGRID_CONNECTION_RUNTIMEURL=$5"

az functionapp config appsettings set --name $2 --resource-group $1 --settings "INTEGRATION_PATH=${integrationPath}"

#swap parameter file for production values
az functionapp deploy --resource-group $1 --name $2 --src-path ../../logic/azure.parameters.json --type static --target-path parameters.json