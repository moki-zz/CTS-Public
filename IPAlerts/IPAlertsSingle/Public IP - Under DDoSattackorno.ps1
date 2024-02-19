param (
    [string]$ParameterFile = "C:\samples\AT\IPAlerts\IPAlert-Par.json"
)

# Load parameters from the parameter file
$Parameters = Get-Content $ParameterFile | ConvertFrom-Json

# Define variables
$alertRuleNamePrefix = "Public IP - Under DDoSattackorno - azm "
$Customer = $Parameters.ClNm

# Filter resources of type Microsoft.Network/publicIPAddresses
$bro1 = Get-AzResource | Where-Object { $_.ResourceType -eq "Microsoft.Network/publicIPAddresses" }

# Get all Public IP Addresses in the subscription
$publicIPAddresses = $bro1 | Where-Object { $_.Tags[$Parameters.tagKey] -eq $Parameters.tagValue }

foreach ($publicIPAddress in $publicIPAddresses)
{
    # Create the metric alert condition for Public IP Address under DDoS Attack
    $condition = New-AzMetricAlertRuleV2Criteria -MetricName "IfUnderDDoSAttack" -TimeAggregation "count" -Operator "GreaterThan" -Threshold 0
    # Define alert rule name based on the Public IP Address name
    $alertRuleName = "$alertRuleNamePrefix-$($publicIPAddress.Name)"
    # Create the alert rule
    Add-AzMetricAlertRuleV2 -Name $alertRuleName -ResourceGroupName $Parameters.resourceGroupName -WindowSize 00:05:00 -Frequency 00:05:00 -TargetResourceId $publicIPAddress.Id -Condition $condition -ActionGroupId $Parameters.actionGroupId -Severity 4 -Description "Client Name:$Customer-Refers to a situation in which a publicly accessible IP address, such as an IP address associated with a web server, network device, or any online service, is targeted by a Distributed Denial of Service (DDoS) attack on $($publicIPAddress.Name)"
}
