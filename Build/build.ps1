#requires -Version 7.0

<#
.SYNOPSIS
Build orchestration script for ModuleName

.DESCRIPTION
This script orchestrates the build process by installing dependencies and invoking the build tasks.
It uses PSDepend to install required modules and Invoke-Build to run the build tasks.

.PARAMETER Task
The build task(s) to execute. Default is 'Default' which runs all standard build tasks.
Available tasks are defined in ModuleName.build.ps1

.PARAMETER Bootstrap
Install required build dependencies before running the build

.EXAMPLE
.\build.ps1

Runs the default build tasks

.EXAMPLE
.\build.ps1 -Task Test

Runs only the Test task

.EXAMPLE
.\build.ps1 -Bootstrap

Installs dependencies and runs the default build

.EXAMPLE
.\build.ps1 -Task Clean, Build, Test

Runs multiple tasks in sequence
#>
[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [string[]]$Task = 'Default',

    [switch]$Bootstrap,

    [switch]$BootstrapOnly
)

# Set strict mode
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Get build root directory
$BuildRoot = $PSScriptRoot
$ProjectRoot = Split-Path -Parent $BuildRoot

Write-Host "Build Root: $BuildRoot" -ForegroundColor Cyan
Write-Host "Project Root: $ProjectRoot" -ForegroundColor Cyan
Write-Host ""

#region Bootstrap Dependencies
if ($Bootstrap) {
    Write-Host "Bootstrapping build dependencies..." -ForegroundColor Yellow

    # Install PSDepend if not already installed
    if (-not (Get-Module -Name PSDepend -ListAvailable)) {
        Write-Host "Installing PSDepend..." -ForegroundColor Yellow
        Install-Module -Name PSDepend -Scope CurrentUser -Force -SkipPublisherCheck
    }

    # Install dependencies from PSDepend.psd1
    $DependencyFile = Join-Path $BuildRoot 'PSDepend.psd1'
    if (Test-Path $DependencyFile) {
        Write-Host "Installing dependencies from PSDepend.psd1..." -ForegroundColor Yellow
        Import-Module PSDepend
        Invoke-PSDepend -Path $DependencyFile -Install -Import -Force
    }
    else {
        Write-Warning "PSDepend.psd1 not found at: $DependencyFile"
    }

    Write-Host "Bootstrap complete!" -ForegroundColor Green
    Write-Host ""

    if ($BootstrapOnly) { return }
}
#endregion Bootstrap Dependencies

#region Verify InvokeBuild
# Ensure InvokeBuild is available
if (-not (Get-Module -Name InvokeBuild -ListAvailable)) {
    Write-Host "InvokeBuild module not found. Installing..." -ForegroundColor Yellow
    Install-Module -Name InvokeBuild -Scope CurrentUser -Force -SkipPublisherCheck
}

Import-Module InvokeBuild -Force
#endregion Verify InvokeBuild

#region Execute Build
try {
    # Find the build file
    $BuildFile = Get-ChildItem -Path $BuildRoot -Filter '*.build.ps1' | Select-Object -First 1

    if (-not $BuildFile) {
        throw "No build file (*.build.ps1) found in $BuildRoot"
    }

    Write-Host "Build File: $($BuildFile.FullName)" -ForegroundColor Cyan
    Write-Host "Task(s): $($Task -join ', ')" -ForegroundColor Cyan
    Write-Host ""

    # Execute the build
    Invoke-Build -Task $Task -File $BuildFile.FullName

    Write-Host ""
    Write-Host "Build completed successfully!" -ForegroundColor Green
}
catch {
    Write-Host ""
    Write-Host "Build failed!" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    throw
}
#endregion Execute Build
