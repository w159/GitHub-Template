#requires -Version 7.2
#requires -Modules InvokeBuild

<#
.SYNOPSIS
Invoke-Build tasks for ModuleName

.DESCRIPTION
This build script defines tasks for cleaning, analyzing, testing, and building the ModuleName module.
Tasks can be run individually or as part of the default build pipeline.

Available Tasks:
- Clean: Remove build artifacts
- Analyze: Run PSScriptAnalyzer
- Test: Run Pester tests
- Build: Build the module (prepare for publishing)
- Publish: Publish to PowerShell Gallery
- GenerateDocs: Generate markdown help from comment-based help
- UpdateDocs: Update existing markdown help files
- BuildHelp: Build XML external help from markdown
- Default: Run Clean, Analyze, Test, Build (standard pipeline)

.EXAMPLE
Invoke-Build

Runs the default task (Clean, Analyze, Test, Build)

.EXAMPLE
Invoke-Build Test

Runs only the Test task

.EXAMPLE
Invoke-Build -Task Clean, Build

Runs Clean and Build tasks
#>

# Build script parameters
param(
    [string]$Configuration = 'Release'
)

# Build variables
$ProjectRoot = Split-Path -Parent $PSScriptRoot
$SourcePath = Join-Path $ProjectRoot 'src'
$TestsPath = Join-Path $ProjectRoot 'Tests'
$OutputPath = Join-Path $ProjectRoot 'Output'
$ModuleName = (Get-ChildItem -Path $SourcePath -Filter '*.psd1' | Select-Object -First 1).BaseName

# Synopsis: Default task - runs the standard build pipeline
task Default Clean, Analyze, Test, Build

# Synopsis: Clean build artifacts and output directory
task Clean {
    Write-Build Yellow "Cleaning output directory: $OutputPath"

    if (Test-Path $OutputPath) {
        Remove-Item -Path $OutputPath -Recurse -Force
        Write-Build Green "Output directory cleaned"
    }
    else {
        Write-Build Gray "Output directory does not exist, nothing to clean"
    }
}

# Synopsis: Run PSScriptAnalyzer on source code
task Analyze {
    Write-Build Yellow "Running PSScriptAnalyzer..."

    # Get settings file
    $SettingsFile = Join-Path $ProjectRoot '.PSScriptAnalyzerSettings.psd1'

    # Analyze source files
    $AnalyzeParams = @{
        Path        = $SourcePath
        Recurse     = $true
        Settings    = $SettingsFile
        ErrorAction = 'Stop'
    }

    $Results = Invoke-ScriptAnalyzer @AnalyzeParams

    if ($Results) {
        $Results | Format-Table -AutoSize
        Write-Build Red "PSScriptAnalyzer found $($Results.Count) issue(s)"

        # Fail build on Error severity
        $Errors = $Results | Where-Object Severity -eq 'Error'
        if ($Errors) {
            throw "PSScriptAnalyzer found $($Errors.Count) error(s). Build cannot continue."
        }

        # Warn on Warning severity
        $Warnings = $Results | Where-Object Severity -eq 'Warning'
        if ($Warnings) {
            Write-Build Yellow "PSScriptAnalyzer found $($Warnings.Count) warning(s)"
        }
    }
    else {
        Write-Build Green "PSScriptAnalyzer found no issues"
    }
}

# Synopsis: Run Pester tests
task Test {
    Write-Build Yellow "Running Pester tests..."

    # Pester configuration
    $PesterConfig = New-PesterConfiguration
    $PesterConfig.Run.Path = $TestsPath
    $PesterConfig.Run.PassThru = $true
    $PesterConfig.Output.Verbosity = 'Detailed'
    $PesterConfig.CodeCoverage.Enabled = $true
    $PesterConfig.CodeCoverage.Path = @(
        (Join-Path $SourcePath 'Public' '*.ps1'),
        (Join-Path $SourcePath 'Private' '*.ps1')
    )
    $PesterConfig.CodeCoverage.OutputFormat = 'JaCoCo'
    $PesterConfig.CodeCoverage.OutputPath = Join-Path $ProjectRoot 'coverage.xml'
    $PesterConfig.TestResult.Enabled = $true
    $PesterConfig.TestResult.OutputPath = Join-Path $ProjectRoot 'testResults.xml'

    # Run tests
    $TestResults = Invoke-Pester -Configuration $PesterConfig

    # Check results
    if ($TestResults.FailedCount -gt 0) {
        throw "Pester tests failed: $($TestResults.FailedCount) test(s) failed"
    }

    # Check code coverage
    $CoverageThreshold = 70
    $CoveragePercent = [math]::Round($TestResults.CodeCoverage.CoveragePercent, 2)
    Write-Build Green "Code Coverage: $CoveragePercent%"

    if ($CoveragePercent -lt $CoverageThreshold) {
        # To enforce coverage, change Write-Build to: throw "Code coverage below threshold"
        Write-Build Yellow "Code coverage ($CoveragePercent%) is below $CoverageThreshold%. Consider adding more tests."
    }

    Write-Build Green "All tests passed! ($($TestResults.PassedCount) passed)"
}

# Synopsis: Build the module (prepare for publishing)
task Build {
    Write-Build Yellow "Building module: $ModuleName"

    # Create output directory
    $ModuleOutput = Join-Path $OutputPath $ModuleName
    $null = New-Item -Path $ModuleOutput -ItemType Directory -Force

    # Copy module files
    Write-Build Gray "Copying module files..."

    $FilesToCopy = @(
        (Join-Path $SourcePath "$ModuleName.psd1"),
        (Join-Path $SourcePath "$ModuleName.psm1")
    )

    foreach ($File in $FilesToCopy) {
        if (Test-Path $File) {
            Copy-Item -Path $File -Destination $ModuleOutput -Force
            Write-Build Gray "  Copied: $(Split-Path -Leaf $File)"
        }
    }

    # Copy Public, Private, Classes folders
    $FoldersToCopy = @('Public', 'Private', 'Classes')
    foreach ($Folder in $FoldersToCopy) {
        $SourceFolder = Join-Path $SourcePath $Folder
        if (Test-Path $SourceFolder) {
            $DestFolder = Join-Path $ModuleOutput $Folder
            Copy-Item -Path $SourceFolder -Destination $DestFolder -Recurse -Force
            Write-Build Gray "  Copied folder: $Folder"
        }
    }

    # Copy additional files (README, LICENSE, etc.)
    $AdditionalFiles = @('README.md', 'LICENSE', 'CHANGELOG.md')
    foreach ($AdditionalFile in $AdditionalFiles) {
        $FilePath = Join-Path $ProjectRoot $AdditionalFile
        if (Test-Path $FilePath) {
            Copy-Item -Path $FilePath -Destination $ModuleOutput -Force
            Write-Build Gray "  Copied: $AdditionalFile"
        }
    }

    # Copy about topic files
    $AboutTopicPath = Join-Path $ProjectRoot 'docs' 'en-US'
    $AboutTopics = Get-ChildItem -Path $AboutTopicPath -Filter 'about_*.help.txt' -ErrorAction SilentlyContinue
    if ($AboutTopics) {
        $HelpOutput = Join-Path $ModuleOutput 'en-US'
        $null = New-Item -Path $HelpOutput -ItemType Directory -Force
        foreach ($Topic in $AboutTopics) {
            Copy-Item -Path $Topic.FullName -Destination $HelpOutput -Force
            Write-Build Gray "  Copied about topic: $($Topic.Name)"
        }
    }

    # Generate XML help from markdown docs
    $DocsPath = Join-Path $ProjectRoot 'docs' 'en-US'
    $MarkdownHelp = Get-ChildItem -Path $DocsPath -Filter '*.md' -ErrorAction SilentlyContinue
    if ($MarkdownHelp) {
        $HelpOutput = Join-Path $ModuleOutput 'en-US'
        $null = New-Item -Path $HelpOutput -ItemType Directory -Force
        if (Get-Module -ListAvailable -Name platyPS) {
            New-ExternalHelp -Path $DocsPath -OutputPath $HelpOutput -Force -ErrorAction Stop
            Write-Build Green "External help generated from markdown docs"
        }
        else {
            Write-Build Yellow "platyPS not found — skipping XML help generation"
        }
    }

    Write-Build Green "Module built successfully at: $ModuleOutput"

    # Validate module manifest
    Write-Build Gray "Validating module manifest..."
    $ManifestPath = Join-Path $ModuleOutput "$ModuleName.psd1"
    $Manifest = Test-ModuleManifest -Path $ManifestPath -ErrorAction Stop

    Write-Build Green "Module manifest is valid"
    Write-Build Gray "  Name: $($Manifest.Name)"
    Write-Build Gray "  Version: $($Manifest.Version)"
    Write-Build Gray "  Author: $($Manifest.Author)"
}

# Synopsis: Publish module to PowerShell Gallery
task Publish {
    Write-Build Yellow "Publishing module to PowerShell Gallery..."

    # Require API key
    $ApiKey = $env:PSGALLERY_API_KEY
    if (-not $ApiKey) {
        throw "PowerShell Gallery API Key not found. Set environment variable PSGALLERY_API_KEY"
    }

    # Get module path
    $ModuleOutput = Join-Path $OutputPath $ModuleName

    if (-not (Test-Path $ModuleOutput)) {
        throw "Module not found at: $ModuleOutput. Run 'Invoke-Build Build' first."
    }

    # Publish
    $PublishParams = @{
        Path        = $ModuleOutput
        NuGetApiKey = $ApiKey
        Repository  = 'PSGallery'
        ErrorAction = 'Stop'
    }

    Publish-Module @PublishParams

    Write-Build Green "Module published successfully!"
}

# Synopsis: Install the module locally for testing
task Install Build, {
    Write-Build Yellow "Installing module locally..."

    $ModuleOutput = Join-Path $OutputPath $ModuleName
    $InstallPath = Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'PowerShell' 'Modules'

    # Remove existing version
    $ExistingModule = Join-Path $InstallPath $ModuleName
    if (Test-Path $ExistingModule) {
        Write-Build Gray "Removing existing module..."
        Remove-Item -Path $ExistingModule -Recurse -Force
    }

    # Copy module
    Copy-Item -Path $ModuleOutput -Destination $InstallPath -Recurse -Force

    Write-Build Green "Module installed to: $ExistingModule"
    Write-Build Gray "You can now import it with: Import-Module $ModuleName"
}

# Synopsis: Generate markdown help from comment-based help
task GenerateDocs {
    Write-Build Yellow "Generating markdown help documentation..."

    Import-Module (Join-Path $SourcePath "$ModuleName.psd1") -Force -ErrorAction Stop

    $DocsPath = Join-Path $ProjectRoot 'docs' 'en-US'
    if (-not (Test-Path $DocsPath)) {
        $null = New-Item -Path $DocsPath -ItemType Directory -Force
    }

    $Params = @{
        Module                = $ModuleName
        OutputFolder          = $DocsPath
        AlphabeticParamsOrder = $true
        UseFullTypeName       = $true
        WithModulePage        = $true
        Force                 = $true
        ErrorAction           = 'Stop'
    }

    New-MarkdownHelp @Params

    Remove-Module $ModuleName -Force
    Write-Build Green "Markdown help generated at: $DocsPath"
}

# Synopsis: Update existing markdown help files
task UpdateDocs {
    Write-Build Yellow "Updating markdown help documentation..."

    Import-Module (Join-Path $SourcePath "$ModuleName.psd1") -Force -ErrorAction Stop

    $DocsPath = Join-Path $ProjectRoot 'docs' 'en-US'
    if (-not (Test-Path $DocsPath)) {
        throw "Docs folder not found at: $DocsPath. Run 'Invoke-Build GenerateDocs' first."
    }

    Update-MarkdownHelp -Path $DocsPath -AlphabeticParamsOrder -UseFullTypeName -ErrorAction Stop

    Remove-Module $ModuleName -Force
    Write-Build Green "Markdown help updated at: $DocsPath"
}

# Synopsis: Build XML external help from markdown
task BuildHelp {
    Write-Build Yellow "Building external help..."

    $DocsPath = Join-Path $ProjectRoot 'docs' 'en-US'
    $HelpOutput = Join-Path $OutputPath $ModuleName 'en-US'

    if (-not (Test-Path $DocsPath)) {
        throw "Docs folder not found at: $DocsPath. Run 'Invoke-Build GenerateDocs' first."
    }

    $null = New-Item -Path $HelpOutput -ItemType Directory -Force

    New-ExternalHelp -Path $DocsPath -OutputPath $HelpOutput -Force -ErrorAction Stop

    Write-Build Green "External help built at: $HelpOutput"
}
