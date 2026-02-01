#requires -Version 7.2

<#
.SYNOPSIS
    Shared test helper module for Pester tests.

.DESCRIPTION
    Provides common functions for module import, path discovery, and test setup.
    Import this module in every test file instead of duplicating path-navigation logic.

.EXAMPLE
    # In a test file's BeforeAll block:
    $testDir = $PSScriptRoot
    while ($testDir -and !(Test-Path (Join-Path $testDir 'TestHelpers/TestHelper.psm1'))) {
        $testDir = Split-Path -Parent $testDir
    }
    Import-Module (Join-Path $testDir 'TestHelpers/TestHelper.psm1') -Force
    $null = Initialize-TestModule
#>

# Compute project root: TestHelper.psm1 is at Tests/TestHelpers/
$script:ProjectRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$script:SourcePath = Join-Path $script:ProjectRoot 'src'

# Discover module name from the manifest file in src/
$script:ModuleName = (
    Get-ChildItem -Path $script:SourcePath -Filter '*.psd1' -ErrorAction SilentlyContinue |
    Select-Object -First 1
).BaseName

if (-not $script:ModuleName) {
    $script:ModuleName = 'ModuleName'
}

function Get-ProjectRoot {
    <#
    .SYNOPSIS
        Returns the project root directory path.
    #>
    [OutputType([string])]
    [CmdletBinding()]
    param()

    return $script:ProjectRoot
}

function Get-ModuleManifestPath {
    <#
    .SYNOPSIS
        Returns the full path to the module manifest (.psd1) file.
    #>
    [OutputType([string])]
    [CmdletBinding()]
    param()

    $manifestPath = Join-Path $script:SourcePath "$($script:ModuleName).psd1"
    if (-not (Test-Path $manifestPath)) {
        throw "Module manifest not found at: $manifestPath"
    }
    return $manifestPath
}

function Initialize-TestModule {
    <#
    .SYNOPSIS
        Imports the module under test, removing any previously loaded copy.

    .DESCRIPTION
        Finds the module manifest in src/, removes the module if already loaded,
        imports it fresh, and returns the module info object.

    .OUTPUTS
        System.Management.Automation.PSModuleInfo
    #>
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSModuleInfo])]
    param()

    $manifestPath = Get-ModuleManifestPath

    # Remove if already loaded
    if (Get-Module -Name $script:ModuleName) {
        Remove-Module -Name $script:ModuleName -Force
    }

    # Import globally so the module is available in the caller's scope (not just TestHelper's)
    Import-Module $manifestPath -Force -ErrorAction Stop -PassThru -Global
}

Export-ModuleMember -Function @(
    'Get-ProjectRoot'
    'Get-ModuleManifestPath'
    'Initialize-TestModule'
)
