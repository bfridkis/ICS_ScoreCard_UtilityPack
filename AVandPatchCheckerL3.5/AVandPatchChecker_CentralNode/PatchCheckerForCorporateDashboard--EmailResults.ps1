Clear-Host

Write-Output "`n`t*^*!*^ PatchCheckerForCorporateDashboard *^*!*^`n"


$PatchCheckerForCorporateDashboardOutputFileNameEES = "E:\AVandPatchChecker_CentralNode\PatchCheckerForCorporateDashboardOutput_$(if ((Get-Date).Month -eq 1) { "12_$((Get-Date).Year)" } else { "$($(Get-Date).Month - 1)_$((Get-Date).Year)" })-PCNEES01.csv"
$PatchCheckerForCorporateDashboardOutputFileNameRES = "E:\AVandPatchChecker_CentralNode\PatchCheckerForCorporateDashboardOutput_$(if ((Get-Date).Month -eq 1) { "12_$((Get-Date).Year)" } else { "$($(Get-Date).Month - 1)_$((Get-Date).Year)" })-PCNRES01.csv"
$PatchCheckerForCorporateDashboardOutputFileNameRDP = "E:\AVandPatchChecker_CentralNode\PatchCheckerForCorporateDashboardOutput_$(if ((Get-Date).Month -eq 1) { "12_$((Get-Date).Year)" } else { "$($(Get-Date).Month - 1)_$((Get-Date).Year)" })-PCNRDP01.csv"


$PatchCheckerForCorporateDashboardResults = "E:\AVandPatchChecker_CentralNode\PatchCheckerForCorporateDashboardOutput-$(if ((Get-Date).Month -eq 1) { "12_$((Get-Date).Year)" } else { "$($(Get-Date).Month - 1)_$((Get-Date).Year)" }).csv"

#Add-Content -Path $PatchCheckerForCorporateDashboardResults -Value "** Patch Checker Results **"
Get-Content -Path $PatchCheckerForCorporateDashboardOutputFileNameEES -TotalCount 2 | Add-Content $PatchCheckerForCorporateDashboardResults
#Get-Content -Path $PatchCheckerForCorporateDashboardOutputFileNameRES -Tail 1 | Add-Content $PatchCheckerForCorporateDashboardResults3dot5
(Get-Content -Path $PatchCheckerForCorporateDashboardOutputFileNameRES -TotalCount 2)[-1] | Add-Content $PatchCheckerForCorporateDashboardResults
#Get-Content -Path $PatchCheckerForCorporateDashboardOutputFileNameRDP -Tail 1 | Add-Content $PatchCheckerForCorporateDashboardResults3dot5
(Get-Content -Path $PatchCheckerForCorporateDashboardOutputFileNameRDP -TotalCount 2)[-1] | Add-Content $PatchCheckerForCorporateDashboardResults

$L3PatchCheckerForCorporateDashboardOutputFile = "\\PCNSMS04\e$\PatchCheckerForCorporateDashboard\PatchCheckerOutput_CorporateDashboard_$(if ((Get-Date).Month -eq 1) { "12_$((Get-Date).Year)" } else { "$($(Get-Date).Month - 1)_$((Get-Date).Year)" }).csv"

Get-Content -Path $L3PatchCheckerForCorporateDashboardOutputFile | Select-Object -Skip 1 | Add-Content $PatchCheckerForCorporateDashboardResults

Send-MailMessage -From PCNSMS03@wmgpcn.local -To ben.j.fridkis@p66.com -Subject "PatchCheckerOutput_CorporateDashboard-$(if ((Get-Date).Month -eq 1) { "12_$((Get-Date).Year)" } else { "$($(Get-Date).Month - 1)_$((Get-Date).Year)" })"  `
     -Attachments $PatchCheckerForCorporateDashboardResults -SmtpServer 164.123.219.98

Remove-Item E:\AVandPatchChecker_CentralNode\PatchCheckerForCorporateDashboardOutput_*
