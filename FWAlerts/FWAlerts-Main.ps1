param (
    [string]$ParameterFile = "C:\samples\AT\FWAlerts\FWAlert-Par.json"
)

# Define the paths to your scripts
$FWExternalScriptPath1 = "C:\samples\AT\FWAlerts\FWAlertsSingle\Firewall - HealthState.ps1"
$FWExternalScriptPath2 = "C:\samples\AT\FWAlerts\FWAlertsSingle\Firewall - LatencyProbe.ps1"

# Load parameters from the parameter file
$Parameters = Get-Content $ParameterFile | ConvertFrom-Json

# Define Variables
$Cntx = $Parameters.subscriptionId

# Set Context 
Set-AzContext -SubscriptionId "$Cntx"

# Call the external Firewall - HealthState with parameters
Write-Host "FWAlertsSingle\Firewall - HealthState.ps1..."
& $FWExternalScriptPath1 -ParameterFile "C:\samples\AT\FWAlerts\FWAlert-Par.json"

# Call the external Firewall - LatencyProbe with parameters
Write-Host "FWAlertsSingle\Firewall - LatencyProbe.ps1..."
& $FWExternalScriptPath2 -ParameterFile "C:\samples\AT\FWAlerts\FWAlert-Par.json"

Write-Host "Master Script for FW Alerts Completed."