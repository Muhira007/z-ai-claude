# zcl — run Claude Code against Z.ai's GLM-5.2 Anthropic-compatible API (Windows).
#
# Key resolution order:
#   1. `zcl config [KEY]`   — set/replace the stored key (inline or prompt)
#   2. stored config file         — set on a previous run
#   3. $env:ZAI_API_KEY           — used and saved for next time
#   4. interactive prompt         — asks for the key if you haven't included it yet

param(
    [string]$Version = "main",
    [string]$Dest = "$env:LOCALAPPDATA\Programs\zcl"
)

$ErrorActionPreference = 'Stop'

$RepoUrl = "https://raw.githubusercontent.com/Muhira007/z-ai-claude/$Version"
$CmdName = "zcl"

Write-Host "Installing $CmdName ($Version) to $Dest ..."

New-Item -ItemType Directory -Force -Path $Dest | Out-Null

# Download the PowerShell script
$scriptUrl = "$RepoUrl/$CmdName.ps1"
$scriptPath = Join-Path $Dest "$CmdName.ps1"
Write-Host "Downloading $scriptUrl ..."
Invoke-WebRequest -Uri $scriptUrl -OutFile $scriptPath

# Create a batch wrapper so it's callable as 'zcl' from cmd/terminal
$batchPath = Join-Path $Dest "$CmdName.cmd"
@"
@echo off
pwsh.exe -NoProfile -ExecutionPolicy Bypass -File "$scriptPath" %*
"@ | Set-Content -Path $batchPath -Encoding ASCII

Write-Host "Installed: $scriptPath"
Write-Host "Installed: $batchPath"

# Check PATH
$userPath = [Environment]::GetEnvironmentVariable('PATH', 'User')
if ($userPath -split ';' -notcontains $Dest) {
    Write-Host ""
    Write-Host "NOTE: $Dest is not on your user PATH."
    Write-Host "Run this to add it (admin terminal):"
    Write-Host '  [Environment]::SetEnvironmentVariable("PATH", $env:PATH + ";" + $Dest + '", "User")'
    Write-Host "Then restart your terminal and run: $CmdName"
} else {
    Write-Host "Ready. Run: $CmdName"
}
