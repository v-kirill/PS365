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

#Setup the context
$Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
$Ctx.Credentials = $Cred
         
#Get the List and list fields
$List = $Ctx.Web.Lists.GetByTitle($ListName)
$Ctx.Load($List)
 
#sharepoint online powershell get list columns
$Ctx.Load($List.Fields)
$Ctx.ExecuteQuery()
         
#Iterate through each field in the list
Foreach ($Field in $List.Fields)
{  
    #Skip System Fields
    if(($Field.ReadOnlyField -eq $False) -and ($Field.Hidden -eq $False))
    {
       #get internal name of sharepoint online list column powershell
       Write-Host $Field.Title: $Field.InternalName
    }
}