**Project Implementation Plan: Markdown Translator CLI (PowerShell) - v1.3**

**Prepared For:** Project Lead Developer
**Date:** 2025-04-26 (Placeholder - Updated)
**Version:** 1.3 (Adds Real-World UX Testing Stages)

**1. Introduction**

This document outlines the proposed implementation plan for the Markdown Translator CLI project. The goal is to build a PowerShell-based command-line tool for translating Markdown files using external LLM tools, adhering strictly to Test-Driven Development (TDD) principles with Pester. This plan breaks down the project into logical phases and tasks, incorporating stages for **Real-World User Experience (UX) Testing** to ensure the CLI is practical and user-friendly. **Phase 1 is complete.**

**2. Project Goal Recap**

To create a robust, testable, **and user-friendly** PowerShell CLI application for translating Markdown files via the `llm` CLI, featuring chunking, model selection, prompt usage, and job management capabilities.

**3. Core Methodology**

*   **Language:** PowerShell 7+
*   **Testing:**
    *   Pester (TDD: Red-Green-Refactor for unit/integration tests)
    *   **Manual UX Testing** (Real-world scenarios)
*   **Version Control:** Git, GitHub
*   **Workflow:** Issue-Driven Development via GitHub CLI (`gh`), Conventional Commits, Mandatory PRs for merges to `main`.
*   **External Tools:** `llm`, `jq`, `git`, `gh`.

**4. Assumptions**

*   Development environment is set up.
*   Pester module is functional.
*   Necessary permissions are available.
*   Lead Developer provides detailed Issue content.
*   **Developer has access to configured `llm` CLI with at least one working API key for UX testing phases.**

**5. Phased Implementation Plan**

*(Note: Issue numbers are sequential placeholders. UX Testing tasks are added.)*

**Phase 1: Foundation & Setup (Issues #1-2) - ✅ COMPLETED**

*   **Goal:** Establish the repository structure, core tooling, configuration handling, and basic testing setup.
*   **Issue #1: Project Setup & Foundational Structure** - ✅ **Done**
*   **Issue #2: Implement Core Configuration Loading** - ✅ **Done**

**Phase 2: Core Article & Chunking Logic (Issues #3-5) - ▶️ NEXT**

*   **Goal:** Implement the ability to find, read, and split Markdown articles.
*   **Issue #3: Implement Basic Article Discovery** - ▶️ **Next Task**
    *   *(Details as before - Implement `Get-MarkdownArticle`)*
*   **Issue #4: Implement Basic Article Reading**
    *   *(Details as before - Implement `Read-MarkdownArticle`)*
*   **Issue #5: Implement Basic Chunking Logic (Paragraph Split)**
    *   *(Details as before - Implement `Split-MarkdownToParagraph`)*

**Phase 3: LLM Interaction & Basic Translation (Issues #6-7)**

*   **Goal:** Connect to the `llm.exe` tool and establish a basic, single-chunk translation pathway.
*   **Issue #6: Implement LLM Interaction Wrapper**
    *   *(Details as before - Implement `Invoke-LLMPrompt`, mock `llm.exe` heavily)*
*   **Issue #7: Implement Basic Single-Chunk Translation Flow**
    *   *(Details as before - Test orchestration logic using mocks)*

**Phase 4: CLI Structure & Initial User Interaction (Issues #8-~11)**

*   **Goal:** Build the main CLI entry point and allow users to select input files and basic options through terminal menus.
*   **Issue #8: Implement Main CLI Entry Point & Basic Menu**
    *   *(Details as before - Structure `Start-MarkdownTranslatorCli.ps1`, basic `Show-MainMenu`, menu loop)*
*   **Issue #9 (Example): Implement Article Selection Menu**
    *   **Overall Fit:** Provides the first interactive step for the user: choosing the input file.
    *   **TDD Focus:** Test the menu display (mock `Get-MarkdownArticle`), user input handling (mock `Read-Host`), and state update (setting a selected article variable).
    *   **Tasks:** Implement `Show-ArticleSelectionMenu` in `UIHelpers.ps1`. Integrate call into main menu loop. Store selected article path.
*   **Issue #10 (Example): Implement Model Selection Menu (Basic)**
    *   **Overall Fit:** Allows user selection of the LLM (initially maybe just a hardcoded list).
    *   **TDD Focus:** Test menu display, input handling, state update.
    *   **Tasks:** Implement `Show-ModelSelectionMenu`. Integrate. Store selection.
*   **Issue #11 (Example): Implement Prompt Selection Menu (Basic)**
    *   **Overall Fit:** Allows user selection of a system prompt file.
    *   **TDD Focus:** Test listing files from `Prompts/` (mock `Get-ChildItem`), menu display, input handling, state update.
    *   **Tasks:** Implement `Show-PromptSelectionMenu`. Integrate. Store selection.

**Phase 5: First End-to-End Workflow & UX Test (Issues #12-13)**

*   **Goal:** Combine the components developed so far to achieve a *basic* end-to-end translation of a *single chunk* (the first paragraph) of a *real* article, and perform initial usability testing.
*   **Issue #12: Integrate Basic End-to-End Translation (First Chunk)**
    *   **Overall Fit:** Connects the user selections (article, model) to the backend logic (read, chunk, translate) for the simplest possible case.
    *   **TDD Focus:** Primarily integration tests mocking components, but verifying the *flow* that uses the selected article/model state to call `Read-MarkdownArticle`, `Split-MarkdownToParagraph` (getting first chunk), and `Invoke-LLMPrompt`. Test that the final (mocked) output is displayed or saved appropriately.
    *   **Tasks:** Modify `Start-MarkdownTranslatorCli.ps1` or a dedicated function. Add a "Start Translation" option to the main menu (enabled when selections are made). Implement the logic to: get config, get user selections, read selected article, get first chunk, get selected model, invoke LLM, display result to console.
*   **Issue #13: Initial Real-World UX Test (Single Chunk)**
    *   **Overall Fit:** Provides the first critical feedback loop based on actual usage, identifying usability issues, unexpected behavior with real files/LLMs, and unclear instructions/output **before** implementing more complex logic like multi-chunk handling.
    *   **TDD Focus:** **None.** This is manual testing.
    *   **Tasks:**
        *   Manually run `Start-MarkdownTranslatorCli.ps1` from the PowerShell terminal.
        *   Use the menus to select a *real* (but potentially short) Markdown file from the `Articles` directory.
        *   Select a *real*, configured model using the menu.
        *   Select a *real* prompt file (or a "none" option).
        *   Trigger the "Start Translation" option.
        *   **Evaluate:**
            *   Is the menu navigation clear and intuitive?
            *   Are prompts (`Read-Host`) easy to understand?
            *   Does it correctly translate the *first paragraph* using the selected model/prompt via the `llm` tool?
            *   Is the output displayed clearly in the terminal?
            *   Are there any unexpected errors or hangs?
            *   Does it handle basic errors gracefully (e.g., article not found - although this should be prevented by selection)?
        *   **Document:** Create a new GitHub Issue (e.g., Issue #14 - UX Feedback Round 1) detailing findings, bugs, and usability suggestions based on this manual test.
    *   **Review:** Lead Dev reviews the documented UX feedback. Necessary fixes/improvements might spawn new `fix:` or `refactor:` Issues before proceeding.

**Phase 6: Full Translation Workflow & Chunk Handling (Issues #14-TBD)**

*   **Goal:** Implement the complete multi-chunk translation process and saving the final result.
*   **Issue #14 (Example): Implement Multi-Chunk Processing Loop & Assembly**
    *   *(Details as before - Implement loop, call LLM for each chunk, basic concatenation)*
*   **Issue #15 (Example): Implement Saving Final Translation**
    *   *(Details as before - Save assembled string to output file)*
*   **Issue #16 (Example): Refine Chunking (Size/Overlap)**
    *   *(Details as before - Implement more advanced splitting)*

**Phase 7: Second End-to-End Workflow & UX Test (Issue #17)**

*   **Goal:** Test the complete multi-chunk translation workflow with real files and LLMs, focusing on output quality, performance, and handling of larger files.
*   **Issue #17: Full Workflow Real-World UX Test**
    *   **TDD Focus:** **None.** Manual testing.
    *   **Tasks:**
        *   Manually run `Start-MarkdownTranslatorCli.ps1`.
        *   Select a *longer, more complex* real Markdown file.
        *   Select real models/prompts.
        *   Run the full translation.
        *   **Evaluate:**
            *   Does the chunking work correctly (visually inspect output file)?
            *   Is the progress indication helpful (if implemented)?
            *   How is the performance for a larger file?
            *   Is the final assembled output file correct and well-formatted?
            *   Does it handle potential errors during *one* of the chunk translations (e.g., LLM API error)? How does it report this?
            *   Any regressions from the first UX test?
        *   **Document:** Update the UX Feedback Issue or create a new one (e.g., Issue #18 - UX Feedback Round 2) with findings.
    *   **Review:** Lead Dev reviews feedback. Prioritize critical bug fixes before moving to Job Management.

**Phase 8: Job Management & Resumption (Issues #18-TBD)**

*   **Goal:** Add persistence and resumption capabilities.
*   **Tasks:** Implement Job Directory creation, Metadata Handling (using `jq`), saving intermediate chunks, status checking, resumption logic.

**Phase 9: Job Management UX Test (Issue #X)**

*   **Goal:** Test the job management features (starting, interrupting, resuming, viewing) from a user perspective.
*   **Issue #X: Job Management Real-World UX Test**
    *   **TDD Focus:** **None.** Manual testing.
    *   **Tasks:**
        *   Start a translation, interrupt it (Ctrl+C).
        *   Run the tool again, use the "Resume Job" feature.
        *   Verify it picks up correctly based on created job files/metadata.
        *   Test viewing job archives/status.
        *   Test deleting jobs.
        *   **Evaluate:** Is the job management workflow intuitive? Is status information clear? Does resumption work reliably?
        *   **Document:** Feedback in relevant Issue.
    *   **Review:** Lead Dev reviews feedback.

**Phase 10: Enhancements & Refinement (Issues TBD)**

*   **Goal:** Improve usability, error handling, robustness based on prior phases and UX feedback.
*   **Tasks:** Advanced error handling, UI improvements, retry logic, refactoring into Modules. Final polish based on overall UX.

**6. Timeline**

*   Timeline estimates need slight adjustment to account for UX testing and potential rework based on feedback. Each UX test phase might add 0.5-1 day depending on findings.

**7. Review Process**

*   Includes review of documented UX testing feedback in addition to PR reviews.

**8. Potential Risks & Challenges**

*   Adds risk: UX testing might reveal significant usability issues requiring larger refactoring than anticipated. Subjectivity of "good" UX.

