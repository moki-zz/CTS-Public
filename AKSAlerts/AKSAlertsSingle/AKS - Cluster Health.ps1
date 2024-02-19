param (
    [string]$ParameterFile = "C:\samples\AT\AKSAlerts\AKSAlert-Par.json"
)

# Load parameters from the parameter file
$Parameters = Get-Content $ParameterFile | ConvertFrom-Json

# Define variables
$alertRuleNamePrefix = "AKS - Cluster Health - azm "
$Customer = $Parameters.ClNm

# Get all AKS clusters in the subscription by Tag
$aksClusters = Get-AzAksCluster | Where-Object { $_.Tags[$Parameters.tagKey] -eq $Parameters.tagValue }

# Loop through AKS clusters and create metric alert rules
foreach ($aksCluster in $aksClusters)
{
    # Create the metric alert condition
    $condition = New-AzMetricAlertRuleV2Criteria -MetricName "cluster_autoscaler_cluster_safe_to_autoscale" -TimeAggregation "average" -Operator "LessThan" -Threshold 90
    # Define alert rule name based on the Cluster name
    $alertRuleName = "$alertRuleNamePrefix-$($aksCluster.Name)"
    # Create the alert rule
    Add-AzMetricAlertRuleV2 -Name $alertRuleName -ResourceGroupName $Parameters.resourceGroupName -WindowSize 00:05:00 -Frequency 00:01:00 -TargetResourceId $aksCluster.Id -Condition $condition -ActionGroupId $Parameters.actionGroupId -Severity 4 -Description "Client Name:$Customer-Reliability and availability of your containerized applications on $($aksCluster.Name)"
}