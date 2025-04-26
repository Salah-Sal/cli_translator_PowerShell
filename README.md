# Markdown Translator CLI (PowerShell)

PowerShell-based CLI tool for translating Markdown files using LLMs via the `llm` CLI.

This project follows a strict Test-Driven Development (TDD) approach using Pester and emphasizes clean architecture principles.

## Current Status (as of end of session YYYY-MM-DD)

*   **Project Setup (Issue #1):** Completed.
    *   Standard project directory structure (`Scripts`, `Tests`, `Articles`, etc.) created.
    *   Local Git repository initialized and connected to the remote GitHub repository (`Salah-Sal/cli_translator_PowerShell`).
    *   Essential files created: `.gitignore`, `README.md`, `LICENSE`, `CONTRIBUTING.md`, `Tests/Project.Tests.ps1`.
    *   Pester v5.7.1 installed. (Note: A discovery issue exists when running `Invoke-Pester` from the project root - see `CONTRIBUTING.md` for details).
    *   `CONTRIBUTING.md` updated with detailed workflow, TDD guidelines, and troubleshooting notes.
*   **Core Configuration Loading (Issue #2):** Completed.
    *   Test file `Tests/Config.Tests.ps1` created and implemented with 8 tests covering env vars and default paths for `ArticlesDir`, `JobsDir`, `PromptsDir`, and `OpenAiApiKey`.
    *   Implementation file `Scripts/Lib/Config.ps1` created with `Get-TranslatorConfiguration` function, accepting mandatory `ProjectRoot` parameter.

## Next Steps

*   Resolve the Pester discovery issue noted in `CONTRIBUTING.md` (Ongoing investigation).
*   Proceed with **Issue #3: Implement Basic Article Discovery**.
*   Address creation of `.env.example` file (skipped earlier due to tool limitations).

## Getting Started

Refer to the `CONTRIBUTING.md` file for detailed prerequisites, setup instructions, and the full development workflow.

*(More details will be added as the project progresses)* 