param (
    [string]$ParameterFile = "C:\samples\AT\VMSSAlerts\KVAlert-Par.json"
)

# Load parameters from the parameter file
$Parameters = Get-Content $ParameterFile | ConvertFrom-Json

# Define variables
$alertRuleNamePrefix = "VMSS - Percentage CPU - azm "
$Customer = $Parameters.ClNm

# Get all VMSS in the subscription
$vmssList = Get-AzVmss | Where-Object { $_.Tags[$Parameters.tagKey] -eq $Parameters.tagValue }

# Loop through VMSS and create metric alert rules
foreach ($vmss in $vmssList)
{
    # Set dimensions of Alert to VMName. This will alert on all current and future VMs within the VMSS
    $dim = New-AzMetricAlertRuleV2DimensionSelection -DimensionName "VMName" -ValuesToInclude "*"
    
    # Create the metric alert condition with dimensions directly
    $condition = New-AzMetricAlertRuleV2Criteria -MetricNamespace "microsoft.compute/virtualmachinescalesets" -MetricName "Percentage CPU" -TimeAggregation "maximum" -Operator "GreaterThan" -Threshold 95 -DimensionSelection $dim
    
    # Define alert rule name based on the VMSS name
    $alertRuleName = "$alertRuleNamePrefix-$($vmss.Name)"
    
    # Create the alert rule
    Add-AzMetricAlertRuleV2 -Name $alertRuleName -ResourceGroupName $Parameters.resourceGroupName -WindowSize 00:05:00 -Frequency 00:05:00 -TargetResourceId $vmss.Id -Condition $condition -ActionGroupId $Parameters.actionGroupId -Severity 4 -Description "Client Name:$Customer-Alert for high CPU usage in VMSS on $($vmss.Name)"
}