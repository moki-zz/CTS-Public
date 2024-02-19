param (
    [string]$ParameterFile = "C:\samples\AT\BAlerts\BAlert-Par.json"
)

# Define the paths to your scripts
$BExternalScriptPath1 = "C:\samples\AT\BAlerts\BAlertsSingle\Bastion - Communication Status.ps1"

# Load parameters from the parameter file
$Parameters = Get-Content $ParameterFile | ConvertFrom-Json

# Define Variables
$Cntx = $Parameters.subscriptionId

# Set Context 
Set-AzContext -SubscriptionId "$Cntx"

# Call the external Bastion - Communication Status with parameters
Write-Host "BAlertsSingle\Bastion - Communication Status.ps1..."
& $BExternalScriptPath1 -ParameterFile "C:\samples\AT\BAlerts\BAlert-Par.json"

Write-Host "Master Script for B Alerts Completed."