param (
    [string]$ParameterFile = "C:\samples\AT\VMSSAlerts\KVAlert-Par.json"
)

# Define the paths to your scripts
$VMSSExternalScriptPath1 = "C:\samples\AT\VMSSAlerts\VMSSAlertsSingle\VMSS - Percentage CPU.ps1"
$VMSSExternalScriptPath2 = "C:\samples\AT\VMSSAlerts\VMSSAlertsSingle\VMSS - VM Availability.ps1"

# Load parameters from the parameter file
$Parameters = Get-Content $ParameterFile | ConvertFrom-Json

# Define Variables
$Cntx = $Parameters.subscriptionId

# Set Context 
Set-AzContext -SubscriptionId "$Cntx"

# Call the external VMSS - Percentage CPU with parameters
Write-Host "VMSSAlertsSingle\VMSS - Percentage CPU.ps1..."
& $VMSSExternalScriptPath1 -ParameterFile "C:\samples\AT\VMSSAlerts\VMSSAlert-Par.json"

# Call the external VMSS - VM Availability with parameters
Write-Host "VMSSAlertsSingle\Key Vault - Overall vault availability.ps1..."
& $VMSSExternalScriptPath2 -ParameterFile "C:\samples\AT\VMSSAlerts\VMSSAlert-Par.json"

Write-Host "Master Script for VMSS Alerts Completed."