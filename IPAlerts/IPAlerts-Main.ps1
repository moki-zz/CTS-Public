param (
    [string]$ParameterFile = "C:\samples\AT\IPAlerts\IPAlert-Par.json"
)

# Define the paths to your scripts
$IPExternalScriptPath1 = "C:\samples\AT\IPAlerts\IPAlertsSingle\Public IP - Under DDoSattackorno.ps1"

# Load parameters from the parameter file
$Parameters = Get-Content $ParameterFile | ConvertFrom-Json

# Define Variables
$Cntx = $Parameters.subscriptionId

# Set Context 
Set-AzContext -SubscriptionId "$Cntx"

# Call the external Storage Account - Availability with parameters
Write-Host "IPAlertsSingle\Public IP - Under DDoSattackorno.ps1..."
& $IPExternalScriptPath1 -ParameterFile "C:\samples\AT\IPAlerts\IPAlert-Par.json"

Write-Host "Master Script for IP Alerts Completed."