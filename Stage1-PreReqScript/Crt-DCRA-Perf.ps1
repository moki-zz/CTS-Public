# DCR-Association.ps1

param (
    [string]$ResourceGroup,
    [string]$dcrName,
    [string]$SubscriptionId,
    [string]$tagKey,
    [string]$tagValue
)

# Get virtual machines by a specific tag
$virtualMachinesWithTag = Get-AzResource | Where-Object { $_.ResourceType -eq "Microsoft.Compute/virtualMachines" -and $_.Tags[$tagKey] -eq $tagValue }

# Iterate through each virtual machine and associate the DCR
foreach ($vm in $virtualMachinesWithTag) {
    $vmId = $vm.Id
    $dcrAssocName = "dcrAssoc-perf-$($vm.Name)"

    # Get the DCR if you haven't already
    if (-not $dcr) {
        $dcr = Get-AzDataCollectionRule -ResourceGroupName $ResourceGroup -RuleName $dcrName
    }

    # Associate the DCR with the VM
    New-AzDataCollectionRuleAssociation -TargetResourceId $vmId -AssociationName $dcrAssocName -RuleId $dcr.Id
}
