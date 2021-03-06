Clear-Host

Write-Output "`n`t*^*!*% ICS Scorecard Utility - AVandPatchChecker Only (L3.5) *^*!*% "

$outputFile = "\\PCNSMS03\e$\AVandPatchChecker_CentralNode\AVandPatchCheckerOutput_$(if ((Get-Date).Month -eq 1) { "12_$((Get-Date).Year)" } else { "$($(Get-Date).Month - 1)_$((Get-Date).Year)" })-$($env:COMPUTERNAME).csv"

$wmiHash = Get-WmiObject -Class 'Win32_QuickFixEngineering' -ErrorAction Stop
$wmiHash | Select-Object -Property Description, HotFixID, InstalledBy, InstalledOn |
	       Sort-Object InstalledOn | Select-Object -Last 1 -Property @{ n = 'Computer Name' ; e = {$env:COMPUTERNAME}},
																	 @{ n = 'Most Recent Patch' ; e = {$_.HotfixID}},
																	 @{ n = 'Installed On' ; e = {"$($_.InstalledOn.Month)/$($_.InstalledOn.Day)/$($_.InstalledOn.Year)"}}, 
																	 @{ n = 'Compliant? (Installed in Last 180 Days?)' ; e = {(Get-Date).adddays(-180) -lt $_.InstalledOn}} | 
           Export-CSV -Path $outputFile -NoTypeInformation

Get-Service | Where-Object { $_.Name -eq 'SEPMasterService' -or $_.Name -eq 'McShield' } | Select-Object -Property @{n = 'Computer Name' ; e = {$env:COMPUTERNAME}}, 
                                                                                        @{n = 'AV Service Name' ; e = {$_.Name}}, 
                                                                                        DisplayName, Status |
                                                                ConvertTo-CSV -NoTypeInformation | Add-Content -Path $outputFile