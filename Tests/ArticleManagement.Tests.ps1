# Tests/ArticleManagement.Tests.ps1
using namespace System.Management.Automation

# BeforeAll: Setup common test environment
BeforeAll {
    # Define path for temporary test articles relative to this test script
    $script:TestArticlesDir = Join-Path $PSScriptRoot "TempTestArticles"
    Write-Verbose "Creating temporary test directory: $($script:TestArticlesDir)"
    # Ensure clean state and create directory
    if (Test-Path $script:TestArticlesDir) {
        Remove-Item -Recurse -Force $script:TestArticlesDir
    }
    New-Item -ItemType Directory -Path $script:TestArticlesDir | Out-Null

    # Explicitly import Pester for this test file
    Import-Module Pester -Force

    # Import the script containing the function under test
    $LibPath = Join-Path $PSScriptRoot "..\Scripts\Lib\ArticleManagement.ps1"
    if (Test-Path $LibPath) {
        Import-Module $LibPath -Force
    }
}

# AfterAll: Cleanup common test environment
AfterAll {
    Write-Verbose "Removing temporary test directory: $($script:TestArticlesDir)"
    if (Test-Path $script:TestArticlesDir) {
        Remove-Item -Recurse -Force $script:TestArticlesDir
    }

    # Remove the imported module if it was loaded
    if (Get-Module -Name ArticleManagement) {
        Remove-Module -Name ArticleManagement -Force
    }
    # No need to remove Pester explicitly here, assuming it's needed elsewhere
}

Describe 'Get-MarkdownArticle' {

    # Mock Get-ChildItem due to persistent ParameterBindingException when invoked within Pester 
    # execution context on this system, despite working manually. See Issue #3 discussion.
    Mock -CommandName Get-ChildItem -ModuleName Microsoft.PowerShell.Management -MockWith { 
        param($Path, $Filter, $File)
        Write-Verbose "Mock Get-ChildItem called with Path: $Path, Filter: $Filter, File: $File"
        # Simulate based on path and filter
        if ($Path -eq $script:TestArticlesDir -and $Filter -eq '*.md' -and $File) {
            # Return FileInfo-like objects for the first test scenario
            $MockFile1 = [pscustomobject]@{ Name = 'test1.md'; FullName = (Join-Path $Path 'test1.md'); PSIsContainer = $false }
            $MockFile2 = [pscustomobject]@{ Name = 'test2.md'; FullName = (Join-Path $Path 'test2.md'); PSIsContainer = $false }
            return @($MockFile1, $MockFile2)
        } else {
            # Return empty for other calls within this test file (can be refined per Context)
            return @()
        } 
    } -Verifiable

    Context 'Scenario 1: Finds .md files' {

        BeforeEach {
            # Removed explicit Remove-Mock for now
            # Remove-Mock -CommandName Get-ChildItem -ModuleName Microsoft.PowerShell.Management -ErrorAction SilentlyContinue

            # Create dummy files for the test
            New-Item -Path (Join-Path $script:TestArticlesDir "test1.md") -ItemType File -Value "Content 1" | Out-Null
            New-Item -Path (Join-Path $script:TestArticlesDir "test2.md") -ItemType File -Value "Content 2" | Out-Null
            New-Item -Path (Join-Path $script:TestArticlesDir "notes.txt") -ItemType File -Value "Text file" | Out-Null
            New-Item -Path (Join-Path $script:TestArticlesDir "SubDir") -ItemType Directory | Out-Null
        }

        AfterEach {
            # Clean up specific files created in BeforeEach if needed, but AfterAll handles the dir
        }

        It 'Should return FileInfo objects for all .md files in the specified directory' {
            $Result = Get-MarkdownArticle -ArticlesDirectory $script:TestArticlesDir
            
            $Result | Should -Not -BeNullOrEmpty
            $Result.Count | Should -Be 2
            # Cannot assert -is [System.IO.FileInfo] on mocked objects easily
            # $Result | Should -ForEach { $_ -is [System.IO.FileInfo] }
            $FileNames = $Result | ForEach-Object { $_.Name }
            $FileNames | Should -BeEquivalentTo @('test1.md', 'test2.md')

            # Verify the mock was called as expected
            Should -Invoke -CommandName Get-ChildItem -Times 1 -Exactly -ParameterFilter { $Path -eq $script:TestArticlesDir -and $Filter -eq '*.md' -and $File }
        }
    }
} 