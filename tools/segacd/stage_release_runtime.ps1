# Windows dependency mechanics are owned by the pinned Genesis release provider.
# Callers retain payload allowlists, redistributable licenses and archive policy.
param(
    [Parameter(Mandatory = $true)][string]$StageDir,
    [string]$RuntimeDir
)
$ErrorActionPreference = 'Stop'
$engine = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
. (Join-Path $engine 'external/segagenesisrecomp/tools/release/GenesisRelease.ps1')

# Do not search PATH or a developer installation: the caller supplies the
# approved redistributable directory whose license accompanies the package.
$search = @($StageDir)
if ($RuntimeDir) { $search += $RuntimeDir }
$added = @(Copy-RuntimeDllClosure -StageDir $StageDir -SearchDirs $search)
$count = Assert-RuntimeDllClosure -StageDir $StageDir -ExpectedMachine x64
@{ added = $added; binaries_verified = $count } | ConvertTo-Json -Compress
