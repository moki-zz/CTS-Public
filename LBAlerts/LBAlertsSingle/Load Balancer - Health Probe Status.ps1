param (
    [string]$ParameterFile = "C:\samples\AT\LBAlerts\LBAlert-Par.json"
)

# Load parameters from the parameter file
$Parameters = Get-Content $ParameterFile | ConvertFrom-Json

# Define variables
$alertRuleNamePrefix = "Load Balancer - Health Probe Status - azm "
$Customer = $Parameters.ClNm

# Get all Load Balancers in the current resource group
$loadBalancers = Get-AzLoadBalancer | Where-Object { $_.Tags[$Parameters.tagKey] -eq $Parameters.tagValue }

# Loop through Load Balancers and create metric alert rules
    foreach ($loadBalancer in $loadBalancers)
    {
        # Create the metric alert condition for High Traffic
        $condition = New-AzMetricAlertRuleV2Criteria -MetricName "DipAvailability" -TimeAggregation "maximum" -Operator "LessThan" -Threshold 70
        # Define alert rule name based on the Load Balancer name
        $alertRuleName = "$alertRuleNamePrefix-$($loadBalancer.Name)"
        # Create the alert rule
        Add-AzMetricAlertRuleV2 -Name $alertRuleName -ResourceGroupName $Parameters.resourceGroupName -WindowSize 00:05:00 -Frequency 00:05:00 -TargetResourceId $loadBalancer.Id -Condition $condition -ActionGroupId $Parameters.actionGroupId -Severity 4 -Description "Client Name:$Customer-Refers to the current status of the health probes or health checks that the load balancer is performing on the backend resources (such as virtual machines) to determine if they are healthy and can properly handle incoming network traffic on $($loadBalancer.Name)"
    }