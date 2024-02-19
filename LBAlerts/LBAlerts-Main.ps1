param (
    [string]$ParameterFile = "C:\samples\AT\LBAlerts\LBAlert-Par.json"
)

# Define the paths to your scripts
$LBExternalScriptPath1 = "C:\samples\AT\LBAlerts\LBAlertsSingle\Load Balancer - Health Probe Status.ps1"

# Load parameters from the parameter file
$Parameters = Get-Content $ParameterFile | ConvertFrom-Json

# Define Variables
$Cntx = $Parameters.subscriptionId

# Set Context 
Set-AzContext -SubscriptionId "$Cntx"

# Call the external Load Balancer - Health Probe Status with parameters
Write-Host "LBAlertsSingle\Load Balancer - Health Probe Status.ps1..."
& $LBExternalScriptPath1 -ParameterFile "C:\samples\AT\LBAlerts\LBAlert-Par.json"

Write-Host "Master Script for LB Alerts Completed."