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
*   **Core Configuration Loading (Issue #2):** In progress.
    *   Test file `Tests/Config.Tests.ps1` created with initial failing tests for environment variable loading.
    *   Implementation file `Scripts/Lib/Config.ps1` created with the basic `Get-TranslatorConfiguration` function definition.

## Next Steps

*   Complete the implementation of `Get-TranslatorConfiguration` following the TDD cycle (Green and Refactor steps for Issue #2).
*   Resolve the Pester discovery issue noted in `CONTRIBUTING.md`.
*   Proceed with subsequent issues (e.g., Article Discovery).

## Getting Started

Refer to the `CONTRIBUTING.md` file for detailed prerequisites, setup instructions, and the full development workflow.

*(More details will be added as the project progresses)* 