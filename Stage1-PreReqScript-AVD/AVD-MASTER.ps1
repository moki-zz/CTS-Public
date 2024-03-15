param (
    [string]$ParameterFile = "C:\samples\Stage1-PreReqScript-AVD\AVD-Par-file-2.json"
)

# Define the paths to your scripts
$ExtMI = "C:\samples\Stage1-PreReqScript-AVD\AVD-Crt-UserAssMngIden.ps1"
$ExtAMAW = "C:\samples\Stage1-PreReqScript-AVD\AVD-AMAWin.ps1"
$ExtLAWI = "C:\samples\Stage1-PreReqScript-AVD\AVD-Crt-LAW-Insights.ps1"
$ExtLAWP = "C:\samples\Stage1-PreReqScript-AVD\AVD-Crt-LAW-Perf.ps1"
$ExtDCRI = "C:\samples\Stage1-PreReqScript-AVD\AVD-Crt-DCR-Insights.ps1"
$ExtDCRP = "C:\samples\Stage1-PreReqScript-AVD\AVD-Crt-DCR-Perf.ps1"
$ExtDCRAI = "C:\samples\Stage1-PreReqScript-AVD\AVD-Crt-DCRA-Insights.ps1"
$ExtDCRAP = "C:\samples\Stage1-PreReqScript-AVD\AVD-Crt-DCRA-Perf.ps1"

# Load parameters from the parameter file
$Parameters = Get-Content $ParameterFile | ConvertFrom-Json

# Set the current subscription context
Set-AzContext -SubscriptionId $Parameters.subscriptionId

# Call the external script to Create Managed Identity
Write-Host "Executing AVD-Crt-UserAssMngIden.ps1..."
& $ExtMI -resourceGroupName $Parameters.RGcrt -location $Parameters.Lct

# Call the external script to install AMA Agent on Windows VMs
Write-Host "Executing AVD-AMAWin.ps1..."
& $ExtAMAW -subscriptionId $Parameters.subscriptionId -userAssignedIdentityResourceId $Parameters.userAssignedIdentityResourceId -tagKey $Parameters.tagKey -tagValue $Parameters.tagValue 

# Call the external script to create LAW-Insights
Write-Host "Executing AVD-Crt-LAW-Insights.ps1..."
& $ExtLAWI -ResourceGroup $Parameters.RGcrt -WorkspaceName $Parameters.workspaceName1 -Location $Parameters.Lct

# Call the external script to create LAW-Perf
Write-Host "Executing AVD-Crt-LAW-Perf.ps1..."
& $ExtLAWP -ResourceGroup $Parameters.RGcrt -WorkspaceName $Parameters.workspaceName -Location $Parameters.Lct

# Call the external script to create DCR-Insights
Write-Host "Executing AVD-Crt-DCR-Insights.ps1..."
& $ExtDCRI -ResourceGroup $Parameters.dataCollectionRuleResourceGroup1 -location $Parameters.dataCollectionRuleLocation1 -DCRRName1 $Parameters.dataCollectionRuleName1 -DCRRFName1 $Parameters.dataCollectionRuleFileName1 -DCRDes1 $Parameters.dataCollectionRuleDescription1

# Call the external script to create DCR-Perf
Write-Host "Executing AVD-Crt-DCR-Perf.ps1..."
& $ExtDCRP -ResourceGroup $Parameters.dataCollectionRuleResourceGroup -location $Parameters.dataCollectionRuleLocation -DCRRName $Parameters.dataCollectionRuleName -DCRRFName $Parameters.dataCollectionRuleFileName -DCRDes $Parameters.dataCollectionRuleDescription

# Call the external script to create DCR-Insights associations 
Write-Host "Executing AVD-Crt-DCRA-Insights.ps1..."
& $ExtDCRAI -ResourceGroup $Parameters.dcrResourceGroup -dcrName $Parameters.dcrName1 -dcrSubscriptionId $Parameters.dcrSubscriptionId -tagKey $Parameters.tagKey -tagValue $Parameters.tagValue

# Call the external script to create DCR-Perf associations 
Write-Host "Executing AVD-Crt-DCRA-Perf.ps1..."
& $ExtDCRAP -ResourceGroup $Parameters.dcrResourceGroup -dcrName $Parameters.dcrName -dcrSubscriptionId $Parameters.dcrSubscriptionId -tagKey $Parameters.tagKey -tagValue $Parameters.tagValue

Write-Host "Master script completed."