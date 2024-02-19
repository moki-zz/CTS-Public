param (
    [string]$ParameterFile = "C:\samples\AT\LAWAlerts\LAWAlert-Par.json"
)

# Load parameters from the parameter file
$Parameters = Get-Content $ParameterFile | ConvertFrom-Json

# Define variables
$alertRuleNamePrefix = "Log Analytics - QueryFailureCount - azm "
$Customer = $Parameters.ClNm

# Get all Log Analytics Workspaces in the subscription
$logAnalyticsWorkspaces = Get-AzOperationalInsightsWorkspace | Where-Object { $_.Tags[$Parameters.tagKey] -eq $Parameters.tagValue }

foreach ($logAnalyticsWorkspace in $logAnalyticsWorkspaces)
{
    # Create the metric alert condition for Query Failure Count
    $condition = New-AzMetricAlertRuleV2Criteria -MetricName "Query Failure Count" -TimeAggregation "count" -Operator "GreaterThan" -Threshold 10
    # Define alert rule name based on the Log Analytics Workspace name
    $alertRuleName = "$alertRuleNamePrefix-$($logAnalyticsWorkspace.Name)"
    # Create the alert rule
    Add-AzMetricAlertRuleV2 -Name $alertRuleName -ResourceGroupName $Parameters.resourceGroupName -WindowSize 00:05:00 -Frequency 00:01:00 -TargetResourceId $logAnalyticsWorkspace.ResourceId -Condition $condition -ActionGroupId $Parameters.actionGroupId -Severity 4 -Description "Client Name:$Customer-Refers to the count of failed queries in a Log Analytics workspace within Microsoft Azure on $($logAnalyticsWorkspace.Name)"
}