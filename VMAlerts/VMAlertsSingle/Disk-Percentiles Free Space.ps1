param (
    [string]$ParameterFile = "C:\samples\AT\VMAlerts\VMAlert-Par.json"
)

# Load parameters from the parameter file
$Parameters = Get-Content $ParameterFile | ConvertFrom-Json

# Define variables
$Customer = $Parameters.ClNm
$IntSubID = $Parameters.subscriptionId

# Get all virtual machines in the subscription with a specific tag
$vms = Get-AzVM | Where-Object { $_.Tags[$Parameters.tagKey] -eq $Parameters.tagValue }

# Define Common Condition for Alert Rules
$dimension = New-AzScheduledQueryRuleDimensionObject -Name "InstanceName" -Operator "Include" -Value "*"
$condition = New-AzScheduledQueryRuleConditionObject -Dimension $dimension `
    -Query "Perf | where TimeGenerated > ago(30min) | where ObjectName == 'Logical Disk' or ObjectName == 'LogicalDisk' | where CounterName == '% Free Space' | summarize MaxDiskFreeSpacePercUtilization = max(CounterValue) by bin(TimeGenerated, 5m), Computer, _ResourceId, InstanceName" `
    -TimeAggregation "Maximum" `
    -MetricMeasureColumn "MaxDiskFreeSpacePercUtilization" `
    -Operator "LessThan" `
    -Threshold "5"

# Loop Through Virtual Machines and Create Alert Rules
foreach ($vm in $vms) {
    $vmName = $vm.Name
    $scope = "/subscriptions/$IntSubID/resourceGroups/$($vm.ResourceGroupName)/providers/Microsoft.Compute/virtualMachines/$vmName"
    $alertRuleName = "VM - Disk - Percentiles Free Space - azm -$vmName"
    $description = "Client Name:$Customer-Measure the percentage of free disk space on all logical disks (partitions) on a OS system on VM $vmName"
    
    New-AzScheduledQueryRule -Name $alertRuleName `
        -ResourceGroupName $Parameters.resourceGroupName `
        -Location $Parameters.location `
        -DisplayName $alertRuleName `
        -Description $description `
        -Scope $scope `
        -Severity 4 `
        -WindowSize ([System.TimeSpan]::FromMinutes(10)) `
        -EvaluationFrequency ([System.TimeSpan]::FromMinutes(5)) `
        -CriterionAllOf $condition
}