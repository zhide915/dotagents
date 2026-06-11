#requires -Version 5.1
# Symlink repo config into live dirs (repo -> ~/.claude). Needs Developer Mode. Use -DryRun to preview.
[CmdletBinding()]
param([switch]$DryRun)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$manifest = Get-Content (Join-Path $repoRoot 'manifest.json') -Raw | ConvertFrom-Json

function Expand-HomePath([string]$p) {
  if ($p -like '~*') { return (Join-Path $HOME ($p.Substring(1).TrimStart('/', '\'))) }
  return $p
}

function Assert-CanSymlink {
  $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
  $devMode = $false
  try {
    $devMode = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock' -Name AllowDevelopmentWithoutDevLicense -ErrorAction Stop).AllowDevelopmentWithoutDevLicense -eq 1
  }
  catch {}
  if (-not ($isAdmin -or $devMode)) { throw "Symlinks need Developer Mode or admin. Enable it in Settings > For developers, or use apply.ps1 to copy." }
}

function Remove-Target($path) {
  $item = Get-Item -LiteralPath $path -Force -ErrorAction SilentlyContinue
  if (-not $item) { return }
  if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) { $item.Delete() }
  elseif ($item.PSIsContainer) { Remove-Item -LiteralPath $path -Recurse -Force }
  else { Remove-Item -LiteralPath $path -Force }
}

function Link-Entry($src, $dst, [switch]$DryRun) {
  if (-not (Test-Path -LiteralPath $src)) { Write-Host "  skip: $src"; return }
  $src = (Resolve-Path -LiteralPath $src).Path
  if ($DryRun) { Write-Host "  link: $dst -> $src"; return }
  Remove-Target $dst
  $parent = Split-Path -Parent $dst
  if (-not (Test-Path $parent)) { New-Item -ItemType Directory -Force -Path $parent | Out-Null }
  if ((Get-Item -LiteralPath $src).PSIsContainer) { cmd /c mklink /D "$dst" "$src" | Out-Null }
  else { cmd /c mklink "$dst" "$src" | Out-Null }
  if ($LASTEXITCODE -ne 0) { throw "mklink failed ($LASTEXITCODE): $dst" }
  Write-Host "  ok: $dst"
}

if (-not $DryRun) { Assert-CanSymlink }

foreach ($agentName in $manifest.agents.PSObject.Properties.Name) {
  $agent = $manifest.agents.$agentName
  $repoDir = Join-Path $repoRoot $agent.repoDir
  $targetDir = Expand-HomePath $agent.targetDir
  Write-Host "==> $agentName  ->  $targetDir"
  if ($agent.instructions) { Link-Entry (Join-Path $repoRoot $agent.instructions.from) (Join-Path $targetDir $agent.instructions.to) -DryRun:$DryRun }
  foreach ($entry in $agent.sync) {
    Link-Entry (Join-Path $repoDir $entry) (Join-Path $targetDir $entry) -DryRun:$DryRun
  }
}
