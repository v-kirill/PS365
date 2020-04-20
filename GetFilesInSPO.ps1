param
(
    [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)] 
    [string]$Site,

    [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)] 
    [PSCredential]$Credential
)

[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Ssl3 -bor [System.Net.SecurityProtocolType]::Tls -bor [System.Net.SecurityProtocolType]::Tls11 -bor [System.Net.SecurityProtocolType]::Tls12

if ((Get-Module SharePointPnPPowerShellOnline).Count -eq 0) {
    Write-Host 'Checking PowerShell vesion'
    $psver = (Get-Host).Version
    if ($psver -like "5*"){
        Write-Host 'Installing and importing SharePointPnPPowerShellOnline module'
        Install-Module SharePointPnPPowerShellOnline
        Import-Module SharePointPnPPowerShellOnline -DisableNameChecking

        # Install-Module SharePointPnPPowerShellOnline
        Connect-PnPOnline -Url $Site -Credentials $Credential

        #Output path
        $outputPath = "C:\users\$env:USERNAME\Desktop\specificFiles.csv"

        #Store in variable all the document libraries in the site
        $DocLibs = Get-PnPList | Where-Object {$_.BaseTemplate -eq 101} 

        #Loop thru each document library & folders
        $results = @()
        foreach ($DocLib in $DocLibs) {
            $AllItems = Get-PnPListItem -List $DocLib -Fields "FileRef", "File_x0020_Type", "FileLeafRef"
            # write-host $AllItems
            #Loop through each item
            foreach ($Item in $AllItems) {
                    Write-Host "File found. Path:" $Item["FileRef"] -ForegroundColor Green
            
                    #Creating new object to export in .csv file
                    $results += New-Object PSObject -Property @{
                        Path          = $Item["FileRef"]
                        FileName      = $Item["FileLeafRef"]
                        FileExtension = $Item["File_x0020_Type"]
                    }
            }
        }
        $results | Export-Csv -Path $outputPath -NoTypeInformation
        Disconnect-PnPOnline
    }
    else {
        Write-Host "PowerShell version" $psver "is found. Please install Windows Management Framework 5.1:"
        Write-Host "https://www.microsoft.com/en-us/download/details.aspx?id=54616" -ForegroundColor DarkYellow
        break
        }
}