node .\..\js\dumper.js
$dump = Get-Content .\dump.json -Raw | ConvertFrom-Json -AsHashtable

function Search-Dump ( $search ){

    $dump.GetEnumerator() | ForEach-Object {
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

function Exclude-Dump ( $searches ){
    
    $dump.GetEnumerator() | ForEach-Object {
        $scriptId = $_.Key
        $script = $_.Value.source
        $metadata = $_.Value.metadata

        # Exclude all files that containe any of the search terms

        $matches = $searches | Where-Object {
            $script -match $_
        }
        
        If( $matches.Count -eq 0 ){
            [PSCustomObject]@{
                Id = $scriptId
                Name = $metadata.url
                Metadata = $metadata
            }
        }
    }
}

$result = Search-Dump "internalBinding"
$result | Format-Table
$result.Count
