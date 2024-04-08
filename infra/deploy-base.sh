az deployment sub create \
  --name csrprocessor \
  --location westeurope \
  --template-file base/main.bicep \
  --parameters base/params/dev.bicepparam