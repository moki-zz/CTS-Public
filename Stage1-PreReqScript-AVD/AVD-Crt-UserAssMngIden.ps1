
# Replace these placeholder values with your actual information
$resourceGroupName = "AZM-SNow"
$identityName = "AZM-SNow-Indentity-AVD-Master"
$location = "East US"  # Add the location parameter

# Create a user-assigned managed identity
New-AzUserAssignedIdentity -ResourceGroupName $resourceGroupName -Name $identityName -Location $location

