param (
    [string]$ParameterFile = "C:\samples\AT\FWAlerts\FWAlert-Par.json"
)

# Load parameters from the parameter file
$Parameters = Get-Content $ParameterFile | ConvertFrom-Json

# Define variables
$alertRuleNamePrefix = "Firewall - HealthState - azm "
$Customer = $Parameters.ClNm

# Get all Azure Firewalls in the subscription
$azureFirewalls = Get-AzFirewall | Where-Object { $_.Tags[$Parameters.tagKey] -eq $Parameters.tagValue }

# Loop through Firewalls and create metric alert rules
foreach ($azureFirewall in $azureFirewalls)
{
    # Create the metric alert condition for Health State
    $condition = New-AzMetricAlertRuleV2Criteria -MetricName "FirewallHealth" -TimeAggregation "average" -Operator "LessThan" -Threshold 80  
    
    # Define alert rule name based on the Azure Firewall name
    $alertRuleName = "$alertRuleNamePrefix-$($azureFirewall.Name)"

    # Create the alert rule
    Add-AzMetricAlertRuleV2 -Name $alertRuleName -ResourceGroupName $Parameters.resourceGroupName -WindowSize 00:05:00 -Frequency 00:05:00 -TargetResourceId $azureFirewall.Id -Condition $condition -ActionGroupId $Parameters.actionGroupId -Severity 4 -Description "Client Name:$Customer-Refers to the health state for Azure Firewall on $($azureFirewall.Name)"
}