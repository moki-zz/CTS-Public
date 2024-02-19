param (
    [string]$ParameterFile = "C:\samples\AT\KVAlerts\KVAlert-Par.json"
)

# Define the paths to your scripts
$KVExternalScriptPath1 = "C:\samples\AT\KVAlerts\KVAlertsSingle\Key Vault - Overall service API latency.ps1"
$KVExternalScriptPath2 = "C:\samples\AT\KVAlerts\KVAlertsSingle\Key Vault - Overall vault availability.ps1"
$KVExternalScriptPath3 = "C:\samples\AT\KVAlerts\KVAlertsSingle\Key Vault - Overall vault saturation.ps1"

# Load parameters from the parameter file
$Parameters = Get-Content $ParameterFile | ConvertFrom-Json

# Define Variables
$Cntx = $Parameters.subscriptionId

# Set Context 
Set-AzContext -SubscriptionId "$Cntx"

# Call the external Key Vault - Overall service API latency with parameters
Write-Host "KVAlertsSingle\Key Vault - Overall service API latency.ps1..."
& $KVExternalScriptPath1 -ParameterFile "C:\samples\AT\KVAlerts\KVAlert-Par.json"

# Call the external Key Vault - Overall vault availability with parameters
Write-Host "KVAlertsSingle\Key Vault - Overall vault availability.ps1..."
& $KVExternalScriptPath2 -ParameterFile "C:\samples\AT\KVAlerts\KVAlert-Par.json"

# Call the external Key Vault - Overall vault saturation with parameters
Write-Host "KVAlertsSingle\Key Vault - Overall vault saturation.ps1..."
& $KVExternalScriptPath3 -ParameterFile "C:\samples\AT\KVAlerts\KVAlert-Par.json"

Write-Host "Master Script for KV Alerts Completed."