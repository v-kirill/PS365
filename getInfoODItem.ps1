param
(
    [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)] 
    [string]$webUrl,

    [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)] 
    [string]$listUrl,

    [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)] 
    [PSCredential]$Credential

)


Connect-PnPOnline -Url $webUrl -Credentials $Credential
$list = Get-PNPList -Identity $listUrl
Get-PnPListItem -List $list 
$file = (Get-PnPListItem -List $list).FieldValues | where -Property "FileRef" -eq "/personal/name_onmicrosoft_com/Documents/Documents/file.name"
$file