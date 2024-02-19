param (
    [string]$ParameterFile = "C:\samples\AT\ASPAlerts\ASPAlert-Par.json"
)

# Define variables
$alertRuleNamePrefix = "App Service Plan - HttpQueueLength - azm "
$Customer = $Parameters.ClNm
$SID = $Parameters.subscriptionId

# Get all Clusters in the subscription
$appServicePlans = Get-AzAppServicePlan | Where-Object { $_.Tags[$Parameters.tagKey] -eq $Parameters.tagValue }

# Extract resource group and App Service Plan name from the resourceId
$resourceGroupName = $appServicePlan.ResourceGroupName
$appServicePlanName = $appServicePlan.Name

foreach ($appServicePlan in $appServicePlans)
{
    $tis = "/subscriptions/$SID/resourceGroups/$resourceGroupName/providers/Microsoft.Web/serverfarms/$appServicePlanName"
    # Create the metric alert condition
    $condition = New-AzMetricAlertRuleV2Criteria -MetricName "HttpQueueLength" -TimeAggregation "maximum" -Operator "GreaterThan" -Threshold 0
    # Define alert rule name based on the Cluster name
    $alertRuleName = "$alertRuleNamePrefix-$($appServicePlan.Name)"
    # Create the alert rule
    Add-AzMetricAlertRuleV2 -Name $alertRuleName -ResourceGroupName $Parameters.resourceGroupName -WindowSize 00:05:00 -Frequency 00:05:00 -TargetResourceId $tis -Condition $condition -ActionGroupId $Parameters.actionGroupId -Severity 4 -Description "Client Name:$Customer-Refers to the length of the HTTP request queue for the applications hosted on that plan on $($appServicePlan.Name)"
}