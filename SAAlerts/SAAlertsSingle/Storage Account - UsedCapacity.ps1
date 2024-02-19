param (
    [string]$ParameterFile = "C:\samples\AT\SAAlerts\SAAlert-Par.json"
)

# Define variables
$alertRuleNamePrefix = "Storage Account - UsedCapacity - azm "
$Customer = $Parameters.ClNm

# Get all storage accounts in the subscription
$storageAccounts = Get-AzStorageAccount | Where-Object { $_.Tags[$Parameters.tagKey] -eq $Parameters.tagValue }

# Iterate over each storage account
foreach ($storageAccount in $storageAccounts)
{
    # Create the metric alert condition
    $condition = New-AzMetricAlertRuleV2Criteria -MetricNamespace "microsoft.storage/storageaccounts" -MetricName "UsedCapacity" -TimeAggregation "average" -Operator "GreaterThan" -Threshold 21474836480
    # Define alert rule name based on the storage account name
    $alertRuleName = "$alertRuleNamePrefix-$($storageAccount.StorageAccountName)"
    # Create the alert rule
    Add-AzMetricAlertRuleV2 -Name $alertRuleName -ResourceGroupName $Parameters.resourceGroupName -WindowSize 01:00:00 -Frequency 00:05:00 -TargetResourceId $storageAccount.Id -Condition $condition -ActionGroupId $Parameters.actionGroupId -Severity 4 -Description "Client Name:$Customer-Refers to the amount of storage space that is currently being utilized or consumed within an Azure Storage Account"
}