param (
    [string]$ParameterFile = "C:\samples\AT\SAAlerts\SAAlert-Par.json"
)

# Define variables
$alertRuleNamePrefix = "Storage Account - Queue - qeueMessageCount - azm "
$Customer = $Parameters.ClNm

# Get all storage accounts in the subscription
$storageAccounts = Get-AzStorageAccount | Where-Object { $_.Tags[$Parameters.tagKey] -eq $Parameters.tagValue }

# Iterate over each storage account
foreach ($storageAccount in $storageAccounts) {
    # Create the metric alert condition
    $condition = New-AzMetricAlertRuleV2Criteria -MetricName "QueueMessageCount" -TimeAggregation "Average" -Operator "GreaterThan" -Threshold 100
    # Create the alert rule
    $alertRuleName = $alertRuleNamePrefix + "-" + $storageAccount.StorageAccountName
    # Construct the target resource ID for the queue service in the storage account
    $queueServiceResourceId = $storageAccount.Id + "/queueServices/default"
    Add-AzMetricAlertRuleV2 -Name $alertRuleName -ResourceGroupName $Parameters.resourceGroupName -WindowSize 01:00:00 -Frequency 00:05:00 -TargetResourceId $queueServiceResourceId -Condition $condition -ActionGroupId $Parameters.actionGroupId -Severity 4 -Description "Client Name:$Customer-Refers to the metric that tracks the current number of messages stored in an Azure Queue within an Azure Storage Account"
}