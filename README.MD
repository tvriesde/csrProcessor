Key Vault -> Event Grid System Topics -> Subscription Function App (node) -> Key Vault 

To deploy
1. deploy base infra infra/deploy-base.sh
2. deploy app app/csrProcessorEventTriggerJavascript/deploy.ps1
3. create subscription app/deploy-subscription.ps1

To do
1. Update the csrProcessorEventTriggerJavascript to implement logic for handling CSR's, depending on the CA.
2. Store the result of the operation in keyvault and complete the CSR.