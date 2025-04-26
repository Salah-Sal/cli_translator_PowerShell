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
        $OriginalJobsDir = $null
        $OriginalPromptsDir = $null # Add variable for PROMPTS_DIR

        BeforeEach {
            $OriginalArticlesDir = $env:ARTICLES_DIR
            $env:ARTICLES_DIR = 'C:\TestArticlesFromEnv'

            $OriginalJobsDir = $env:JOBS_DIR
            $env:JOBS_DIR = 'C:\TestJobsFromEnv'

            $OriginalPromptsDir = $env:PROMPTS_DIR # Setup for PROMPTS_DIR
            $env:PROMPTS_DIR = 'C:\TestPromptsFromEnv' # Test value for PROMPTS_DIR
        }

        AfterEach {
            # Restore ArticlesDir
            if ($null -ne $OriginalArticlesDir) { $env:ARTICLES_DIR = $OriginalArticlesDir } else { Remove-Item Env:\ARTICLES_DIR -ErrorAction SilentlyContinue }
            # Restore JobsDir
            if ($null -ne $OriginalJobsDir) { $env:JOBS_DIR = $OriginalJobsDir } else { Remove-Item Env:\JOBS_DIR -ErrorAction SilentlyContinue }
            # Teardown for PROMPTS_DIR
            if ($null -ne $OriginalPromptsDir) { $env:PROMPTS_DIR = $OriginalPromptsDir } else { Remove-Item Env:\PROMPTS_DIR -ErrorAction SilentlyContinue }
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

        # New failing test for PROMPTS_DIR
        It 'Should return the PROMPTS_DIR path from the environment variable when set' {
            $Params = @{
                ProjectRoot = $script:ProjectRoot
            }
            $Config = Get-TranslatorConfiguration @Params
            $Config.PromptsDir | Should -Be 'C:\TestPromptsFromEnv'
        }
    }
    
    Context 'Uses default paths when environment variables are NOT set' {
        
        BeforeEach {
            # Ensure environment variables that have defaults are UNSET for these tests
            Remove-Item Env:\ARTICLES_DIR -ErrorAction SilentlyContinue
            Remove-Item Env:\JOBS_DIR -ErrorAction SilentlyContinue
            Remove-Item Env:\PROMPTS_DIR -ErrorAction SilentlyContinue
        }

        # Test uses $script:ProjectRoot defined in BeforeAll
        It 'Should return the default Articles path relative to project root when ARTICLES_DIR env var is not set' {
            $ExpectedPath = Join-Path $script:ProjectRoot 'Articles'
            $Params = @{
                ProjectRoot = $script:ProjectRoot
            }
            $Config = Get-TranslatorConfiguration @Params
            $Config.ArticlesDir | Should -Be $ExpectedPath
        }
    }

    # Add other Context blocks and It blocks later following TDD

} 