param
(
    [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)] 
    [string]$VBOjob
)

[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Ssl3 -bor [System.Net.SecurityProtocolType]::Tls -bor [System.Net.SecurityProtocolType]::Tls11 -bor [System.Net.SecurityProtocolType]::Tls12
$job = Get-VBOJob -Name $VBOjob
$sessions = Get-VBOJobSession -Job $job
$nl = [Environment]::NewLine
foreach ($session in $sessions){
    $StartDate = $session.CreationTime
    $EndDate = $session.EndTime
    $status = $session.Status
    $timespan = New-TimeSpan -Start $StartDate -End $EndDate
    $duration = @{
        Days = $timespan.Days
        Hours = $timespan.Hours
        Minutes = $timespan.Minutes 
    }
    $transferred = $session.Statistics.TransferredData
    if (($duration.Hours -eq 0) -and ($duration.Days -eq 0) ){
        'JobName: {0}, Created: {1}. Duration: {2} minute(s).' -f 
        $session.JobName, 
        $session.CreationTime, 
        $duration.Minutes 
        'Transferred: {0}. Status: {1}' -f $transferred, $status
        $nl
        }
    elseif ($duration.Days -eq 0){
        'JobName: {0}, Created: {1}. Duration: {2} hours and {3} minute(s).' -f 
        $session.JobName, 
        $session.CreationTime, 
        $duration.Hours, 
        $duration.Minutes
        'Transferred: {0}. Status: {1}' -f $transferred, $status
        $nl
        }
    else {
        'JobName: {0}, Created: {1}. Duration: {2} days, {3} hours and {4} minute(s).' -f 
        $session.JobName, 
        $session.CreationTime, 
        $duration.Days, 
        $duration.Hours, 
        $duration.Minutes
        'Transferred: {0}. Status: {1}' -f $transferred, $status
        $nl
        }
}