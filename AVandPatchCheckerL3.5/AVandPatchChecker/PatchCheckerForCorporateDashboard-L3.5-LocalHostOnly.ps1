Clear-Host

Write-Output "`n`t*^*!*% Patch Checker for Corporate Dashboard (L3.5) *^*!*% "

$outputFile = "\\PCNSMS03\e$\AVandPatchChecker_CentralNode\PatchCheckerForCorporateDashboardOutput_$(if ((Get-Date).Month -eq 1) { "12_$((Get-Date).Year)" } else { "$($(Get-Date).Month - 1)_$((Get-Date).Year)" })-$($env:COMPUTERNAME).csv"

$os = (Get-WmiObject -Class 'Win32_OperatingSystem' -ErrorAction Stop).Caption
$wmiHash = Get-WmiObject -Class 'Win32_QuickFixEngineering' -ErrorAction Stop
$wmiHash | Select-Object -Property Description, HotFixID, InstalledBy, InstalledOn |
	       Sort-Object InstalledOn | Select-Object -Last 1 -Property @{ n = 'Hostname' ; e = {$env:COMPUTERNAME}},
                                                                     @{ n = 'Machine Type' ; e = {$os}},
																	 @{ n = 'Most Recent Patch' ; e = {$_.HotfixID}},
																	 @{ n = 'Installed On' ; e = {"$($_.InstalledOn.Month)/$($_.InstalledOn.Day)/$($_.InstalledOn.Year)"}}, 
																	 @{ n = 'Poller' ; e = {"WRRSWOR01"}} -OutVariable Export
if ($Export.InstalledOn -lt ((Get-Date).Adddays(-180))) { $Export | Export-CSV -Path $outputFile -NoTypeInformation }