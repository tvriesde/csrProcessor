az deployment group create \
  --name csrprocessor \
  --resource-group rg-csrprocessor-dev-westeurope \
  --template-file eventSubscriptions/main.bicep \
  --parameters eventSubscriptions/params/dev.bicepparam