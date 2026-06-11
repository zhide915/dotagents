#requires -Version 5.1
# Copy repo config into live dirs (repo -> ~/.claude). Use -DryRun to preview.
[CmdletBinding()]
param([switch]$DryRun)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$manifest = Get-Content (Join-Path $repoRoot 'manifest.json') -Raw | ConvertFrom-Json

function Expand-HomePath([string]$p) {
  if ($p -like '~*') { return (Join-Path $HOME ($p.Substring(1).TrimStart('/', '\'))) }
  return $p
}

function Copy-Entry($src, $dst, [switch]$DryRun) {
  if (-not (Test-Path $src)) { Write-Host "  skip: $src"; return }
  if ($DryRun) { Write-Host "  copy: $src -> $dst"; return }
  if ((Get-Item $src).PSIsContainer) {
    $null = robocopy $src $dst /MIR /NJH /NJS /NDL /NP /NFL
    if ($LASTEXITCODE -ge 8) { throw "robocopy failed ($LASTEXITCODE): $src" }
  }
  else {
    $parent = Split-Path -Parent $dst
    if (-not (Test-Path $parent)) { New-Item -ItemType Directory -Force -Path $parent | Out-Null }
    Copy-Item -Path $src -Destination $dst -Force
  }
  Write-Host "  ok: $dst"
}

foreach ($agentName in $manifest.agents.PSObject.Properties.Name) {
  $agent = $manifest.agents.$agentName
  $repoDir = Join-Path $repoRoot $agent.repoDir
  $targetDir = Expand-HomePath $agent.targetDir
  Write-Host "==> $agentName  ->  $targetDir"
  if ($agent.instructions) { Copy-Entry (Join-Path $repoRoot $agent.instructions.from) (Join-Path $targetDir $agent.instructions.to) -DryRun:$DryRun }
  foreach ($entry in $agent.sync) {
    Copy-Entry (Join-Path $repoDir $entry) (Join-Path $targetDir $entry) -DryRun:$DryRun
  }
}
