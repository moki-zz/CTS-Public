param (
    [string]$ParameterFile = "C:\samples\AT\SAAlerts\SAAlert-Par.json"
)

# Define the paths to your scripts
$SAExternalScriptPath1 = "C:\samples\AT\SAAlerts\SAAlertsSingle\Storage Account - Availability.ps1"
$SAExternalScriptPath2 = "C:\samples\AT\SAAlerts\SAAlertsSingle\Storage Account - Blob - Storage Used.ps1"
$SAExternalScriptPath3 = "C:\samples\AT\SAAlerts\SAAlertsSingle\Storage Account - File - capacity Quota Usage.ps1"
$SAExternalScriptPath4 = "C:\samples\AT\SAAlerts\SAAlertsSingle\Storage Account - Queue - qeueMessageCount.ps1"
$SAExternalScriptPath5 = "C:\samples\AT\SAAlerts\SAAlertsSingle\Storage Account - Queue - queueCapacity.ps1"
$SAExternalScriptPath6 = "C:\samples\AT\SAAlerts\SAAlertsSingle\Storage Account - Success E2E Latency.ps1"
$SAExternalScriptPath7 = "C:\samples\AT\SAAlerts\SAAlertsSingle\Storage Account - Table - tableCapacity.ps1"
$SAExternalScriptPath8 = "C:\samples\AT\SAAlerts\SAAlertsSingle\Storage Account - UsedCapacity.ps1"

# Load parameters from the parameter file
$Parameters = Get-Content $ParameterFile | ConvertFrom-Json

# Define Variables
$Cntx = $Parameters.subscriptionId

# Set Context 
Set-AzContext -SubscriptionId "$Cntx"

# Call the external Storage Account - Availability with parameters
Write-Host "SAAlertsSingle\Availability.ps1..."
& $SAExternalScriptPath1 -ParameterFile "C:\samples\AT\SAAlerts\SAAlert-Par.json"

# Call the external Storage Account - Blob - Storage Used with parameters
Write-Host "SAAlertsSingle\Storage Account - Blob - Storage Used.ps1..."
& $SAExternalScriptPath2 -ParameterFile "C:\samples\AT\SAAlerts\SAAlert-Par.json"

# Call the external Storage Account - File - capacity Quota Usage with parameters
Write-Host "SAAlertsSingle\Storage Account - File - capacity Quota Usage.ps1..."
& $SAExternalScriptPath3 -ParameterFile "C:\samples\AT\SAAlerts\SAAlert-Par.json"

# Call the external Storage Account - Queue - qeueMessageCount with parameters
Write-Host "SAAlertsSingle\Storage Account - Queue - qeueMessageCount.ps1..."
& $SAExternalScriptPath4 -ParameterFile "C:\samples\AT\SAAlerts\SAAlert-Par.json"

# Call the external Storage Account - Queue - queueCapacity with parameters
Write-Host "SAAlertsSingle\Storage Account - Queue - queueCapacity.ps1..."
& $SAExternalScriptPath5 -ParameterFile "C:\samples\AT\SAAlerts\SAAlert-Par.json"

# Call the external Memory - Percentiles Committed Bytes In Use with parameters
Write-Host "SAAlertsSingle\Storage Account - Success E2E Latency.ps1..."
& $SAExternalScriptPath6 -ParameterFile "C:\samples\AT\SAAlerts\SAAlert-Par.json"

# Call the external Storage Account - Table - tableCapacity with parameters
Write-Host "SAAlertsSingle\Storage Account - Table - tableCapacity.ps1..."
& $SAExternalScriptPath7 -ParameterFile "C:\samples\AT\SAAlerts\SAAlert-Par.json"

# Call the external Storage Account - UsedCapacity with parameters
Write-Host "SAAlertsSingle\Storage Account - UsedCapacity.ps1..."
& $SAExternalScriptPath8 -ParameterFile "C:\samples\AT\SAAlerts\SAAlert-Par.json"

Write-Host "Master Script for SA Alerts Completed."