if ($Host.Name -eq "ConsoleHost") {
    $Host.UI.RawUI.WindowTitle = "PS Auto Shutdown by @flamesteak"
}

function Format-TimeRemaining {
    param ($TimeSpan)
    return "{0:D2}:{1:D2}:{2:D2}" -f $TimeSpan.Hours, $TimeSpan.Minutes, $TimeSpan.Seconds
}

Write-Host "PC Shutdown Timer Started" -ForegroundColor Green
Write-Host "Press Ctrl+C to exit at any time`n" -ForegroundColor Yellow

while ($true) {
    try {
        $ShutdownTime = (Get-Date).AddHours(2)
        Write-Host "Shutdown scheduled for: $($ShutdownTime.ToString('HH:mm:ss'))" -ForegroundColor Cyan
        
        while ((Get-Date) -lt $ShutdownTime) {
            $TimeLeft = $ShutdownTime - (Get-Date)
            Write-Host "`rTime remaining: $(Format-TimeRemaining $TimeLeft)" -NoNewline
            
            if ($TimeLeft.TotalMinutes -le 5) {
                Write-Host "`n`nWarning: 5 Minutes Remaining" -ForegroundColor Yellow
                Write-Host "Press 'C' to cancel or Enter to proceed." -ForegroundColor Yellow
                
                $startTime = Get-Date
                while (((Get-Date) - $startTime).TotalMinutes -lt 5) {
                    if ([Console]::KeyAvailable) {
                        $key = [Console]::ReadKey($true)
                        if ($key.Key -eq 'C') {
                            Write-Host "`nShutdown cancelled." -ForegroundColor Green
                            continue 2
                        }
                        if ($key.Key -eq 'Enter') {
                            break
                        }
                    }
                    Start-Sleep -Milliseconds 100
                }
                
                Write-Host "`nInitiating shutdown in 30 seconds..." -ForegroundColor Red
                Start-Sleep -Seconds 30
                Stop-Computer -Force
            }
            
            Start-Sleep -Seconds 1
        }
    }
    catch {
        Write-Host "`n`nAn error occurred:" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Red
        Write-Host "`nPress Enter to continue..." -ForegroundColor Yellow
        Read-Host
    }
}

# Write-Host "`nScript ended. Press Enter to exit..." -ForegroundColor Yellow
# Read-Host
# Made by @flamesteak
