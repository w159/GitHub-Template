BeforeAll {
    # Find and import TestHelper (works at any directory depth under Tests/)
    $testDir = $PSScriptRoot
    while ($testDir -and !(Test-Path (Join-Path $testDir 'TestHelpers/TestHelper.psm1'))) {
        $testDir = Split-Path -Parent $testDir
    }
    Import-Module (Join-Path $testDir 'TestHelpers/TestHelper.psm1') -Force
    $script:Module = Initialize-TestModule
}

Describe 'ConvertTo-InternalFormat' -Tag 'Unit', 'Private' {

    Context 'Function Visibility' {
        It 'Should exist as a function in the module' {
            InModuleScope $script:Module.Name {
                Get-Command -Name 'ConvertTo-InternalFormat' -ErrorAction SilentlyContinue |
                    Should -Not -BeNullOrEmpty
            }
        }

        It 'Should not be exported from the module' {
            Get-Command -Module $script:Module.Name -Name 'ConvertTo-InternalFormat' -ErrorAction SilentlyContinue |
                Should -BeNullOrEmpty
        }
    }

    Context 'Functionality' {
        It 'Should process input correctly' {
            InModuleScope $script:Module.Name {
                $result = ConvertTo-InternalFormat -InputData 'TestValue'
                $result | Should -Not -BeNullOrEmpty
            }
        }

        It 'Should return expected output' {
            InModuleScope $script:Module.Name {
                $result = ConvertTo-InternalFormat -InputData 'TestValue'
                $result.ProcessedData | Should -Be 'TestValue'
            }
        }
    }

    Context 'Error Handling' {
        It 'Should throw on null input' {
            InModuleScope $script:Module.Name {
                { ConvertTo-InternalFormat -InputData $null } | Should -Throw
            }
        }

        It 'Should throw on empty string input' {
            InModuleScope $script:Module.Name {
                { ConvertTo-InternalFormat -InputData '' } | Should -Throw
            }
        }
    }

    Context 'Mocking Dependencies' {
        It 'Should demonstrate mocking within module scope' {
            InModuleScope $script:Module.Name {
                # Mock a dependency called by the private function
                # Variables must be declared inside InModuleScope - outer scope is not accessible
                Mock Get-Date { return [datetime]'2025-01-01' }

                $result = ConvertTo-InternalFormat -InputData 'TestValue'
                $result.ProcessedAt | Should -Be ([datetime]'2025-01-01')

                Should -Invoke Get-Date -Times 1
            }
        }
    }
}

AfterAll {
    if ($script:Module) {
        Remove-Module -Name $script:Module.Name -Force -ErrorAction SilentlyContinue
    }
    Remove-Module -Name 'TestHelper' -Force -ErrorAction SilentlyContinue
}
