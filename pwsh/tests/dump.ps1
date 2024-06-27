Write-Host "  - Dumping: " -NoNewline
$result = node (Join-Path $paths.js "dumper.js")
Write-Host "Done" -ForegroundColor Green
Write-Host "  - Declaring API: " -NoNewline

$dump = [PSCustomObject]@{
    Log = $result
    Source = Get-Content .\dump.json -Raw | ConvertFrom-Json -AsHashtable
}

$dump | Add-Member `
    -Name Search `
    -MemberType ScriptMethod `
    -Value {
        param( $search )

        $search = [regex]::Escape($search)
        $search = "(?<!\/\/.*)$search" 

        $this.Source.GetEnumerator() | ForEach-Object {
            $scriptId = $_.Key
            $script = $_.Value.source
            $metadata = $_.Value.metadata

            $lines = New-Object System.Collections.ArrayList

            # Find the search term, and return the metadata, and the line number

            $script -split '\r?\n' | ForEach-Object -Begin { $line = 0 } {
                $line++

                if ($_ -match $search) {
                    $lineObj = [PSCustomObject]@{
                        Line = $line
                        Text = $_
                    }

                    $lineObj | Add-Member -MemberType ScriptMethod -Name ToString -Value {
                        $this.Line.ToString()
                    } -Force
                    $lines.Add($lineObj) | Out-Null
                }
            }

            if( $lines.Count -eq 0 ){
                return
            }

            [PSCustomObject]@{
                Id = $scriptId
                Name = $metadata.url
                Count = $lines.Count
                Lines = $lines
                Metadata = $metadata
            }
        }

        return $out
    }

$dump | Add-Member `
    -Name Exclude `
    -MemberType ScriptMethod `
    -Value {
        param( $searches )

        $this.Source.GetEnumerator() | ForEach-Object {
            $scriptId = $_.Key
            $script = $_.Value.source
            $metadata = $_.Value.metadata

            # Exclude all files that containe any of the search terms

            $matches = $script -split '\r?\n' | ForEach-Object {
                $line = $_

                $searches | ForEach-Object {
                    $search = [regex]::Escape($_)
                    $search = "(?<!\/\/.*)$search"

                    $line -match $search
                }
            } | Where-Object { $_ }
            
            If( $matches.Count -eq 0 ){
                [PSCustomObject]@{
                    Id = $scriptId
                    Name = $metadata.url
                    Metadata = $metadata
                }
            }
        }
    }

$result = @{
    "dump" = $dump
    "calls" = @{}
}

Write-Host "Done" -ForegroundColor Green

Write-Host "  - Searches: "
Write-Host "    - internalBinding: " -NoNewline
$result.calls.internalBinding = $dump.Search( "internalBinding" )
Write-Host "Done" -ForegroundColor Green
Write-Host "    - require: " -NoNewline
$result.calls.require = $dump.Search( "require" )
Write-Host "Done" -ForegroundColor Green
Write-Host "    - neither: " -NoNewline
$result.calls.neither = $dump.Exclude( @("internalBinding", "require") )
Write-Host "Done" -ForegroundColor Green

$result