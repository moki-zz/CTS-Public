param (
    [string]$ResourceGroup,
    [string]$location,
    [string]$WorkspaceName1,
    [string]$ClNm,
    [string]$SubNm,
    [string]$WorkspaceFullName1
)

# Concatenate the workspace name with additional values
$WorkspaceFullName1 = "$WorkspaceName1"

# Create the workspace
New-AzOperationalInsightsWorkspace -Location $Location -Name $WorkspaceFullName1 -Sku PerGB2018 -ResourceGroupName $ResourceGroup





