<#
.SYNOPSIS
    Creates recommended GitHub labels for AI-native workflow.

.DESCRIPTION
    Uses the GitHub CLI (gh) to create or update labels on the current repository.
    Labels include AI workflow labels for routing tasks to AI coding agents,
    plus priority levels for general issue triage.

    Requires the gh CLI to be installed and authenticated.

    If labels already exist, they are updated with the specified color and
    description (the --force flag makes this idempotent).

    Note: The ai_task.md issue template references the 'ai-task' and 'ai-ready'
    labels. If this script has not been run, GitHub will auto-create those labels
    with default gray color when the first AI task issue is created.

.PARAMETER DryRun
    If specified, shows what labels would be created without making changes.

.EXAMPLE
    .\Scripts\Initialize-Labels.ps1

    Creates all recommended labels on the current repository.

.EXAMPLE
    .\Scripts\Initialize-Labels.ps1 -DryRun

    Shows what labels would be created without making any changes.

.NOTES
    Requires: GitHub CLI (gh) installed and authenticated
#>
[CmdletBinding()]
param(
    [Parameter()]
    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'

# Verify gh CLI is available
if (-not (Get-Command 'gh' -ErrorAction SilentlyContinue)) {
    Write-Error 'GitHub CLI (gh) is not installed. Install from https://cli.github.com/'
    return
}

# Verify gh is authenticated
$null = gh auth status 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Error 'GitHub CLI is not authenticated. Run: gh auth login'
    return
}

# Label definitions: Name, Color (hex without #), Description
$labels = @(
    @{ Name = 'ai-task'; Color = '7057ff'; Description = 'Structured task for AI coding agents' }
    @{ Name = 'ai-ready'; Color = '0e8a16'; Description = 'Ready for an AI agent to pick up' }
    @{ Name = 'ai-in-progress'; Color = 'fbca04'; Description = 'An AI agent is working on this' }
    @{ Name = 'ai-review'; Color = '1d76db'; Description = 'AI-generated PR needs human review' }
    @{ Name = 'ai-blocked'; Color = 'b60205'; Description = 'AI agent is blocked and needs human help' }
    @{ Name = 'good-first-issue'; Color = '7057ff'; Description = 'Good for newcomers (human or AI)' }
    @{ Name = 'priority-high'; Color = 'b60205'; Description = 'High priority' }
    @{ Name = 'priority-medium'; Color = 'fbca04'; Description = 'Medium priority' }
    @{ Name = 'priority-low'; Color = '0e8a16'; Description = 'Low priority' }
)

Write-Host ''
Write-Host 'Initializing GitHub Labels' -ForegroundColor Cyan
Write-Host '==========================' -ForegroundColor Cyan

foreach ($label in $labels) {
    $name = $label.Name
    $color = $label.Color
    $description = $label.Description

    if ($DryRun) {
        Write-Host "  [DRY RUN] Would create: $name ($description)" -ForegroundColor Yellow
    } else {
        Write-Host "  Creating label: $name ... " -NoNewline
        $result = gh label create $name --color $color --description $description --force 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host 'OK' -ForegroundColor Green
        } else {
            Write-Host "FAILED: $result" -ForegroundColor Red
        }
    }
}

Write-Host ''
Write-Host "Done. $($labels.Count) labels processed." -ForegroundColor Green
if ($DryRun) {
    Write-Host 'This was a dry run. Run without -DryRun to apply changes.' -ForegroundColor Yellow
}
