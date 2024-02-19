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
$dimension = New-AzScheduledQueryRuleDimensionObject -Name "Computer" -Operator "Include" -Value "*"
$condition = New-AzScheduledQueryRuleConditionObject -Dimension $dimension `
    -Query "Perf | where TimeGenerated > ago(30min) | where ObjectName == 'Memory' | where CounterName == '% Committed Bytes In Use' or CounterName == '% Used Memory' | summarize MaxMemUtilization = max(CounterValue) by bin(TimeGenerated, 5m), Computer, _ResourceId" `
    -TimeAggregation "Maximum" `
    -MetricMeasureColumn "MaxMemUtilization" `
    -Operator "GreaterThan" `
    -Threshold "99"

# Loop Through Virtual Machines and Create Alert Rules
foreach ($vm in $vms) {
    $vmName = $vm.Name
    $scope = "/subscriptions/$IntSubID/resourceGroups/$($vm.ResourceGroupName)/providers/Microsoft.Compute/virtualMachines/$vmName"
    $alertRuleName = "VM - Memory - Percentiles Committed Bytes In Use - azm -$vmName"
    $description = "Client Name:$Customer-Committed memory refers to the portion of physical memory (RAM) and page file space that is allocated to running processes and applications on VM $vmName"
    
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