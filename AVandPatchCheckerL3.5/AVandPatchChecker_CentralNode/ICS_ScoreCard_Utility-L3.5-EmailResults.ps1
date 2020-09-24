Clear-Host

Write-Output "`n`t*^*!*% ICS Scorecard Utility - AVandPatchChecker Only (L3.5) *^*!*% "


$AVandPatchCheckerOutputFileNameEES = "C:\Users\admbfridkis\Desktop\AVandPatchChecker_CentralNode\AVandPatchCheckerOutput_$(if ((Get-Date).Month -eq 1) { "12_$((Get-Date).Year)" } else { "$($(Get-Date).Month - 1)_$((Get-Date).Year)" })-PCNEES01.csv"
$AVandPatchCheckerOutputFileNameRES = "C:\Users\admbfridkis\Desktop\AVandPatchChecker_CentralNode\AVandPatchCheckerOutput_$(if ((Get-Date).Month -eq 1) { "12_$((Get-Date).Year)" } else { "$($(Get-Date).Month - 1)_$((Get-Date).Year)" })-PCNRES01.csv"
$AVandPatchCheckerOutputFileNameRDP = "C:\Users\admbfridkis\Desktop\AVandPatchChecker_CentralNode\AVandPatchCheckerOutput_$(if ((Get-Date).Month -eq 1) { "12_$((Get-Date).Year)" } else { "$($(Get-Date).Month - 1)_$((Get-Date).Year)" })-PCNRDP01.csv"


$AVandPatchCheckerResults3dot5 = "C:\Users\admbfridkis\Desktop\AVandPatchChecker_CentralNode\AVandPatchCheckerOutputL3.5_$(if ((Get-Date).Month -eq 1) { "12_$((Get-Date).Year)" } else { "$($(Get-Date).Month - 1)_$((Get-Date).Year)" }).csv"

Add-Content -Path $AVandPatchCheckerResults3dot5 -Value "** Patch Checker Results **"
Get-Content -Path $AVandPatchCheckerOutputFileNameEES -TotalCount 2 | Add-Content $AVandPatchCheckerResults3dot5
#Get-Content -Path $AVandPatchCheckerOutputFileNameRES -Tail 1 | Add-Content $AVandPatchCheckerResults3dot5
(Get-Content -Path $AVandPatchCheckerOutputFileNameRES -TotalCount 2)[-1] | Add-Content $AVandPatchCheckerResults3dot5
#Get-Content -Path $AVandPatchCheckerOutputFileNameRDP -Tail 1 | Add-Content $AVandPatchCheckerResults3dot5
(Get-Content -Path $AVandPatchCheckerOutputFileNameRDP -TotalCount 2)[-1] | Add-Content $AVandPatchCheckerResults3dot5

Add-Content -Path $AVandPatchCheckerResults3dot5 -Value "`r`n** Service (AV) Checker Results **"
(Get-Content -Path $AVandPatchCheckerOutputFileNameEES)[2..3] | Add-Content $AVandPatchCheckerResults3dot5
#Get-Content -Path $AVandPatchCheckerOutputFileNameRES -Tail 1 | Add-Content $AVandPatchCheckerResults3dot5
(Get-Content -Path $AVandPatchCheckerOutputFileNameRES)[-1] | Add-Content $AVandPatchCheckerResults3dot5
#Get-Content -Path $AVandPatchCheckerOutputFileNameRDP -Tail 1 | Add-Content $AVandPatchCheckerResults3dot5
(Get-Content -Path $AVandPatchCheckerOutputFileNameRDP)[-1] | Add-Content $AVandPatchCheckerResults3dot5

Send-MailMessage -From PCNSMS03@wmgpcn.local -To ben.j.fridkis@p66.com -Subject "AVandPatchCheckerResultsL3.5_$(if ((Get-Date).Month -eq 1) { "12_$((Get-Date).Year)" } else { "$($(Get-Date).Month - 1)_$((Get-Date).Year)" })"  `
     -Attachments $AVandPatchCheckerResults3dot5 -SmtpServer 164.123.219.98

Remove-Item C:\Users\admbfridkis\Desktop\AVandPatchChecker_CentralNode\AVandPatchCheckerOUtput_*
