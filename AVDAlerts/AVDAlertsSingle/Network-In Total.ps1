param (
    [string]$ParameterFile = "C:\samples\AT\AVDAlerts\AVDAlert-Par.json"
)

# Load parameters from the parameter file
$Parameters = Get-Content $ParameterFile | ConvertFrom-Json

$alertRuleNamePrefix = "AVD - Network - In Total - azm "
$Customer = $Parameters.ClNm

# Get all virtual machines in the subscription with a specific tag
$vms = Get-AzVM | Where-Object { $_.Tags[$Parameters.tagKey] -eq $Parameters.tagValue }

foreach ($vm in $vms)
{
    # Create the metric alert condition
    $condition = New-AzMetricAlertRuleV2Criteria -MetricNamespace "Microsoft.Compute/virtualMachines" -MetricName "Network In Total" -TimeAggregation "Average" -Operator "GreaterThan" -Threshold 3000000000
    # Define alert rule name based on the Virtual Machines name
    $alertRuleName = "$alertRuleNamePrefix-$($vm.Name)"
    # Create the alert rule
    Add-AzMetricAlertRuleV2 -Name $alertRuleName -ResourceGroupName $Parameters.resourceGroupName -WindowSize 00:05:00 -Frequency 00:05:00 -TargetResourceId $vm.Id -Condition $condition -ActionGroupId $Parameters.actionGroupId -Severity 4 -Description "Client Name:$Customer-Measures the rate of data transfer in bytes per second for network interface (network adapter) on a Windows system"
}