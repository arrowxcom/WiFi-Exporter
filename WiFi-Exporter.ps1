
<#
 __  __                      _____         _     
 \ \/ /___ _ ____  _____  __|_   _|__  ___| |__  
  \  // _ \ '__\ \/ / _ \/ __|| |/ _ \/ __| '_ \ 
  /  \  __/ |   >  <  __/\__ \| |  __/ (__| | | |
 /_/\_\___|_|  /_/\_\___||___/|_|\___|\___|_| |_|
                                                 
WiFi Exporter - Used to export all stored SSIDs and Passwords on a Windows Machine
Version: v1.0

#>

Write-Host -ForegroundColor Cyan "Querying WiFi Profiles."
$wifi = netsh wlan show profiles

[int]$count = ($wifi.Count)-10
Write-Host -ForegroundColor Cyan $count "Profiles Found."
Write-Host ""

foreach ($record in $wifi) {
    if ($record -match "All User Profile ") {
        $ssid = $record -split ": "
        $query = netsh wlan show profile $ssid[1] key=clear
    
        foreach ($line in $query) {
            if ($line -match "Authentication         : Open") { Write-Host -ForegroundColor Yellow $ssid[1] " - No Password, Open Network" }
            if ($line -match "Key Content") {
                $key = $line -split ": "
                Write-Host -ForegroundColor Green $ssid[1] " - " $key[1]
            }
        }
    }
}