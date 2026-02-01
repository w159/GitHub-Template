BeforeAll {
    # Find and import TestHelper (works at any directory depth under Tests/)
    $testDir = $PSScriptRoot
    while ($testDir -and !(Test-Path (Join-Path $testDir 'TestHelpers/TestHelper.psm1'))) {
        $testDir = Split-Path -Parent $testDir
    }
    Import-Module (Join-Path $testDir 'TestHelpers/TestHelper.psm1') -Force
    $script:Module = Initialize-TestModule
}

Describe 'Get-ModuleInfo' -Tag 'Unit', 'Public' {
    Context 'Functionality' {
        It 'Should return a PSCustomObject' {
            $result = Get-ModuleInfo
            $result | Should -BeOfType [PSCustomObject]
        }

        It 'Should have expected properties' {
            $result = Get-ModuleInfo
            $result.PSObject.Properties.Name | Should -Contain 'Name'
            $result.PSObject.Properties.Name | Should -Contain 'Version'
            $result.PSObject.Properties.Name | Should -Contain 'Author'
            $result.PSObject.Properties.Name | Should -Contain 'Description'
        }

        It 'Should return the correct module name' {
            $result = Get-ModuleInfo
            $result.Name | Should -Be $script:Module.Name
        }

        It 'Should return a valid version number' {
            $result = Get-ModuleInfo
            $result.Version | Should -Not -BeNullOrEmpty
            { [version]$result.Version } | Should -Not -Throw
        }

        It 'Should return PowerShell version requirement' {
            $result = Get-ModuleInfo
            $result.PowerShellVersion | Should -Not -BeNullOrEmpty
        }
    }

    Context 'Output Format' {
        It 'Should have PSTypeName set correctly' {
            $result = Get-ModuleInfo
            $result.PSObject.TypeNames | Should -Contain "$($script:Module.Name).ModuleInfo"
        }
    }
}

AfterAll {
    if ($script:Module) {
        Remove-Module -Name $script:Module.Name -Force -ErrorAction SilentlyContinue
    }
    Remove-Module -Name 'TestHelper' -Force -ErrorAction SilentlyContinue
}
