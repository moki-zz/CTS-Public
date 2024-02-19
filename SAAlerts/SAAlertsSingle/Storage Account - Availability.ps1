param (
    [string]$ParameterFile = "C:\samples\AT\SAAlerts\SAAlert-Par.json"
)

# Define variables
$alertRuleNamePrefix = "Storage Account - Availability - azm "
$Customer = $Parameters.ClNm

# Get all storage accounts in the subscription
$storageAccounts = Get-AzStorageAccount | Where-Object { $_.Tags[$Parameters.tagKey] -eq $Parameters.tagValue }

# Iterate over each storage account
foreach ($storageAccount in $storageAccounts)
{
    # Create the metric alert condition
    $condition = New-AzMetricAlertRuleV2Criteria -MetricName "Availability" -TimeAggregation "average" -Operator "LessThan" -Threshold 99.9
    # Define alert rule name based on the storage account name
    $alertRuleName = "$alertRuleNamePrefix-$($storageAccount.StorageAccountName)"
    # Create the alert rule
    Add-AzMetricAlertRuleV2 -Name $alertRuleName -ResourceGroupName $Parameters.resourceGroupName -WindowSize 00:05:00 -Frequency 00:01:00 -TargetResourceId $storageAccount.Id -Condition $condition -ActionGroupId $Parameters.actionGroupId -Severity 4 -Description "Client Name:$Customer-Alert on storage account availability less than 99.9%"
}