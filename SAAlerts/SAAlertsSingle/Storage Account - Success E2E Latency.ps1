param (
    [string]$ParameterFile = "C:\samples\AT\SAAlerts\SAAlert-Par.json"
)

# Define variables
$alertRuleNamePrefix = "Storage Account - Success E2E Latency - azm "
$Customer = $Parameters.ClNm

# Get all storage accounts in the subscription
$storageAccounts = Get-AzStorageAccount | Where-Object { $_.Tags[$Parameters.tagKey] -eq $Parameters.tagValue }

# Iterate over each storage account
foreach ($storageAccount in $storageAccounts)
{
    # Create the metric alert condition
    $condition = New-AzMetricAlertRuleV2Criteria -MetricNamespace "microsoft.storage/storageaccounts" -MetricName "SuccessE2ELatency" -TimeAggregation "average" -Operator "GreaterThan" -Threshold 20000
    # Define alert rule name based on the storage account name
    $alertRuleName = "$alertRuleNamePrefix-$($storageAccount.StorageAccountName)"
    # Create the alert rule
    Add-AzMetricAlertRuleV2 -Name $alertRuleName -ResourceGroupName $Parameters.resourceGroupName -WindowSize 01:00:00 -Frequency 00:05:00 -TargetResourceId $storageAccount.Id -Condition $condition -ActionGroupId $Parameters.actionGroupId -Severity 4 -Description "Client Name:$Customer-End-to-end latency associated with operations performed on an Azure Storage Account"
}