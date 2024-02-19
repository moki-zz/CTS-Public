param (
    [string]$ParameterFile = "C:\samples\AT\VMAlerts\VMAlert-Par.json"
)

# Load parameters from the parameter file
$Parameters = Get-Content $ParameterFile | ConvertFrom-Json

# Define variables
$alertRuleNamePrefix = "VM - Virtual Machine - Availability - azm "
$Customer = $Parameters.ClNm

# Get all virtual machines in the subscription with a specific tag
$vms = Get-AzVM | Where-Object { $_.Tags[$Parameters.tagKey] -eq $Parameters.tagValue }

foreach ($vm in $vms)
{
    # Create the metric alert condition
    $condition = New-AzMetricAlertRuleV2Criteria -MetricName "VmAvailabilityMetric" -TimeAggregation "average" -Operator "LessThan" -Threshold 0.2
    # Define alert rule name based on the Virtual Machines name
    $alertRuleName = "$alertRuleNamePrefix-$($vm.Name)"
    # Create the alert rule with the resource group explicitly set
    Add-AzMetricAlertRuleV2 -Name $alertRuleName -ResourceGroupName $Parameters.resourceGroupName -WindowSize 00:05:00 -Frequency 00:05:00 -TargetResourceId $vm.Id -Condition $condition -ActionGroupId $Parameters.actionGroupId -Severity 4 -Description "Client Name:$Customer-Tracks reported VM availability issues on VM $($vm.Name)"
}