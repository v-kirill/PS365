param
(
    [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)] 
    [string]$siteURL,

    [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)] 
    [string]$listName,

    [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)] 
    [PSCredential]$Credential,

    [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)] 
    [string]$outputPath
)
      
# Connect to SharePoint Online site  
Connect-PnPOnline -Url $siteURL -Credentials $Credential
      
# Get the list items  
$itemColl=Get-PnPListItem -List $listName  
      
# Get the context  
$context=Get-PnPContext  

$results = @()
# Loop through the items  
foreach($item in $itemColl)  
{     
        # Get the item Versions  
        $versionColl=$item.Versions;  
        $context.Load($versionColl);      
        $context.ExecuteQuery();  
        $results += New-Object PSObject -Property @{
                VersionCount  = $item.Versions.Count
                Path          = $Item["FileRef"]          
                }    

        Write-Host -ForegroundColor Yellow $item["Title"] "Processed"  
    } 
$results | Out-File $outputPath
