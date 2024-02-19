param (
    [string]$ParameterFile = "C:\samples\AT\LAWAlerts\LAWAlert-Par.json"
)

# Define the paths to your scripts
$LAWExternalScriptPath1 = "C:\samples\AT\LAWAlerts\LAWAlertsSingle\Log Analytics Workspace - QueryFailureCount.ps1"

# Load parameters from the parameter file
$Parameters = Get-Content $ParameterFile | ConvertFrom-Json

# Define Variables
$Cntx = $Parameters.subscriptionId

# Set Context 
Set-AzContext -SubscriptionId "$Cntx"

# Call the external Log Analytics Workspace - QueryFailureCount with parameters
Write-Host "LAWAlertsSingle\Log Analytics Workspace - QueryFailureCount.ps1..."
& $LAWExternalScriptPath1 -ParameterFile "C:\samples\AT\LAWAlerts\LAWAlert-Par.json"

Write-Host "Master Script for LAW Alerts Completed."