param (
    [string]$ParameterFile = "C:\samples\AT\BAlerts\BAlert-Par.json"
)

# Load parameters from the parameter file
$Parameters = Get-Content $ParameterFile | ConvertFrom-Json

# Define variables
$alertRuleNamePrefix = "Bastion - Communication Status - azm "
$Customer = $Parameters.ClNm

# Filter resources of type "Microsoft.Network/bastionHosts"
$bro = Get-AzResource | Where-Object { $_.ResourceType -eq "Microsoft.Network/bastionHosts" }

# Filter resources by Tag
$bastionResources = $bro | Where-Object { $_.Tags[$Parameters.tagKey] -eq $Parameters.tagValue }

# Loop through Bastion and create metric alert rules
foreach ($bastionResource in $bastionResources)
{
    # Create the metric alert condition
    $condition = New-AzMetricAlertRuleV2Criteria -MetricNamespace "microsoft.network/bastionhosts" -MetricName "pingmesh" -TimeAggregation "Average" -Operator "LessThan" -Threshold 1
    # Define alert rule name based on the Bastions name
    $alertRuleName = "$alertRuleNamePrefix-$($bastionResource.Name)"
    # Create the alert rule
    Add-AzMetricAlertRuleV2 -Name $alertRuleName -ResourceGroupName $Parameters.resourceGroupName -WindowSize 00:05:00 -Frequency 00:05:00 -TargetResourceId $bastionResource.Id -Condition $condition -ActionGroupId $Parameters.actionGroupId -Severity 2 -Description "Client Name:$Customer-Refers to the status of the Bastion communication: The communication status shows 1 if the communication is good and 0 if it is bad on $($bastionResource.Name)"
}