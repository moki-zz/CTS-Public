param (
    [string]$ResourceGroup,
    [string]$location,
    [string]$DCRRName1,
    [string]$DCRRFName1,
    [string]$DCRDes1,
    [string]$WorkspaceSubscriptionId,
    [string]$ClNm,
    [string]$SubNm
)

# Read the contents of the JSON parameter file
$jsonFilePath = "C:\samples\Stage1-PreReqScript-AVD\AVD-insights.JSON"
$jsonContent = Get-Content -Path $jsonFilePath | ConvertFrom-Json

# Modify the workspaceResourceId value with the provided subscription ID
$jsonContent.properties.destinations.logAnalytics.workspaceResourceId = "/subscriptions/$WorkspaceSubscriptionId/resourceGroups/AZM-SNow/providers/Microsoft.OperationalInsights/workspaces/LAW-AZM-SNOW-INSIGHTS-AVD"

# Convert the modified JSON content back to JSON format
$modifiedJsonContent = $jsonContent | ConvertTo-Json -Depth 100

# Save the modified JSON content back to the JSON file
Set-Content -Path $jsonFilePath -Value $modifiedJsonContent -Force

# Create the data collection rule using the modified JSON file
New-AzDataCollectionRule -ResourceGroupName $ResourceGroup -Location $location -RuleName $DCRRName1 -RuleFile $DCRRFName1 -Description $DCRDes1
