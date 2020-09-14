Clear-Host

Write-Output "`n`t`t`t`t`t*^*!*% ICS Scorecard Utility Pack *^*!*% "

$stalePasswordCheckerJob = Start-Job { 
                                        C:\Users\admbfridkis\desktop\customtools\StalePasswordCheckerV1.3.ps1 -CheckComplianceAsOfDate Today `
                                        -OutputMode 1 -OutputFile "C:\Users\admbfridkis\desktop\customtools\StalePasswordCheckerOutput_$(if ((Get-Date).Month -eq 1) { "12_$((Get-Date).Year)" } else { "$($(Get-Date).Month - 1)_$((Get-Date).Year)" })" `
                                        -CheckComplianceAsOfDate Today -OUSpecific N -SearchLevel 2 
                                     } -Name StalePasswordCheckerJob
$serviceCheckerJob = Start-Job { 
                                  C:\Users\admbfridkis\desktop\customtools\ServiceCheckerV1.1.ps1 -Services 'SEPMasterService' -CheckAllNodes `
                                  -OutputMode 1 -OutputFile "C:\Users\admbfridkis\desktop\customtools\ServiceCheckerOutput_$(if ((Get-Date).Month -eq 1) { "12_$((Get-Date).Year)" } else { "$($(Get-Date).Month - 1)_$((Get-Date).Year)" })"  `
                                  -GroupByMachine "N"
                               } -Name ServiceCheckerJob
$patchCheckerJob = Start-Job {  
                                C:\Users\admbfridkis\desktop\customtools\PatchCheckerV2.4.ps1 -Option 3 `
                                -AllNodes TRUE -OutputMode 1 `
                                -OutputFile "C:\Users\admbfridkis\desktop\customtools\PatchCheckerOutput_$(if ((Get-Date).Month -eq 1) { "12_$((Get-Date).Year)" } else { "$($(Get-Date).Month - 1)_$((Get-Date).Year)" })" `
                                -CheckComplianceAsOfDate Today
                             } -Name PatchCheckerJob


Write-Output "`nWaiting for PatchChecker, StalePasswordChecker, and ServiceCheckerJobs..."
$finishedJobs = New-Object System.Collections.Generic.List[System.Object]
$finishedJobs.Add($(Wait-Job -Id $stalePasswordCheckerJob.Id))
$finishedJobs.Add($(Wait-Job -Id $serviceCheckerJob.Id))
$finishedJobs.Add($(Wait-Job -Id $patchCheckerJob.Id))
$finishedJobs | Format-Table -AutoSize

$patcheckerOutputFileName = "C:\Users\admbfridkis\desktop\customtools\PatchCheckerOutput_$(if ((Get-Date).Month -eq 1) { "12_$((Get-Date).Year)" } else { "$($(Get-Date).Month - 1)_$((Get-Date).Year)" }).csv"
$stalePasswordCheckerOutputFileName = "C:\Users\admbfridkis\desktop\customtools\StalePasswordCheckerOutput_$(if ((Get-Date).Month -eq 1) { "12_$((Get-Date).Year)" } else { "$($(Get-Date).Month - 1)_$((Get-Date).Year)" }).csv"
$serviceCheckerOutputFileName = "C:\Users\admbfridkis\desktop\customtools\ServiceCheckerOutput_$(if ((Get-Date).Month -eq 1) { "12_$((Get-Date).Year)" } else { "$($(Get-Date).Month - 1)_$((Get-Date).Year)" }).csv"

if (Test-Path -Path "$($patcheckerOutputFileName)_ERRORS.csv") {
    Send-MailMessage -From PCNSMS04@wmgpcn.local -To ben.j.fridkis@p66.com -Subject "ICS_ScoreCard_UtilityPack_Results_$(if ((Get-Date).Month -eq 1) { "12_$((Get-Date).Year)" } else { "$($(Get-Date).Month - 1)_$((Get-Date).Year)" })"  `
                     -Attachments $patcheckerOutputFileName, "$($patcheckerOutputFileName)_ERRORS.csv", $stalePasswordCheckerOutputFileName, $serviceCheckerOutputFileName -SmtpServer 164.123.219.98
}
else {
    Send-MailMessage -From PCNSMS04@wmgpcn.local -To ben.j.fridkis@p66.com -Subject "ICS_ScoreCard_UtilityPack_Results_$(if ((Get-Date).Month -eq 1) { "12_$((Get-Date).Year)" } else { "$($(Get-Date).Month - 1)_$((Get-Date).Year)" })"  `
                     -Attachments $patcheckerOutputFileName, $stalePasswordCheckerOutputFileName, $serviceCheckerOutputFileName -SmtpServer 164.123.219.98
}