 param
(
    [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)] 
    [string]$AdminURL, 

    [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)] 
    [PSCredential]$Credential,

    [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [string]$ReportOutput
)

[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Ssl3 -bor [System.Net.SecurityProtocolType]::Tls -bor [System.Net.SecurityProtocolType]::Tls11 -bor [System.Net.SecurityProtocolType]::Tls12

# check if SPO module installed
if ((Get-Module Microsoft.Online.SharePoint.PowerShell).Count -eq 0) {
    Write-Host 'Checking PowerShell vesion'
    $psver = (Get-Host).Version
    if ($psver -like "5*"){
        Write-Host 'Installing and importing SharePointOnline module'
        Install-Module Microsoft.Online.SharePoint.PowerShell
        Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking
        }
    else {
        Write-Host "PowerShell version" $psver "is found. Please install Windows Management Framework 5.1:"
        Write-Host "https://www.microsoft.com/en-us/download/details.aspx?id=54616" -ForegroundColor DarkYellow
        break
        }
}        

#Connect to SharePoint Online
Connect-SPOService -url $AdminURL -Credential $Credential
  
# Disconnect-SPOService
#Get all Site colections
$Sites = Get-SPOSite -IncludePersonalSite $True
$SiteData = @()
     
#Get Site Collection Administrators of Each site
Foreach ($Site in $Sites)
{
Write-host -f Yellow "Processing Site Collection:"$Site.URL
      
#Get all Site Collection Administrators
$SiteAdmins = Get-SPOUser -Site $Site.Url -Limit ALL | Where { $_.IsSiteAdmin -eq $True} | Select DisplayName, LoginName
 
#Get Site Collection Details
$SiteAdmins | ForEach-Object {
$SiteData += New-Object PSObject -Property @{
    'Site Name' = $Site.Title
    'URL' = $Site.Url
    'Site Collection Admins' = $_.DisplayName + " ("+ $_.LoginName +"); "
    }
}
}
$SiteData
#Export the data to CSV
$SiteData | Export-Csv $ReportOutput -NoTypeInformation
Write-Host -f Green "Site Collection Admninistrators Data Exported to CSV!" 
