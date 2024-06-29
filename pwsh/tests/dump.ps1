Write-Host "  - Dumping: "
$result = node (Join-Path $paths.js "dumper.js")
Write-Host "  - Declaring API: " -NoNewline

$dump = [PSCustomObject]@{
    Log = $result
    Source = Get-Content .\dump.json -Raw | ConvertFrom-Json -AsHashtable
    Traces = @{}
}

$dump | Add-Member `
    -Name Search `
    -MemberType ScriptMethod `
    -Value {
        param( $search, $escape = $true )

        If( $escape ){
            $search = [regex]::Escape($search)
        }
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
                        Matches = $matches
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
        param( $searches, $escape = $true )

        $this.Source.GetEnumerator() | ForEach-Object {
            $scriptId = $_.Key
            $script = $_.Value.source
            $metadata = $_.Value.metadata

            # Exclude all files that containe any of the search terms

            $matches = $script -split '\r?\n' | ForEach-Object {
                $line = $_

                $searches | ForEach-Object {
                    $search = $_
                    If( $escape ){
                        $search = [regex]::Escape($search)
                    }
                    $search = "(?<!\/\/.*)$search"

                    $line -match $search
                }
            } | Where-Object { $_ }
            
            If( $matches.Count -eq 0 ){
                $out = @{
                    Id = $scriptId
                    Name = $metadata.url
                    Metadata = $metadata
                }

                [PSCustomObject]$out
            }
        }
    }

$result = @{
    "dump" = $dump
    "calls" = @{}
}

$paths.dump = Join-Path $paths.js "dump"

$dump.Log | Out-File (Join-Path $paths.dump "dump.log")

$i = 0

Write-Host "Done" -ForegroundColor Green -NoNewline; Write-Host
Write-Host "  - Writing to disk: " -NoNewline

$dump.Source.GetEnumerator() | ForEach-Object {
    $id = $_.Key
    $metadata = $_.Value.metadata
    $script = $_.Value.source

    if( $metadata.url -like "file:*"){
        return;
    }

    $name = $metadata.url -replace "node:","(node)"
    $name = $name -replace "/","."
    If( $name -like "*<anonymous>*" ){
        $i++
        $name = $name -replace ([regex]::Escape("<anonymous>"), "anonymous")
        $name = "$name ($i)"
    }

    If( $metadata.stackTrace.callFrames.Count ){
        $traces = $metadata.stackTrace.callFrames | ForEach-Object {
            [PSCustomObject] $_
        }
        $dump.Traces[$id] = $traces

        $traces = $traces | ConvertTo-Json
        $traces | Out-File (Join-Path $paths.dump "$name.trace.json")
    }

    $metadata = $metadata | ConvertTo-Json -Depth 3
    $script | Out-File (Join-Path $paths.dump "$name.js")
    $metadata | Out-File (Join-Path $paths.dump "$name.json")
}

Write-Host "Done" -ForegroundColor Green -NoNewline; Write-Host

Write-Host "  - Searches: "
Write-Host "    - internalBinding: " -NoNewline
$result.calls.internalBinding = $dump.Search( "internalBinding" )
Write-Host "Done" -ForegroundColor Green -NoNewline; Write-Host;
Write-Host "    - require: " -NoNewline
$result.calls.require = $dump.Search( "require" )
Write-Host "Done" -ForegroundColor Green -NoNewline; Write-Host;
Write-Host "    - neither: " -NoNewline
$result.calls.neither = $dump.Exclude( @("internalBinding", "require") )
Write-Host "Done" -ForegroundColor Green -NoNewline; Write-Host;
$result