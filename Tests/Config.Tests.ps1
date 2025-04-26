# Placeholder for Configuration Tests 

using namespace System.Management.Automation

# Dot-source the configuration script. Use $PSScriptRoot for reliable pathing.
# Moved dot-sourcing into BeforeAll block for more reliable execution scope.
# . "$($PSScriptRoot)\..\Scripts\Lib\Config.ps1"

BeforeAll {
    # Determine Project Root relative to *this test file's* location
    $script:ProjectRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
    Write-Verbose "Project Root determined by test: $($script:ProjectRoot)"

    # Dot-source the function script *after* calculating ProjectRoot
    . (Join-Path $script:ProjectRoot 'Scripts\Lib\Config.ps1')
}

Describe 'Get-TranslatorConfiguration' {

    Context 'Loads paths from environment variables' {
        
        # Store original env var values before each test and restore after
        $OriginalArticlesDir = $null
        $OriginalJobsDir = $null # Add variable for JOBS_DIR

        BeforeEach {
            $OriginalArticlesDir = $env:ARTICLES_DIR
            $env:ARTICLES_DIR = 'C:\TestArticlesFromEnv' # Test value

            $OriginalJobsDir = $env:JOBS_DIR # Setup for JOBS_DIR
            $env:JOBS_DIR = 'C:\TestJobsFromEnv' # Test value for JOBS_DIR
        }

        AfterEach {
            # Restore original value or remove if it didn't exist
            if ($null -ne $OriginalArticlesDir) {
                $env:ARTICLES_DIR = $OriginalArticlesDir
            } else {
                Remove-Item Env:\ARTICLES_DIR -ErrorAction SilentlyContinue
            }

            # Teardown for JOBS_DIR
            if ($null -ne $OriginalJobsDir) {
                $env:JOBS_DIR = $OriginalJobsDir
            } else {
                Remove-Item Env:\JOBS_DIR -ErrorAction SilentlyContinue
            }
        }

        It 'Should return the ARTICLES_DIR path from the environment variable when set' {
            # Use splatting for cleaner parameter passing
            $Params = @{
                ProjectRoot = $script:ProjectRoot
            }
            $Config = Get-TranslatorConfiguration @Params
            $Config.ArticlesDir | Should -Be 'C:\TestArticlesFromEnv'
        }

        # New failing test for JOBS_DIR
        It 'Should return the JOBS_DIR path from the environment variable when set' {
            $Params = @{
                ProjectRoot = $script:ProjectRoot
            }
            $Config = Get-TranslatorConfiguration @Params
            $Config.JobsDir | Should -Be 'C:\TestJobsFromEnv'
        }
    }
    
    # Add other Context blocks and It blocks later following TDD

} 