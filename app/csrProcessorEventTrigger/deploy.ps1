rm functionapp.zip
dotnet publish -o ./build/
Compress-Archive -Path ./build/* -DestinationPath functionapp.zip
az functionapp deployment source config-zip --resource-group rg-csrprocessor-dev-westeurope --name func-csrprocessor-dev-westeurope --src functionapp.zip