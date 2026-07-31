<#
/*
 * Copyright 2026 NXP
 *
 * SPDX-License-Identifier: BSD-3-Clause
 */
#>

param(
    [switch]$Apply,
    [switch]$RemoveEmptyDirectories
)

$ErrorActionPreference = "Stop"

function Resolve-RepoRoot {
    $scriptDir = Split-Path -Parent $PSCommandPath
    return (Resolve-Path (Join-Path $scriptDir "..")).Path
}

function Assert-InRepoFile {
    param(
        [string]$RepoRoot,
        [string]$Path
    )

    $repoPath = [System.IO.Path]::GetFullPath($RepoRoot).TrimEnd('\', '/')
    $fullPath = [System.IO.Path]::GetFullPath($Path)

    if (-not $fullPath.StartsWith($repoPath + [System.IO.Path]::DirectorySeparatorChar)) {
        throw "Refusing to touch path outside repo: $fullPath"
    }

    if (($fullPath -notlike "*.c") -and ($fullPath -notlike "*.h")) {
        throw "Refusing to touch non-C/H file: $fullPath"
    }
}

function Remove-EmptyDirectoriesUnder {
    param(
        [string]$RepoRoot,
        [string[]]$RelativeRoots
    )

    foreach ($relativeRoot in $RelativeRoots) {
        $root = Join-Path $RepoRoot $relativeRoot
        if (!(Test-Path -LiteralPath $root)) {
            continue
        }

        Get-ChildItem -LiteralPath $root -Directory -Recurse |
            Sort-Object FullName -Descending |
            ForEach-Object {
                if (-not (Get-ChildItem -LiteralPath $_.FullName -Force | Select-Object -First 1)) {
                    Remove-Item -LiteralPath $_.FullName -Force
                    Write-Host "Removed empty directory: $($_.FullName)"
                }
            }
    }
}

$repoRoot = Resolve-RepoRoot

# NFC middleware/support directories. Only *.c and *.h files under these roots are selected.
$nfcRoots = @(
    "NfcLibrary",
    "applications\TML",
    "applications\tool"
)

# NFC example/helper files that live directly under applications/.
$nfcFiles = @(
    "applications\ndef_helper.c",
    "applications\ndef_helper.h",
    "applications\nfc_example_P2P.c",
    "applications\nfc_example_RW.c",
    "applications\nfc_example_RWandCE.c"
)

$targets = New-Object System.Collections.Generic.List[string]

foreach ($relativeRoot in $nfcRoots) {
    $root = Join-Path $repoRoot $relativeRoot
    if (Test-Path -LiteralPath $root) {
        Get-ChildItem -LiteralPath $root -Recurse -File -Include *.c,*.h |
            ForEach-Object { $targets.Add($_.FullName) }
    }
}

foreach ($relativeFile in $nfcFiles) {
    $path = Join-Path $repoRoot $relativeFile
    if (Test-Path -LiteralPath $path) {
        $targets.Add((Resolve-Path -LiteralPath $path).Path)
    }
}

$targets = $targets | Sort-Object -Unique

if ($targets.Count -eq 0) {
    Write-Host "No NFC .c/.h files found."
    return
}

foreach ($target in $targets) {
    Assert-InRepoFile -RepoRoot $repoRoot -Path $target
}

if (!$Apply) {
    Write-Host "Dry run: the following NFC .c/.h files would be deleted. Re-run with -Apply to delete them."
    $targets | ForEach-Object { Write-Host "  $_" }
    return
}

foreach ($target in $targets) {
    Remove-Item -LiteralPath $target -Force
    Write-Host "Deleted: $target"
}

if ($RemoveEmptyDirectories) {
    Remove-EmptyDirectoriesUnder -RepoRoot $repoRoot -RelativeRoots $nfcRoots
}