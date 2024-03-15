param (
    [string]$subscriptionId,
    [string]$userAssignedIdentityResourceId,
    [string]$tagKey,
    [string]$tagValue
)

# Get resources of specific type across the entire subscription
$resourcesOfType = Get-AzResource | Where-Object { $_.ResourceType -eq "Microsoft.Compute/virtualMachines"}

# Filter resources by tag
$virtualMachinesWithTag = $resourcesOfType | Where-Object { $_.Tags[$tagKey] -eq $tagValue }

# Iterate over each VM and check if Azure Monitor Agent extension is installed
foreach ($vm in $virtualMachinesWithTag) {
    $vmName = $vm.Name
    $resourceGroupName = $vm.ResourceGroupName
    $location = $vm.Location

    # Check if the VM is a Linux VM
    $vmOS = (Get-AzVM -ResourceGroupName $resourceGroupName -Name $vmName).StorageProfile.OsDisk.OsType
    if ($vmOS -eq "Linux") {
        # Check if the Azure Monitor Agent extension is already installed
        $extension = Get-AzVMExtension -ResourceGroupName $resourceGroupName -VMName $vmName -Name "AzureMonitorLinuxAgent"
        if (-not $extension) {
            # If the extension is not installed, proceed with installation
            Set-AzVMExtension -ResourceGroupName $resourceGroupName -VMName $vmName -Location $location -Name AzureMonitorLinuxAgent -Publisher Microsoft.Azure.Monitor -ExtensionType AzureMonitorLinuxAgent -TypeHandlerVersion "1.0" -EnableAutomaticUpgrade $true -SettingString ('{{"authentication":{{"managedIdentity":{{"identifier-value":"mi_res_id","identifier-name":"mi_res_id","identifier-assignment":"{0}"}}}}}}' -f $userAssignedIdentityResourceId)
        }
        else {
            Write-Output "Azure Monitor Agent is already installed on VM $vmName. Skipping installation."
        }
    }
}
