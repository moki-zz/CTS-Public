param (
    [string]$ParameterFile = "C:\samples\AT\SQLAlerts\SQLAlert-Par.json"
)

# Define the paths to your scripts
$SQLExternalScriptPath1 = "C:\samples\AT\SQLAlerts\SQLAlertsSingle\SQL Database - BlockedByFireWall.ps1"
$SQLExternalScriptPath2 = "C:\samples\AT\SQLAlerts\SQLAlertsSingle\SQL Database - CPU Percent.ps1"
$SQLExternalScriptPath3 = "C:\samples\AT\SQLAlerts\SQLAlertsSingle\SQL Database - DTU Consumption Percent.ps1"
$SQLExternalScriptPath4 = "C:\samples\AT\SQLAlerts\SQLAlertsSingle\SQL Database - In-Memory OLTP storage percent.ps1"
$SQLExternalScriptPath5 = "C:\samples\AT\SQLAlerts\SQLAlertsSingle\SQL Database - Sessions Percent.ps1"
$SQLExternalScriptPath6 = "C:\samples\AT\SQLAlerts\SQLAlertsSingle\SQL Database - System Connection Failed.ps1"
$SQLExternalScriptPath7 = "C:\samples\AT\SQLAlerts\SQLAlertsSingle\SQL Database - User Connection Failed.ps1"
$SQLExternalScriptPath8 = "C:\samples\AT\SQLAlerts\SQLAlertsSingle\SQL Database - Workers Percent.ps1"

# Load parameters from the parameter file
$Parameters = Get-Content $ParameterFile | ConvertFrom-Json

# Define Variables
$Cntx = $Parameters.subscriptionId

# Set Context 
Set-AzContext -SubscriptionId "$Cntx"

# Call the external SQL Database - BlockedByFireWall with parameters
Write-Host "SQLAlertsSingle\SQL Database - BlockedByFireWall.ps1..."
& $SQLExternalScriptPath1 -ParameterFile "C:\samples\AT\SQLAlerts\SQLAlert-Par.json"

# Call the external SQL Database - CPU Percent with parameters
Write-Host "SQLAlertsSingle\SQL Database - CPU Percent.ps1..."
& $SQLExternalScriptPath2 -ParameterFile "C:\samples\AT\SQLAlerts\SQLAlert-Par.json"

# Call the external SQL Database - DTU Consumption Percent with parameters
Write-Host "SQLAlertsSingle\SQL Database - DTU Consumption Percent.ps1..."
& $SQLExternalScriptPath3 -ParameterFile "C:\samples\AT\SQLAlerts\SQLAlert-Par.json"

# Call the external SQL Database - In-Memory OLTP storage percent with parameters
Write-Host "SQLAlertsSingle\SQL Database - In-Memory OLTP storage percent.ps1..."
& $SQLExternalScriptPath4 -ParameterFile "C:\samples\AT\SQLAlerts\SQLAlert-Par.json"

# Call the external SQL Database - Sessions Percent with parameters
Write-Host "SQLAlertsSingle\SQL Database - Sessions Percent.ps1..."
& $SQLExternalScriptPath5 -ParameterFile "C:\samples\AT\SQLAlerts\SQLAlert-Par.json"

# Call the external SQL Database - System Connection Failed with parameters
Write-Host "SQLAlertsSingle\SQL Database - System Connection Failed.ps1..."
& $SQLExternalScriptPath6 -ParameterFile "C:\samples\AT\SQLAlerts\SQLAlert-Par.json"

# Call the external SQL Database - User Connection Failed with parameters
Write-Host "SQLAlertsSingle\SQL Database - User Connection Failed.ps1..."
& $SQLExternalScriptPath7 -ParameterFile "C:\samples\AT\SQLAlerts\SQLAlert-Par.json"

# Call the external SQL Database - Workers Percent with parameters
Write-Host "SQLAlertsSingle\SQL Database - Workers Percent.ps1..."
& $SQLExternalScriptPath8 -ParameterFile "C:\samples\AT\SQLAlerts\SQLAlert-Par.json"

Write-Host "Master Script for SQL Alerts Completed."