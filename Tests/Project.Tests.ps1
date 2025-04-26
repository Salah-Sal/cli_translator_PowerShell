# Tests/Project.Tests.ps1
using namespace System.Management.Automation

BeforeAll {
    # Any global setup for tests if needed in the future
}

Describe 'Project Setup' {
    Context 'Initial Pester Verification' {
        It 'Should be able to execute a basic assertion' {
            1 | Should -Be 1
        }
    }
} 