param (
    [string]$ParameterFile = "C:\samples\AT\SQLAlerts\SQLAlert-Par.json"
)

# Load parameters from the parameter file
$Parameters = Get-Content $ParameterFile | ConvertFrom-Json

# Define variables
$alertRuleNamePrefix = "SQL Database - Workers Percent - azm "
$Customer = $Parameters.ClNm

# Get all Azure SQL Databases in the subscription
$sqlDatabases = Get-AzSqlDatabaseServer | Where-Object { $_.Tags[$Parameters.tagKey] -eq $Parameters.tagValue }

# Loop through SQL Databases and create metric alert rules
foreach ($sqlDatabase in $sqlDatabases)
{
    # Create the metric alert condition for BlockedByFireWall
    $condition = New-AzMetricAlertRuleV2Criteria -MetricName "workers_percent" -TimeAggregation "average" -Operator "GreaterThan" -Threshold 95
    
    # Define alert rule name based on the SQL Database name
    $alertRuleName = "$alertRuleNamePrefix-$($sqlDatabase.ServerName)"

    # Create the alert rule
    Add-AzMetricAlertRuleV2 -Name $alertRuleName -ResourceGroupName $Parameters.resourceGroupName -WindowSize 00:05:00 -Frequency 00:01:00 -TargetResourceId $sqlDatabase.Id -Condition $condition -ActionGroupId $Parameters.actionGroupId -Severity 4 -Description "Client Name:$Customer-Refers to the percentage of available worker threads being used by your database at a given point in time on $($sqlDatabase.ServerName)"
}
