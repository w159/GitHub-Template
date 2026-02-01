BeforeAll {
    # Find and import TestHelper (works at any directory depth under Tests/)
    $testDir = $PSScriptRoot
    while ($testDir -and !(Test-Path (Join-Path $testDir 'TestHelpers/TestHelper.psm1'))) {
        $testDir = Split-Path -Parent $testDir
    }
    Import-Module (Join-Path $testDir 'TestHelpers/TestHelper.psm1') -Force
    $script:Module = Initialize-TestModule
}

Describe 'ModuleName Integration' -Tag 'Integration' {

    Context 'Function Pipeline' {
        It 'Should pass output from one function as input to another' {
            # Example: Test that functions work together in a pipeline
            # $result = Get-Something | Set-Something
            # $result | Should -Not -BeNullOrEmpty
        }
    }

    Context 'End-to-End Workflow' {
        It 'Should complete a full workflow successfully' {
            # Example: Test a complete user scenario
            # $setup = Initialize-Something -Name 'Test'
            # $processed = Invoke-Something -Input $setup
            # $result = Complete-Something -Input $processed
            # $result.Status | Should -Be 'Completed'
        }
    }

    Context 'External Dependency Mocking' {
        It 'Should handle mocked external commands' {
            # Example: Mock external commands the module depends on
            # Mock Invoke-RestMethod -ModuleName $script:Module.Name {
            #     return @{ status = 'ok'; data = @('item1', 'item2') }
            # }
            #
            # $result = Get-ExternalData
            # $result.Count | Should -Be 2
            # Should -Invoke Invoke-RestMethod -ModuleName $script:Module.Name -Times 1
        }
    }
}

AfterAll {
    if ($script:Module) {
        Remove-Module -Name $script:Module.Name -Force -ErrorAction SilentlyContinue
    }
    Remove-Module -Name 'TestHelper' -Force -ErrorAction SilentlyContinue
}
