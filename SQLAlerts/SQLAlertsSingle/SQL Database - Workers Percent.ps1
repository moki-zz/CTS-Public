param (
    [string]$ParameterFile = "C:\samples\AT\SQLAlerts\SQLAlert-Par.json"
)

# Load parameters from the parameter file
$Parameters = Get-Content $ParameterFile | ConvertFrom-Json

# Define variables
$alertRuleNamePrefix = "SQL Database - Workers Percent - azm "
$Customer = $Parameters.ClNm

# Get all SQL servers in the subscription
$servers = Get-AzSqlServer | Where-Object { $_.Tags[$Parameters.tagKey] -eq $Parameters.tagValue }

# Loop through each SQL server
foreach ($server in $servers) {
    $resourceGroupName = $server.ResourceGroupName
    $serverName = $server.ServerName

    # Get all SQL databases from the current Azure SQL Server
    $databases = Get-AzSqlDatabase -ResourceGroupName $resourceGroupName -ServerName $serverName

    # Output information about each database
    foreach ($db in $databases) {
        # Create the metric alert condition for workers_percent
    $condition = New-AzMetricAlertRuleV2Criteria -MetricName "workers_percent" -TimeAggregation "average" -Operator "GreaterThan" -Threshold 95
    
    # Define alert rule name based on the SQL Database name
    $alertRuleName = "$alertRuleNamePrefix-$($db.DatabaseName)"

    # Create the alert rule
    Add-AzMetricAlertRuleV2 -Name $alertRuleName -ResourceGroupName $Parameters.resourceGroupName -WindowSize 00:05:00 -Frequency 00:01:00 -TargetResourceId $db.ResourceId -Condition $condition -ActionGroupId $Parameters.actionGroupId -Severity 4 -Description "Client Name:$Customer-Refers to the percentage of available worker threads being used by your database at a given point in time on $($serverName)"
    }
}