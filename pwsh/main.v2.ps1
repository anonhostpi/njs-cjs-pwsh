# Install-Module Import-Package
# Install-Module New-ThreadController

$paths = @{
    "root" = $PSScriptRoot
    "js" = Resolve-Path ($PSScriptRoot + "\..\js")
    "setup" = Resolve-Path ($PSScriptRoot + "\v2\setup")
    "source_node" = Resolve-Path ($PSScriptRoot + "\..\node")
    "source_clearscript" = Resolve-Path ($PSScriptRoot + "\..\clearscript")
}

$setup = @{};
$tests = @{};

$runtime = $null;
$engine = $null;

Write-Host "Preparing Test Environment:"
. (Resolve-Path ($paths.setup + "\imports.ps1"))
. (Resolve-Path ($paths.setup + "\threads.ps1"))
. (Resolve-Path ($paths.setup + "\types.ps1"))
. (Resolve-Path ($paths.setup + "\configuration.ps1"))
. (Resolve-Path ($paths.setup + "\init.ps1"))

Write-Host
Write-Host "Tests: " -NoNewline; Write-Host "Initialized" -NoNewline -ForegroundColor Green; Write-Host;
Pause;

Write-Host "Running Dump:"

