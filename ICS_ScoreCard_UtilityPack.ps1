Clear-Host

Write-Output "`n`t`t`t`t`t*^*!*% ICS Scorecard Utility Pack *^*!*% "

$stalePasswordCheckerJob = Start-Job { 
                                        E:\ICSScoreCardUtilityPack\StalePasswordCheckerV1.3.ps1 -CheckComplianceAsOfDate Today `
                                        -OutputMode 1 -OutputFile "E:\ICSScoreCardUtilityPack\Results\StalePasswordCheckerOutput_$(if ((Get-Date).Month -eq 1) { "12_$((Get-Date).Year)" } else { "$($(Get-Date).Month - 1)_$((Get-Date).Year)" })" `
                                        -CheckComplianceAsOfDate Today -OUSpecific N -SearchLevel 2 
                                     } -Name StalePasswordCheckerJob
$serviceAndProcessCheckerJob = Start-Job { 
                                  E:\ICSScoreCardUtilityPack\ServiceAndProcessCheckerV1.0.ps1 -Services 'SEPMasterService McShield' -CheckAllNodes `
                                  -OutputMode 1 -OutputFile "E:\ICSScoreCardUtilityPack\Results\ServiceCheckerOutput_$(if ((Get-Date).Month -eq 1) { "12_$((Get-Date).Year)" } else { "$($(Get-Date).Month - 1)_$((Get-Date).Year)" })"  `
                                  -GroupByMachine "N"
                               } -Name ServiceAndProcessCheckerJob
$patchCheckerJob = Start-Job {  
                                E:\ICSScoreCardUtilityPack\PatchCheckerV2.5.ps1 -Option 3 `
                                -AllNodes TRUE -OutputMode 1 `
                                -OutputFile "E:\ICSScoreCardUtilityPack\Results\PatchCheckerOutput_$(if ((Get-Date).Month -eq 1) { "12_$((Get-Date).Year)" } else { "$($(Get-Date).Month - 1)_$((Get-Date).Year)" })" `
                                -CheckComplianceAsOfDate Today
                             } -Name PatchCheckerJob


Write-Output "`nWaiting for PatchChecker, StalePasswordChecker, and ServiceCheckerJobs..."
$finishedJobs = New-Object System.Collections.Generic.List[System.Object]
$finishedJobs.Add($(Wait-Job -Id $stalePasswordCheckerJob.Id))
$finishedJobs.Add($(Wait-Job -Id $serviceAndProcessCheckerJob.Id))
$finishedJobs.Add($(Wait-Job -Id $patchCheckerJob.Id))
$finishedJobs | Format-Table -AutoSize

$patcheckerOutputFileName = "E:\ICSScoreCardUtilityPack\Results\PatchCheckerOutput_$(if ((Get-Date).Month -eq 1) { "12_$((Get-Date).Year - 1)" } else { "$($(Get-Date).Month - 1)_$((Get-Date).Year)" })"
$stalePasswordCheckerOutputFileName = "E:\ICSScoreCardUtilityPack\Results\StalePasswordCheckerOutput_$(if ((Get-Date).Month -eq 1) { "12_$((Get-Date).Year - 1)" } else { "$($(Get-Date).Month - 1)_$((Get-Date).Year)" }).csv"
$serviceAndProcessCheckerOutputFileName = "E:\ICSScoreCardUtilityPack\Results\ServiceAndProcessCheckerOutput_$(if ((Get-Date).Month -eq 1) { "12_$((Get-Date).Year - 1)" } else { "$($(Get-Date).Month - 1)_$((Get-Date).Year)" }).csv"

Send-MailMessage -From PCNSMS04@wmgpcn.local -To ben.j.fridkis@p66.com -Subject "ICS_ScoreCard_UtilityPack_Results_$(if ((Get-Date).Month -eq 1) { "12_$((Get-Date).Year - 1)" } else { "$($(Get-Date).Month - 1)_$((Get-Date).Year)" })"  `
                 -Attachments "$patcheckerOutputFileName.csv", $stalePasswordCheckerOutputFileName, $serviceAndProcessCheckerOutputFileName -SmtpServer 10.100.95.35