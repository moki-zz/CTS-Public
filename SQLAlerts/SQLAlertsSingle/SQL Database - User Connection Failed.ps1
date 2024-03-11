param (
    [string]$ParameterFile = "C:\samples\AT\SQLAlerts\SQLAlert-Par.json"
)

# Load parameters from the parameter file
$Parameters = Get-Content $ParameterFile | ConvertFrom-Json

# Define variables
$alertRuleNamePrefix = "SQL Database - User Connection Failed - azm "
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
        # Create the metric alert condition for connection_failed_user_error
    $condition = New-AzMetricAlertRuleV2Criteria -MetricName "connection_failed_user_error" -TimeAggregation "Total" -Operator "GreaterThan" -Threshold 0
    
    # Define alert rule name based on the SQL Database name
    $alertRuleName = "$alertRuleNamePrefix-$($db.DatabaseName)"

    # Create the alert rule
    Add-AzMetricAlertRuleV2 -Name $alertRuleName -ResourceGroupName $Parameters.resourceGroupName -WindowSize 00:05:00 -Frequency 00:01:00 -TargetResourceId $db.ResourceId -Condition $condition -ActionGroupId $Parameters.actionGroupId -Severity 4 -Description "Client Name:$Customer-Refers to database connectivity and user connection failures on $($serverName)"
    }
}