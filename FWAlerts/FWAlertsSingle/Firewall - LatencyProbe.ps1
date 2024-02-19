param (
    [string]$ParameterFile = "C:\samples\AT\FWAlerts\FWAlert-Par.json"
)

# Load parameters from the parameter file
$Parameters = Get-Content $ParameterFile | ConvertFrom-Json

# Define variables
$alertRuleNamePrefix = "Firewall - LatencyProbe - azm "
$Customer = $Parameters.ClNm

# Get all Azure Firewalls in the subscription
$azureFirewalls = Get-AzFirewall | Where-Object { $_.Tags[$Parameters.tagKey] -eq $Parameters.tagValue }

# Loop through Firewalls and create metric alert rules
foreach ($azureFirewall in $azureFirewalls)
{
    # Create the metric alert condition for Health State
    $condition = New-AzMetricAlertRuleV2Criteria -MetricName "FirewallLatencyPng" -TimeAggregation "average" -Operator "GreaterThan" -Threshold 3
    
    # Define alert rule name based on the Azure Firewall name
    $alertRuleName = "$alertRuleNamePrefix-$($azureFirewall.Name)"

    # Create the alert rule
    Add-AzMetricAlertRuleV2 -Name $alertRuleName -ResourceGroupName $Parameters.resourceGroupName -WindowSize 00:05:00 -Frequency 00:05:00 -TargetResourceId $azureFirewall.Id -Condition $condition -ActionGroupId $Parameters.actionGroupId -Severity 4 -Description "Client Name:$Customer-Refers to a metric used to measure the network latency introduced by the Azure Firewall when processing network traffic on $($azureFirewall.Name)"
}