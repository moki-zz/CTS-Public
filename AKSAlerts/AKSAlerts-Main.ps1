param (
    [string]$ParameterFile = "C:\samples\AT\AKSAlerts\AKSAlert-Par.json"
)

# Define the paths to your scripts
$AKSExternalScriptPath1 = "C:\samples\AT\AKSAlerts\AKSAlertsSingle\AKS - Cluster Health.ps1"
$AKSExternalScriptPath2 = "C:\samples\AT\AKSAlerts\AKSAlertsSingle\AKS - Max CPU Usage Percentage.ps1"
$AKSExternalScriptPath3 = "C:\samples\AT\AKSAlerts\AKSAlertsSingle\AKS - Nodes - cpuUsagePercentage.ps1"
$AKSExternalScriptPath4 = "C:\samples\AT\AKSAlerts\AKSAlertsSingle\AKS - Number of pods in Ready state.ps1"
$AKSExternalScriptPath5 = "C:\samples\AT\AKSAlerts\AKSAlertsSingle\AKS - Pods - podReadyPercentage.ps1"
$AKSExternalScriptPath6 = "C:\samples\AT\AKSAlerts\AKSAlertsSingle\Key Vault - Overall service API latency.ps1"

# Load parameters from the parameter file
$Parameters = Get-Content $ParameterFile | ConvertFrom-Json

# Define Variables
$Cntx = $Parameters.subscriptionId

# Set Context 
Set-AzContext -SubscriptionId "$Cntx"

# Call the external AKS - Cluster Health with parameters
Write-Host "AKSAlertsSingle\AKS - Cluster Health.ps1..."
& $AKSExternalScriptPath1 -ParameterFile "C:\samples\AT\AKSAlerts\AKSAlert-Par.json"

# Call the external AKS - Max CPU Usage Percentage with parameters
Write-Host "AKSAlertsSingle\AKS - Max CPU Usage Percentage.ps1..."
& $AKSExternalScriptPath2 -ParameterFile "C:\samples\AT\AKSAlerts\AKSAlert-Par.json"

# Call the external AKS - Nodes - cpuUsagePercentage with parameters
Write-Host "AKSAlertsSingle\AKS - Nodes - cpuUsagePercentage.ps1..."
& $AKSExternalScriptPath3 -ParameterFile "C:\samples\AT\AKSAlerts\AKSAlert-Par.json"

# Call the external AKS - Number of pods in Ready state with parameters
Write-Host "AKSAlertsSingle\AKS - Number of pods in Ready state.ps1..."
& $AKSExternalScriptPath4 -ParameterFile "C:\samples\AT\AKSAlerts\AKSAlert-Par.json"

# Call the external AKS - Pods - podReadyPercentage with parameters
Write-Host "AKSAlertsSingle\AKS - Pods - podReadyPercentage.ps1..."
& $AKSExternalScriptPath5 -ParameterFile "C:\samples\AT\AKSAlerts\AKSAlert-Par.json"

# Call the external AKS - Pods - restartingContainerCount with parameters
Write-Host "AKSAlertsSingle\AKS - Pods - restartingContainerCount.ps1..."
& $AKSExternalScriptPath6 -ParameterFile "C:\samples\AT\AKSAlerts\AKSAlert-Par.json"

Write-Host "Master Script for AKS Alerts Completed."