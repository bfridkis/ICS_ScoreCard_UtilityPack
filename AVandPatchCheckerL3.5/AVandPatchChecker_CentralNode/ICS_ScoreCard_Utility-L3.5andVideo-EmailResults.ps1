Clear-Host

Write-Output "`n`t*^*!*% ICS Scorecard Utility - AVandPatchChecker Only (L3.5 & Video) *^*!*% "


$AVandPatchCheckerOutputFileNameEES = "E:\AVandPatchChecker_CentralNode\AVandPatchCheckerOutput_$(if ((Get-Date).Month -eq 1) { "12_$((Get-Date).Year)" } else { "$($(Get-Date).Month - 1)_$((Get-Date).Year)" })-PCNEES01.csv"
$AVandPatchCheckerOutputFileNameRES = "E:\AVandPatchChecker_CentralNode\AVandPatchCheckerOutput_$(if ((Get-Date).Month -eq 1) { "12_$((Get-Date).Year)" } else { "$($(Get-Date).Month - 1)_$((Get-Date).Year)" })-PCNRES01.csv"
$AVandPatchCheckerOutputFileNameRDP = "E:\AVandPatchChecker_CentralNode\AVandPatchCheckerOutput_$(if ((Get-Date).Month -eq 1) { "12_$((Get-Date).Year)" } else { "$($(Get-Date).Month - 1)_$((Get-Date).Year)" })-PCNRDP01.csv"
$AVandPatchCheckerOutputFileNameVIDSVR = "\\PCNGAS01\E$\AVandPatchChecker_CentralNode\AVandPatchCheckerOutput_$(if ((Get-Date).Month -eq 1) { "12_$((Get-Date).Year)" } else { "$($(Get-Date).Month - 1)_$((Get-Date).Year)" })-VIDCCRSVR01.csv"
$AVandPatchCheckerOutputFileNameVIDWK = "\\PCNGAS01\E$\AVandPatchChecker_CentralNode\AVandPatchCheckerOutput_$(if ((Get-Date).Month -eq 1) { "12_$((Get-Date).Year)" } else { "$($(Get-Date).Month - 1)_$((Get-Date).Year)" })-VIDCCRWK01.csv"

$AVandPatchCheckerResults3dot5andVideo = "E:\AVandPatchChecker_CentralNode\AVandPatchCheckerOutputL3.5andVideo_$(if ((Get-Date).Month -eq 1) { "12_$((Get-Date).Year)" } else { "$($(Get-Date).Month - 1)_$((Get-Date).Year)" }).csv"

Add-Content -Path $AVandPatchCheckerResults3dot5andVideo -Value "** Patch Checker Results **"
Get-Content -Path $AVandPatchCheckerOutputFileNameEES -TotalCount 2 | Add-Content $AVandPatchCheckerResults3dot5andVideo
(Get-Content -Path $AVandPatchCheckerOutputFileNameRES -TotalCount 2)[-1] | Add-Content $AVandPatchCheckerResults3dot5andVideo
(Get-Content -Path $AVandPatchCheckerOutputFileNameRDP -TotalCount 2)[-1] | Add-Content $AVandPatchCheckerResults3dot5andVideo
(Get-Content -Path $AVandPatchCheckerOutputFileNameVIDSVR -TotalCount 2)[-1] | Add-Content $AVandPatchCheckerResults3dot5andVideo
(Get-Content -Path $AVandPatchCheckerOutputFileNameVIDWK -TotalCount 2)[-1] | Add-Content $AVandPatchCheckerResults3dot5andVideo

Add-Content -Path $AVandPatchCheckerResults3dot5andVideo -Value "`r`n** Service (AV) Checker Results **"
(Get-Content -Path $AVandPatchCheckerOutputFileNameEES)[2..3] | Add-Content $AVandPatchCheckerResults3dot5andVideo
(Get-Content -Path $AVandPatchCheckerOutputFileNameRES)[-1] | Add-Content $AVandPatchCheckerResults3dot5andVideo
(Get-Content -Path $AVandPatchCheckerOutputFileNameRDP)[-1] | Add-Content $AVandPatchCheckerResults3dot5andVideo
(Get-Content -Path $AVandPatchCheckerOutputFileNameVIDSVR)[-1] | Add-Content $AVandPatchCheckerResults3dot5andVideo
(Get-Content -Path $AVandPatchCheckerOutputFileNameVIDWK)[-1] | Add-Content $AVandPatchCheckerResults3dot5andVideo

Send-MailMessage -From PCNSMS03@wmgpcn.local -To ben.j.fridkis@p66.com -Subject "AVandPatchCheckerResultsL3.5andVideo_$(if ((Get-Date).Month -eq 1) { "12_$((Get-Date).Year)" } else { "$($(Get-Date).Month - 1)_$((Get-Date).Year)" })"  `
     -Attachments $AVandPatchCheckerResults3dot5andVideo -SmtpServer 164.123.219.98

Remove-Item E:\AVandPatchChecker_CentralNode\AVandPatchCheckerOutput_*
Remove-Item \\PCNGAS01\E$\AVandPatchChecker_CentralNode\AVandPatchCheckerOutput_*
