<#
/*
 * Copyright 2026 NXP
 *
 * SPDX-License-Identifier: BSD-3-Clause
 */
#>

param(
    [string]$DownloadUrl = "https://www.nxp.com/downloads/en/software/SW6705.zip",
    [string]$SourceProject = "NXP-NCI2.0_LPC82x_examples",
    [string]$WorkDir = "",
    [switch]$KeepWork,
    [switch]$AcceptNfcInfrastructureLicense
)

$ErrorActionPreference = "Stop"

function Resolve-RepoRoot {
    $scriptDir = Split-Path -Parent $PSCommandPath
    return (Resolve-Path (Join-Path $scriptDir "..")).Path
}

function Copy-SourceFile {
    param(
        [string]$SourceRoot,
        [string]$DestinationRoot,
        [string]$SourceRelativePath,
        [string]$DestinationRelativePath
    )

    $source = Join-Path $SourceRoot $SourceRelativePath
    $destination = Join-Path $DestinationRoot $DestinationRelativePath
    $destinationDir = Split-Path -Parent $destination

    if (!(Test-Path -LiteralPath $source)) {
        throw "Source file not found: $source"
    }

    New-Item -ItemType Directory -Force -Path $destinationDir | Out-Null
    Copy-Item -LiteralPath $source -Destination $destination -Force
}


function Confirm-NfcInfrastructureLicense {
    param(
        [switch]$Accepted
    )

    $licenseName = "NFC Infrastructure Software License and Distribution Agreement"

    if ($Accepted) {
        Write-Host "Confirmed acceptance of: $licenseName"
        return $true
    }

    Write-Host "SW6705 NFC middleware is distributed under:"
    Write-Host "  $licenseName"
    Write-Host "You must approve this license before this script downloads SW6705, copies NFC files, or applies scripts/sw6705-mcxc242-local.patch."
    $answer = Read-Host "Type APPROVE to accept and continue"

    if ($answer -ieq "APPROVE") {
        return $true
    }

    Write-Host "License not approved. No files were downloaded, copied, or patched."
    return $false
}
function Assert-SafeWorkDir {
    param(
        [string]$Path,
        [string]$RepoRoot
    )

    $fullPath = [System.IO.Path]::GetFullPath($Path).TrimEnd('\', '/')
    $repoPath = [System.IO.Path]::GetFullPath($RepoRoot).TrimEnd('\', '/')
    $pathRoot = [System.IO.Path]::GetPathRoot($fullPath).TrimEnd('\', '/')
    $leafName = Split-Path -Leaf $fullPath

    if ([string]::IsNullOrWhiteSpace($leafName) -or ($fullPath -eq $pathRoot)) {
        throw "Refusing to use unsafe WorkDir: $fullPath"
    }

    if (($fullPath -eq $repoPath) -or $repoPath.StartsWith($fullPath + [System.IO.Path]::DirectorySeparatorChar)) {
        throw "Refusing to use a WorkDir that is the repo root or contains the repo: $fullPath"
    }

    if ($leafName -notlike "*sw6705*") {
        throw "Refusing to delete WorkDir whose leaf directory does not contain 'sw6705': $fullPath"
    }
}
$repoRoot = Resolve-RepoRoot
$repoRootForGit = $repoRoot.Replace("\", "/")
$patchFile = Join-Path $repoRoot "scripts\sw6705-mcxc242-local.patch"

if (!(Test-Path -LiteralPath $patchFile)) {
    throw "Local patch file not found: $patchFile"
}


if (!(Confirm-NfcInfrastructureLicense -Accepted:$AcceptNfcInfrastructureLicense)) {
    return
}
if ([string]::IsNullOrWhiteSpace($WorkDir)) {
    $WorkDir = Join-Path ([System.IO.Path]::GetTempPath()) "sw6705-nfc-patch"
}

$WorkDir = [System.IO.Path]::GetFullPath($WorkDir)
Assert-SafeWorkDir -Path $WorkDir -RepoRoot $repoRoot
$outerDir = Join-Path $WorkDir "outer"
$innerDir = Join-Path $WorkDir "inner"
$zipPath = Join-Path $WorkDir "SW6705.zip"
$innerZipPath = Join-Path $outerDir "NXP-NCI2.0_MCUXpresso_examples.zip"

if (Test-Path -LiteralPath $WorkDir) {
    Remove-Item -LiteralPath $WorkDir -Recurse -Force
}

New-Item -ItemType Directory -Force -Path $outerDir, $innerDir | Out-Null

Write-Host "Downloading $DownloadUrl"
curl.exe --ssl-no-revoke -L --fail --show-error --output $zipPath $DownloadUrl
if ($LASTEXITCODE -ne 0) {
    throw "curl.exe failed with exit code $LASTEXITCODE"
}

Write-Host "Extracting SW6705"
Expand-Archive -Path $zipPath -DestinationPath $outerDir -Force

if (!(Test-Path -LiteralPath $innerZipPath)) {
    throw "Inner example zip not found: $innerZipPath"
}

Expand-Archive -Path $innerZipPath -DestinationPath $innerDir -Force

$sourceRoot = Join-Path $innerDir $SourceProject
if (!(Test-Path -LiteralPath $sourceRoot)) {
    $available = Get-ChildItem -LiteralPath $innerDir -Directory | Select-Object -ExpandProperty Name
    throw "Source project '$SourceProject' not found. Available projects: $($available -join ', ')"
}

$fileMap = @(
    @("NfcLibrary\inc\Nfc.h", "NfcLibrary\inc\Nfc.h"),
    @("NfcLibrary\inc\Nfc_settings.h", "NfcLibrary\inc\Nfc_settings.h"),
    @("NfcLibrary\NxpNci20\inc\NxpNci20.h", "NfcLibrary\NxpNci20\inc\NxpNci20.h"),
    @("NfcLibrary\NxpNci20\src\NxpNci20.c", "NfcLibrary\NxpNci20\src\NxpNci20.c"),
    @("NfcLibrary\NdefLibrary\inc\P2P_NDEF.h", "NfcLibrary\NdefLibrary\inc\P2P_NDEF.h"),
    @("NfcLibrary\NdefLibrary\inc\RW_NDEF.h", "NfcLibrary\NdefLibrary\inc\RW_NDEF.h"),
    @("NfcLibrary\NdefLibrary\inc\RW_NDEF_MIFARE.h", "NfcLibrary\NdefLibrary\inc\RW_NDEF_MIFARE.h"),
    @("NfcLibrary\NdefLibrary\inc\RW_NDEF_T1T.h", "NfcLibrary\NdefLibrary\inc\RW_NDEF_T1T.h"),
    @("NfcLibrary\NdefLibrary\inc\RW_NDEF_T2T.h", "NfcLibrary\NdefLibrary\inc\RW_NDEF_T2T.h"),
    @("NfcLibrary\NdefLibrary\inc\RW_NDEF_T3T.h", "NfcLibrary\NdefLibrary\inc\RW_NDEF_T3T.h"),
    @("NfcLibrary\NdefLibrary\inc\RW_NDEF_T4T.h", "NfcLibrary\NdefLibrary\inc\RW_NDEF_T4T.h"),
    @("NfcLibrary\NdefLibrary\inc\RW_NDEF_T5T.h", "NfcLibrary\NdefLibrary\inc\RW_NDEF_T5T.h"),
    @("NfcLibrary\NdefLibrary\inc\T4T_NDEF_emu.h", "NfcLibrary\NdefLibrary\inc\T4T_NDEF_emu.h"),
    @("NfcLibrary\NdefLibrary\src\P2P_NDEF.c", "NfcLibrary\NdefLibrary\src\P2P_NDEF.c"),
    @("NfcLibrary\NdefLibrary\src\RW_NDEF.c", "NfcLibrary\NdefLibrary\src\RW_NDEF.c"),
    @("NfcLibrary\NdefLibrary\src\RW_NDEF_MIFARE.c", "NfcLibrary\NdefLibrary\src\RW_NDEF_MIFARE.c"),
    @("NfcLibrary\NdefLibrary\src\RW_NDEF_T1T.c", "NfcLibrary\NdefLibrary\src\RW_NDEF_T1T.c"),
    @("NfcLibrary\NdefLibrary\src\RW_NDEF_T2T.c", "NfcLibrary\NdefLibrary\src\RW_NDEF_T2T.c"),
    @("NfcLibrary\NdefLibrary\src\RW_NDEF_T3T.c", "NfcLibrary\NdefLibrary\src\RW_NDEF_T3T.c"),
    @("NfcLibrary\NdefLibrary\src\RW_NDEF_T4T.c", "NfcLibrary\NdefLibrary\src\RW_NDEF_T4T.c"),
    @("NfcLibrary\NdefLibrary\src\RW_NDEF_T5T.c", "NfcLibrary\NdefLibrary\src\RW_NDEF_T5T.c"),
    @("NfcLibrary\NdefLibrary\src\T4T_NDEF_emu.c", "NfcLibrary\NdefLibrary\src\T4T_NDEF_emu.c"),
    @("source\main.c", "applications\main.c"),
    @("source\ndef_helper.c", "applications\ndef_helper.c"),
    @("source\ndef_helper.h", "applications\ndef_helper.h"),
    @("source\nfc_example_P2P.c", "applications\nfc_example_P2P.c"),
    @("source\nfc_example_RW.c", "applications\nfc_example_RW.c"),
    @("source\nfc_example_RWandCE.c", "applications\nfc_example_RWandCE.c"),
    @("source\TML\tml.c", "applications\TML\tml.c"),
    @("source\TML\tml.h", "applications\TML\tml.h"),
    @("source\tool\tool.c", "applications\tool\tool.c"),
    @("source\tool\tool.h", "applications\tool\tool.h")
)

Write-Host "Copying NFC source files from $SourceProject"
foreach ($entry in $fileMap) {
    Copy-SourceFile -SourceRoot $sourceRoot -DestinationRoot $repoRoot -SourceRelativePath $entry[0] -DestinationRelativePath $entry[1]
}

Write-Host "Applying MCXC242 local adaptation patch"
Push-Location $repoRoot
try {
    git -c "safe.directory=$repoRootForGit" apply --whitespace=nowarn $patchFile
    if ($LASTEXITCODE -ne 0) {
        throw "git apply failed with exit code $LASTEXITCODE"
    }
}
finally {
    Pop-Location
}

if (!$KeepWork) {
    Remove-Item -LiteralPath $WorkDir -Recurse -Force
}

Write-Host "SW6705 NFC files copied and MCXC242 adaptations applied."
