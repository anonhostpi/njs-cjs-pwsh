Write-Host "- Imports:"
Write-Host "  - Import-Package: "

Try {
    Import-Module "Import-Package"
    
    Write-Host "  - Import-Package: " -NoNewline
    Write-Host "       " -NoNewline
    Write-Host "Done" -ForegroundColor Green -NoNewline; Write-Host;
} Catch {
    Write-Host "  - Import-Package: " -NoNewline
    Write-Host "       " -NoNewline
    Write-Host "Failed" -ForegroundColor Red -NoNewline; Write-Host;
    throw $_
    Pause
}

Write-Host "  - Microsoft.ClearScript: "

Try {
    Import-Package "Microsoft.ClearScript" -ErrorAction Stop

    Write-Host "  - Microsoft.ClearScript: " -NoNewline
    Write-Host "Done" -ForegroundColor Green -NoNewline; Write-Host;
} Catch {
    Write-Host "  - Microsoft.ClearScript: " -NoNewline
    Write-Host "Failed" -ForegroundColor Red -NoNewline; Write-Host;
    throw $_
    Pause
}

Write-Host "  - New-ThreadController: "

Try {
    Import-Module "New-ThreadController"

    Write-Host "  - New-ThreadController: " -NoNewline
    Write-Host " " -NoNewline
    Write-Host "Done" -ForegroundColor Green -NoNewline; Write-Host;
} Catch {
    Write-Host "  - New-ThreadController: " -NoNewline
    Write-Host " " -NoNewline
    Write-Host "Failed" -ForegroundColor Red -NoNewline; Write-Host;
    throw $_
    Pause
}