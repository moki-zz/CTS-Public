param (
    [string]$ParameterFile = "C:\samples\AT\AKSAlerts\AKSAlert-Par.json"
)

# Load parameters from the parameter file
$Parameters = Get-Content $ParameterFile | ConvertFrom-Json

# Define variables
$alertRuleNamePrefix = "AKS - Number of pods in Ready state - azm "
$Customer = $Parameters.ClNm

# Get all AKS clusters in the subscription by Tag
$aksClusters = Get-AzAksCluster | Where-Object { $_.Tags[$Parameters.tagKey] -eq $Parameters.tagValue }

# Loop through AKS clusters and create metric alert rules
foreach ($aksCluster in $aksClusters)
{
    # Set dimensions of Alert. This will alert on all current and future computer members of the workspace
    $dim = New-AzMetricAlertRuleV2DimensionSelection -DimensionName "pod" -ValuesToInclude "*"
    # Create the metric alert condition with dimensions directly
    $condition = New-AzMetricAlertRuleV2Criteria -MetricName "kube_pod_status_ready" -TimeAggregation "average" -Operator "LessThan" -Threshold 5 -DimensionSelection $dim
    
    # Define alert rule name based on the AKS cluster name
    $alertRuleName = "$alertRuleNamePrefix-$($aksCluster.Name)"
    
    # Create the alert rule
    Add-AzMetricAlertRuleV2 -Name $alertRuleName -ResourceGroupName $Parameters.resourceGroupName -WindowSize 00:05:00 -Frequency 00:05:00 -TargetResourceId $aksCluster.Id -Condition $condition -ActionGroupId $Parameters.actionGroupId -Severity 4 -Description "Client Name:$Customer-Refers to the count of pods within the cluster that are considered Ready on $($aksCluster.Name)"
}