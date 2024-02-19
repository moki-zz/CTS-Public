param (
    [string]$ParameterFile = "C:\samples\AT\ASPAlerts\ASPAlert-Par.json"
)

# Define the paths to your scripts
$ASPExternalScriptPath1 = "C:\samples\AT\ASPAlerts\ASPAlertsSingle\App Service Plan - CpuPercentage.ps1"
$ASPExternalScriptPath2 = "C:\samples\AT\ASPAlerts\ASPAlertsSingle\App Service Plan - HttpQueueLength.ps1"
$ASPExternalScriptPath3 = "C:\samples\AT\ASPAlerts\ASPAlertsSingle\App Service Plan - MemoryPercentage.ps1"

# Load parameters from the parameter file
$Parameters = Get-Content $ParameterFile | ConvertFrom-Json

# Define Variables
$Cntx = $Parameters.subscriptionId

# Set Context 
Set-AzContext -SubscriptionId "$Cntx"

# Call the external App Service Plan - CpuPercentage with parameters
Write-Host "ASPAlertsSingle\App Service Plan - CpuPercentage.ps1..."
& $ASPExternalScriptPath1 -ParameterFile "C:\samples\AT\ASPAlerts\KVAlert-Par.json"

# Call the external App Service Plan - HttpQueueLength with parameters
Write-Host "ASPAlertsSingle\App Service Plan - HttpQueueLength.ps1..."
& $ASPExternalScriptPath2 -ParameterFile "C:\samples\AT\ASPAlerts\KVAlert-Par.json"

# Call the external App Service Plan - MemoryPercentage with parameters
Write-Host "ASPAlertsSingle\App Service Plan - MemoryPercentage.ps1..."
& $ASPExternalScriptPath3 -ParameterFile "C:\samples\AT\ASPAlerts\KVAlert-Par.json"

Write-Host "Master Script for ASP Alerts Completed."