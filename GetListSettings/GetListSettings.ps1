param
(
    [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)] 
    [string]$SiteURL,

    [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)] 
    [string]$ListName,

    [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)] 
    [PSCredential]$Credential
)

#Load SharePoint CSOM Assemblies
$curDir = (Get-Location).path
$client = "Microsoft.SharePoint.Client.dll"
$runtime = "Microsoft.SharePoint.Client.Runtime.dll"
$filebase1 = Join-Path $curDir $client
$filebase2 = Join-Path $curDir $runtime
Add-Type -Path $filebase1 
Add-Type -Path $filebase2 


#Setup Credentials to connect
$Cred = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Credential.UserName,$Credential.Password)
  
Try {
    #Setup the context
    $Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
    $Ctx.Credentials = $Cred
    
    #Get the List
    $List=$Ctx.Web.Lists.GetByTitle($ListName)
    $Ctx.Load($List)
    $Ctx.ExecuteQuery()
   
    #Get List Properties: Title, Description
    Write-host -f Yellow "---  General Settings ---"
    Write-host "List Title:" $List.Title
    Write-host "List Description:" $List.Description
    Write-host "Show in Quick Launch:" $List.OnQuickLaunch
 
    Write-host -f Yellow "--- Versioning settings ---"
    Write-host "Content Approval Enabled:" $List.EnableModeration
    Write-host "Versioning Enabled:" $List.EnableVersioning
    Write-host "Major Versions Limit:" $List.MajorVersionLimit
    Write-host "Minor Versions Enabled:" $List.EnableMinorVersions
    Write-host "Minor Versions Limit:" $List.MajorWithMinorVersionsLimit       
    Write-host "Draft Versions Security:" $List.DraftVersionVisibility
    Write-host "Require Checkout:" $List.ForceCheckout  #In Document Libraries
 
    Write-host -f Yellow "--- Advanced settings ---"
    Write-host "Content Type Enabled:"$List.ContentTypesEnabled
    Write-host "Attachments Enabled:"$List.EnableAttachments
    Write-host "New Folders Command Available:"$List.EnableFolderCreation
    Write-host "No Crawl Flag:"$List.NoCrawl
    Write-host "Offline Availability:"$List.ExcludeFromOfflineClient
    Write-host "List Experience:"$List.ListExperienceOptions
    Write-host "List Schema Xml:"$List.SchemaXml
    Write-host "Base Template:"$List.BaseTemplate
    Write-host "Base Type:"$List.BaseType
    Write-host "Is it Private List?"$List.IsPrivate
    Write-host "Is it System List?"$List.IsSystemList
     
    #Other hidden Settings
    Write-host -f Yellow "--- Other settings ---"
    Write-host "List ID:"$List.ID
    Write-host "List Created On:"$List.Created
    Write-host "Last Item Deleted On:"$List.LastItemDeletedDate
    Write-host "Last Item Modified On:"$List.LastItemModifiedDate
    Write-host "List Item Count:"$List.ItemCount
    Write-host "Is Hidden List:"$List.Hidden
    Write-host "Document Template:"$List.DocumentTemplateUrl #In Document Libraries
    Write-host "List Type:"$List.BaseType  	
}
Catch {
    write-host -f Red "Error Getting List Properties!" $_.Exception.Message
}