# Contributing Guidelines

Details on the development workflow (TDD, Git, gh, PRs) will be documented here based on the Project Lead Guide. 

## Troubleshooting Notes

### Initial Pester Discovery Issue (Resolved)

During initial project setup (Issue #1), we encountered a persistent issue where `Invoke-Pester` failed to discover the test file (`Tests\Project.Tests.ps1`) when run from the project root, consistently reporting 0 tests found.

**Symptoms:**
*   `Invoke-Pester` (run from project root) output: `Tests Passed: 0, Failed: 0, Skipped: 0...`
*   Confirmed Pester v5.7.1 was installed and active.
*   Test file `Tests\Project.Tests.ps1` existed with correct naming and basic Pester v5 syntax.
*   Execution Policy (`RemoteSigned`) was confirmed not to be the cause.
*   Recreating the test file (to rule out encoding issues) did not help.
*   Explicitly targeting the path (`Invoke-Pester -Path .\Tests`, `Invoke-Pester -Script .\Tests\Project.Tests.ps1`) did not help when run from the root.

**Troubleshooting Steps:**
Several commands required manual execution by the developer due to limitations or errors in the AI assistant's terminal interaction tooling, particularly with complex commands, interactive prompts, or specific path types:
*   `gh issue create` (initially)
*   `git commit`
*   `Install-Module Pester` (due to NuGet prompt)
*   Various `Invoke-Pester` variations for diagnostics.
*   File creation (`Set-Content`) and inspection (`Get-Content -Encoding Byte`) outside the primary workspace during diagnostics.

**Resolution/Diagnosis:**
A diagnostic test was performed by creating a minimal test file (`minimal.Tests.ps1`) in a temporary subdirectory (`D:\ML-Projects\machine-translation\translator_win\.tmp\PesterCheck`) and running `Invoke-Pester` *from within that subdirectory*.
*   **Result:** Pester **successfully** discovered and ran the test (1 test passed) in this isolated scenario.
*   **Conclusion:** The core Pester v5 installation is functional. The issue is specific to test *discovery* when `Invoke-Pester` is executed from the project root (`D:\ML-Projects\machine-translation\translator_win`) and targets the `.\Tests` subdirectory. The exact cause (e.g., hidden configuration, permissions on `.\Tests`, path resolution quirk from root) is still under investigation but localized to this specific context.

**Tooling Note:**
The AI assistant encountered limitations executing certain commands involving interactive prompts, multi-line inputs, absolute paths outside the workspace for file edits, and potentially complex PowerShell variable/command chaining via its `run_terminal_cmd` tool. Manual execution was used as a workaround for these specific commands. 
*   **Commit Verification:** Additionally, the assistant may sometimes fail to recognize if a `git commit` command succeeded on the first try, potentially due to incomplete terminal output capture. It might retry the command unnecessarily. Developer confirmation of successful commits is helpful in these cases. 