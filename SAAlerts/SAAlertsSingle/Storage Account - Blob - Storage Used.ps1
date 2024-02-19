param (
    [string]$ParameterFile = "C:\samples\AT\SAAlerts\SAAlert-Par.json"
)

# Define variables
$alertRuleNamePrefix = "Storage Account - Blob - Storage Used - azm "
$Customer = $Parameters.ClNm

# Get all storage accounts in the subscription
$storageAccounts = Get-AzStorageAccount | Where-Object { $_.Tags[$Parameters.tagKey] -eq $Parameters.tagValue }

# Iterate over each storage account
foreach ($storageAccount in $storageAccounts) {
    # Create the metric alert condition
    $condition = New-AzMetricAlertRuleV2Criteria -MetricName "BlobCapacity" -TimeAggregation "Average" -Operator "GreaterThan" -Threshold 104857600000
    # Create the alert rule
    $alertRuleName = $alertRuleNamePrefix + "-" + $storageAccount.StorageAccountName
    # Construct the target resource ID for the Storage Used in the storage account
    $queueServiceResourceId = $storageAccount.Id + "/blobServices/default"
    Add-AzMetricAlertRuleV2 -Name $alertRuleName -ResourceGroupName $Parameters.resourceGroupName -WindowSize 01:00:00 -Frequency 01:00:00 -TargetResourceId $queueServiceResourceId -Condition $condition -ActionGroupId $Parameters.actionGroupId -Severity 4 -Description "Client Name:$Customer-Refers to the amount of storage capacity that is currently being consumed by data stored in Azure Blob Storage within an Azure Storage Account"
}