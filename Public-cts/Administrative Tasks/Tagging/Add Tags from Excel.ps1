# Define the path to your Excel file
$excelFilePath = "C:\Users\Nikola.Jovanovic\OneDrive - Coretek, Inc\Desktop\tryit1.xlsx"

# Load the Excel file
$excelData = Import-Excel -Path $excelFilePath

# Iterate through each row in the Excel file
foreach ($row in $excelData) {
    $RT = $row."Type" # Get the resource type from the Excel sheet
    $resourceName = $row."Name" # Assuming "Name" contains the resource name

    # Get the resource using Get-AzResource
    $resource = Get-AzResource -ResourceName $resourceName -ResourceType $RT

    if ($resource) {
        # Extract tags from the Excel columns
        $envCts = $row."env_cts"
        $businessImpactCts = $row."businessimpact_cts"
        $resourceType = $row."cts_type"

        # Define tags based on the Excel columns
        $tags = @{
            "env_cts" = $envCts
            "businessimpact_cts" = $businessImpactCts
            "cts_type" = $resourceType
        }

        # Update the tags on the resource using Update-AzTag with "merge" option
        Update-AzTag -ResourceId $resource.ResourceId -Tag $tags -Operation Merge
        Write-Host "Tags merged for resource '$resourceName' of type '$resourceType'"
    } else {
        Write-Host "Resource '$resourceName' of type '$resourceType' not found"
    }
}

