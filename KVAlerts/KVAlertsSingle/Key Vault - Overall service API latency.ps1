param (
    [string]$ParameterFile = "C:\samples\AT\KVAlerts\KVAlert-Par.json"
)

# Load parameters from the parameter file
$Parameters = Get-Content $ParameterFile | ConvertFrom-Json

# Define variables
$alertRuleNamePrefix = "Key Vault - Overall service API latency - azm "
$Customer = $Parameters.ClNm

# Get all Key Vaults in the subscription
$KeyVaults = Get-AzKeyVault | Where-Object { $_.Tags[$Parameters.tagKey] -eq $Parameters.tagValue }

# Loop through Key Vaults and create metric alert rules
foreach ($KeyVault in $KeyVaults)
{
    $resourceId = $keyVault.ResourceId
    # Create the metric alert condition with dimensions directly
    $condition = New-AzMetricAlertRuleV2Criteria -MetricName "ServiceApiLatency" -TimeAggregation "average" -Operator "GreaterThan" -Threshold 750
    # Define alert rule name based on the Key Vault name
    $alertRuleName = "$alertRuleNamePrefix-$($keyVault.VaultName)"
    # Create the alert rule
    Add-AzMetricAlertRuleV2 -Name $alertRuleName -ResourceGroupName $Parameters.resourceGroupName -WindowSize 00:05:00 -Frequency 00:05:00 -TargetResourceId $resourceId -Condition $condition -ActionGroupId $Parameters.actionGroupId -Severity 4 -Description "Client Name:$Customer-Refers to the time it takes for an application programming interface (API) to process and respond to a request from a client or another system on $($keyVault.VaultName)"
}