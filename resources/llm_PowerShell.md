# PowerShell Scripting Guide for the LLM CLI Tool

This guide provides a comprehensive introduction to PowerShell scripting, specifically aimed at developers using Windows who want to leverage the `llm` CLI utility effectively. We'll cover the fundamentals of PowerShell and demonstrate how to use them with `llm` for various tasks.

## 1. What is PowerShell?

PowerShell is a cross-platform task automation solution made up of a command-line shell, a scripting language, and a configuration management framework. It runs on Windows, Linux, and macOS. On Windows, it's the modern replacement for the Command Prompt (`cmd.exe`).

PowerShell works with structured data (objects) in addition to text streams, but it interacts seamlessly with traditional command-line executables like `llm.exe`.

**Why use PowerShell with `llm` on Windows?**

* **Modern Windows Scripting:** It's the standard, powerful scripting environment for Windows.
* **Automation:** Run complex sequences of `llm` commands without typing them manually.
* **Integration:** Combine `llm` with native Windows commands (Cmdlets), .NET objects, and other CLI tools (`git`, `curl`, etc.).
* **Data Processing:** Pipe data into and out of `llm`. PowerShell's object pipeline offers advanced manipulation possibilities, though simple text piping works fine with `llm`.
* **Batch Operations:** Run prompts against multiple inputs or with different parameters using PowerShell loops.

## 2. PowerShell Scripting Fundamentals

### a. Script Files (`.ps1`)

PowerShell scripts are saved in plain text files with a `.ps1` extension.

### b. Running Scripts & Execution Policy

By default, Windows often prevents the execution of PowerShell scripts for security reasons. You might need to adjust the Execution Policy.

1.  **Check Policy:** Open PowerShell **as Administrator** and run:
    ```powershell
    Get-ExecutionPolicy
    ```
    If it's `Restricted`, you can't run scripts. `AllSigned` requires scripts to be digitally signed. `RemoteSigned` (common default) allows local scripts but requires downloaded scripts to be signed. `Unrestricted` allows all scripts.

2.  **Change Policy (If Needed):** To allow running local scripts (use with caution):
    ```powershell
    # Run as Administrator
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
    # Or for testing (less secure):
    # Set-ExecutionPolicy Unrestricted -Scope CurrentUser
    ```
    Confirm the change when prompted. `-Scope CurrentUser` is generally safer than changing it system-wide.

3.  **Run the script:** Navigate to the script's directory in PowerShell and run it:
    ```powershell
    .\my_llm_script.ps1
    ```
    The `.\` explicitly tells PowerShell to run the script from the current directory.

### c. Comments

Use the hash symbol (`#`) for comments.

```powershell
# This is a comment explaining the script's purpose.
Write-Host "Running an LLM prompt..." # This is an inline comment
# Call the llm executable
llm.exe "Summarize the concept of PowerShell scripting in one sentence."
```

_`` `(Note: We use llm.exe explicitly here for clarity, though just llm often works if it's in the PATH)` ``_

### d. Variables

Variables start with a dollar sign (`$`). Define them with an equals sign (=). PowerShell is type-aware but often infers types.

```shell
# Define variables
$ModelName = "gpt-4o-mini"
$PromptText = "Explain the difference between single and double quotes in PowerShell."
$OutputFile = "powershell_quotes_explanation.txt"

Write-Host "Using model: $ModelName"

# Use variables in commands
# Note: When calling external executables like llm.exe, pass arguments separately
# If the prompt contains spaces, it MUST be quoted. Double quotes allow variable expansion.
llm.exe -m $ModelName "$PromptText" | Out-File -FilePath $OutputFile -Encoding utf8

Write-Host "Output saved to $OutputFile"
```

### e. Quotes

- **`Double Quotes ("):`** Allow variable substitution (`$variable`) and sub-expression evaluation (`$(expression)`). The backtick (`` ` ``) is the escape character (e.g., `` `" `` for a literal quote).
    
- **`Single Quotes ('):`** Treat _everything_ literally. No variable substitution or expression evaluation occurs.
    

```
$Greeting = "Hello"
$Target = "World"

Write-Host "$Greeting, $Target!" # Output: Hello, World!
Write-Host '$Greeting, $Target!' # Output: $Greeting, $Target!
```

Use double quotes when passing prompts to `llm.exe` if you need variables expanded within the prompt string.

### f. Command Output & Sub-expressions (`$(...)`)

To use the output of one command within another string or as an argument, enclose the command in `$()`. You can also assign command output directly to variables.

```
# Get OS info (PowerShell way) and ask llm about it
# Note: Get-ComputerInfo might require Admin rights or specific modules
# Using a simpler example: Get current directory path
$CurrentPath = $(Get-Location).Path
Write-Host "Current Path: $CurrentPath"
llm.exe "Tell me about the significance of the current working directory: $CurrentPath"

# Get latest git commit message and summarize it
# Ensure git.exe is in your PATH
$LatestCommitMsg = $(git log -1 --pretty=%B)
llm.exe "Provide a one-sentence summary of this git commit message: $LatestCommitMsg"

# Assign output to variable
$Names = llm.exe "Three fun names for a pet hamster"
Write-Host "Generated Names: $Names"
```

### g. Piping (`|`)

The pipe symbol (`|`) sends the output (objects or text) of one command to the input of the next. When piping to external executables like `llm.exe` that expect text, PowerShell usually converts the input appropriately.

```
# Example: Explain code from a file
Write-Host "Explaining code from my_script.py..."
Get-Content .\my_script.py | llm.exe -s "Explain this Python code step by step."

# Example: Summarize a web page's content (using PowerShell's web cmdlet)
Write-Host "Summarizing web page..."
# Invoke-RestMethod gets structured data, Invoke-WebRequest gets more detail
# For raw HTML content suitable for llm, Invoke-WebRequest might be better
# Using Invoke-RestMethod for simplicity here, may need adjustment based on site
try {
    $WebContent = Invoke-RestMethod -Uri "[https://example.com](https://example.com)" -UseBasicParsing
    $WebContent | Out-String | llm.exe -s "Summarize the main content of this HTML page."
} catch {
    Write-Error "Failed to fetch web content: $_"
}


# Example: Describe git changes
Write-Host "Describing git changes..."
git diff | llm.exe -s "Describe these code changes in plain English."
```

### h. Redirection (`>`, `>>`)

Similar to Bash, but often PowerShell Cmdlets like `Out-File` or `Set-Content` are preferred for more control (especially over encoding).

- `>`: Redirect output to a file (overwrites). Equivalent to `| Out-File`.
    
- `>>`: Append output to a file. Equivalent to `| Out-File -Append`.
    

```
# Save llm output to a file (using redirection)
llm.exe "Generate three creative names for a coffee shop" > coffee_shop_names.txt

# Append another set of names (using redirection)
llm.exe "Generate three more names, focusing on puns" >> coffee_shop_names.txt

# Using Out-File for better control (recommended)
llm.exe "Generate three names for a bookstore" | Out-File -FilePath bookstore_names.txt -Encoding utf8

llm.exe "Generate three more bookstore names" | Out-File -FilePath bookstore_names.txt -Encoding utf8 -Append
```

### i. Common PowerShell Cmdlets (Commands)

- `Write-Host "text"`: Writes output directly to the console (host). Use `Write-Output` to send objects to the pipeline.
    
- `Get-Content filename`: Reads the content of a file.
    
- `Invoke-RestMethod url`, `Invoke-WebRequest url`: Fetches content from a URL.
    
- `git diff` (requires Git installed and in PATH): Shows changes.
    
- `Get-ComputerInfo`, `Get-CimInstance Win32_OperatingSystem`: Get system information.
    
- `Test-Path path`: Checks if a file or directory exists.
    
- `Get-Help command`: PowerShell's built-in help system (very useful!). E.g., `Get-Help Out-File -Full`.
    

## 3. Control Flow

### a. Conditional Statements (`if`, `elseif`, `else`)

Uses comparison operators like `-eq` (equal), `-ne` (not equal), `-gt` (greater than), `-lt` (less than), `-like` (wildcard comparison). `Test-Path` is common for checking file existence.

```
$FileName = "report.txt"

if (Test-Path -Path $FileName -PathType Leaf) { # -PathType Leaf checks for files
  Write-Host "File '$FileName' exists. Summarizing..."
  Get-Content $FileName | llm.exe -s "Provide a brief summary of this report."
}
else {
  Write-Host "File '$FileName' not found."
}
```

### b. Loops (`foreach`, `while`)

- **`foreach`** loop: Iterate over a collection of items.
    
- **`while`** loop: Execute commands as long as a condition is true.
    

```
# --- Foreach Loop Example ---
# Process multiple files
Write-Host "Processing multiple text files..."
$FilesToProcess = @("chapter1.txt", "chapter2.txt", "final_notes.txt")

foreach ($File in $FilesToProcess) {
  if (Test-Path $File -PathType Leaf) {
    Write-Host "--- Processing $File ---"
    Get-Content $File | llm.exe -s "Extract key bullet points from this text."
    Write-Host "" # Add a newline
  }
  else {
    Write-Host "--- Skipping $File (not found) ---"
  }
}

# --- While Loop Example ---
# Read prompts from a file line by line
Write-Host "Reading prompts from prompts.txt..."
$PromptFile = "prompts.txt"
if (Test-Path $PromptFile -PathType Leaf) {
  # Get all lines, then loop through them
  $Prompts = Get-Content $PromptFile
  foreach ($PromptLine in $Prompts) {
     if (-not [string]::IsNullOrWhiteSpace($PromptLine)) { # Check if line isn't empty/whitespace
        Write-Host "--- Running Prompt: $PromptLine ---"
        llm.exe "$PromptLine"
        Write-Host ""
     }
  }
}
else {
    Write-Host "Prompt file '$PromptFile' not found."
}
```

## 4. Functions

Group reusable blocks of code.

```
# Define a function to run a prompt with a specific system message
function Explain-CodeWithLLM {
  param(
    [Parameter(Mandatory=$true)]
    [string]$CodeFilePath,

    [Parameter(Mandatory=$true)]
    [string]$ExplanationFilePath
  )

  if (-not (Test-Path $CodeFilePath -PathType Leaf)) {
     Write-Error "Error: Code file '$CodeFilePath' not found."
     return # Exit the function
  }

  Write-Host "Explaining code from '$CodeFilePath' and saving to '$ExplanationFilePath'..."
  Get-Content $CodeFilePath | llm.exe -s "Explain this code clearly and concisely." | Out-File -FilePath $ExplanationFilePath -Encoding utf8
  Write-Host "Explanation saved."
}

# Call the function
Explain-CodeWithLLM -CodeFilePath ".\utils.py" -ExplanationFilePath ".\utils_explanation.md"
Explain-CodeWithLLM -CodeFilePath ".\main_script.py" -ExplanationFilePath ".\main_script_explanation.md"
```

## 5. Using `llm` Features in PowerShell Scripts

Using `llm.exe` features is mostly about passing the correct arguments:

- **`` `Selecting Models (-m, -q):` ``**
    
    ```
    $Model = "gpt-4o"
    llm.exe -m $Model "Translate 'hello world' to French."
    llm.exe -q 4o -q mini "Translate 'hello world' to German."
    ```
    
- **`System Prompts (-s):`**
    
    ```
    $CodeFile = "script.py"
    $SystemPrompt = "You are a helpful assistant that explains Python code."
    Get-Content $CodeFile | llm.exe -s $SystemPrompt
    ```
    
- **`Model Options (-o):`** Pass options as separate arguments.
    
    ```
    llm.exe -m gpt-4o -o temperature 0.9 -o max_tokens 50 "Write a very short, creative story."
    ```
    
- **`` `Continuations (-c, --cid):` ``** Same caveats as Bash - harder to manage scriptmatically without parsing logs.
    
    ```
    # llm.exe "Tell me more about that." -c
    # $ConversationID = "01h53z..."
    # llm.exe "Any other ideas?" --cid $ConversationID
    ```
    
- **`Templates (-t):`** Works the same way.
    
    ```
    # Assume template 'code_reviewer' exists
    Get-Content my_code.java | llm.exe -t code_reviewer
    ```
    
- **`` `Attachments (-a, --at):` ``** Pass file paths or URLs as arguments.
    
    ```
    $ImageUrl = "[https://static.simonwillison.net/static/2024/pelicans.jpg](https://static.simonwillison.net/static/2024/pelicans.jpg)"
    $ImageFile = ".\document.png" # Use relative/absolute paths
    llm.exe "Describe the birds in this image." -a $ImageUrl
    llm.exe "Extract the text from this scanned document." -a $ImageFile
    
    # Piping an image requires temporary storage or more complex handling in PowerShell
    # Typically easier to just pass the file path directly using -a
    ```
    
- **`` `Fragments (-f, --sf):` ``** Pass file paths or aliases.
    
    ```
    $ContextFile = ".\project_documentation.md"
    $Question = "Based on the documentation, how is authentication handled?"
    llm.exe -f $ContextFile $Question
    
    $SystemInstructions = ".\instructions.txt"
    $Code = ".\main.py"
    llm.exe -f $Code --sf $SystemInstructions
    ```
    
- **`` `Extracting Code (-x, --xl):` ``** Works the same.
    
    ```
    llm.exe "Write a python function to calculate factorial" -x | Out-File -FilePath factorial.py -Encoding utf8
    ```
    

## 6. Best Practices and Tips

- **Execution Policy:** Be mindful of the execution policy on your system and target systems. Use `-Scope CurrentUser` for changes where possible. Consider signing scripts for wider distribution.
    
- **Error Handling:** Use `try`/`catch`/`finally` blocks for operations that might fail (like web requests or file access). Check the `$?` automatic variable (indicates if the last command succeeded) or `$LASTEXITCODE` (for exit codes from external executables like `llm.exe`). Set `$ErrorActionPreference = "Stop"` at the top of scripts to make them stop on terminating errors.
    
    ```
    $ErrorActionPreference = "Stop" # Or use try/catch
    try {
        # Code that might fail
        $Result = llm.exe "Risky prompt"
        if ($LASTEXITCODE -ne 0) {
            Write-Warning "llm.exe exited with code $LASTEXITCODE"
        }
        Write-Host $Result
    } catch {
        Write-Error "An error occurred: $_"
        # Handle error
    }
    ```
    
- **API Keys:** **NEVER** hardcode API keys.
    
    - Use `llm keys set <service>` beforehand (recommended).
        
    - Use environment variables: `$env:OPENAI_API_KEY = 'your_key_here'` (set temporarily for the session) or set them persistently via System Properties. `llm` should pick these up.
        
- **Readability:** Use comments, meaningful variable names (`$CamelCase` is common), and consistent indentation. Use PowerShell's verb-noun naming convention for functions (e.g., `Get-Data`, `Invoke-LLMRequest`).
    
- **Use Cmdlets:** Prefer PowerShell Cmdlets (`Get-Content`, `Out-File`, `Test-Path`, `Invoke-RestMethod`) over legacy aliases or external tools (`cat`, `echo`) when possible for better integration and object handling, unless interacting specifically with tools like `git` or `llm` itself.
    

## 7. Conclusion

PowerShell provides a robust environment for automating tasks with `llm.exe` on Windows. By understanding its syntax for variables, control flow, piping, and interacting with external commands, you can build powerful scripts to leverage large language models within your Windows workflows. Remember to consult PowerShell's excellent built-in help (`Get-Help`) for more details on specific commands.

## 8. Step-by-Step Workflow Example

Here's a practical workflow you can follow, assuming `llm` is installed and your API key (e.g., for OpenAI) is already configured using `llm keys set openai`.

### a. Verify Setup

First, ensure `llm` is accessible and configured. Open PowerShell and run:

```powershell
# Check llm version
llm --version

# Verify configured keys
llm keys
```

### b. Create a Working Directory

It's good practice to create a dedicated directory for your projects.

```powershell
# Create a directory (e.g., in your user's Documents folder)
$ProjectDir = Join-Path $HOME "Documents\\LLM-Projects"
New-Item -ItemType Directory -Path $ProjectDir -Force
Set-Location -Path $ProjectDir # Change current directory to the new one
Write-Host "Working directory set to: $ProjectDir"
```

### c. Create and Run Your First Script

Let's create a simple script.

```powershell
# Create a new script file
$ScriptName = "first_llm_script.ps1"
New-Item -ItemType File -Path ".\\$ScriptName" -Force
```

Open `first_llm_script.ps1` in a text editor (like Notepad, VS Code, etc.) and add the following:

```powershell
# first_llm_script.ps1
Write-Host "Running my first LLM script..."

# Simple prompt - store the result in a variable
$Result = llm "What are 5 interesting facts about PowerShell?"

# Display the result to the console
Write-Host "Result from LLM:"
Write-Host $Result

# Save the output to a file using Out-File for encoding control
$OutputFile = "powershell_facts.txt"
$Result | Out-File -FilePath ".\\$OutputFile" -Encoding utf8
Write-Host "Output saved to '$OutputFile'"
```

Before running, check your execution policy:

```powershell
Get-ExecutionPolicy
```

If it's `Restricted`, run PowerShell as Administrator and execute:

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
```

Now, run your script from the PowerShell prompt in your project directory:

```powershell
.\\first_llm_script.ps1
```

### d. Experiment with More Features

Create another script to try different `llm` options.

```powershell
# Create a new script file
$ScriptName = "advanced_llm_script.ps1"
New-Item -ItemType File -Path ".\\$ScriptName" -Force
```

Edit `advanced_llm_script.ps1`:

```powershell
# advanced_llm_script.ps1

# 1. Using system prompts
Write-Host "--- Using a system prompt ---"
llm -s "You are a helpful PowerShell expert" "How do I list all files in a directory, including hidden ones?"
Write-Host "`n" # Add a newline for readability

# 2. Trying different models (if available)
Write-Host "--- Trying a different model (e.g., gpt-4o-mini) ---"
llm -m gpt-4o-mini "Explain what a PowerShell pipeline is in one sentence."
Write-Host "`n"

# 3. Processing a file's content
Write-Host "--- Processing a file ---"
# First, create a sample code file
$CodeFileName = "sample_code.ps1"
"function Get-Greeting {
    param([string]$Name)
    Write-Host `"Hello, $Name!`"
}" | Out-File -FilePath ".\\$CodeFileName" -Encoding utf8
Write-Host "Created '$CodeFileName'."

# Pipe the file content to llm with a system prompt
Get-Content ".\\$CodeFileName" | llm -s "Explain this PowerShell code snippet line by line."
Write-Host "`n"

# 4. Extracting code using -x
Write-Host "--- Extracting code ---"
$FunctionName = "factorial.ps1"
llm "Write a PowerShell function that calculates the factorial of a number recursively." -x | Out-File -FilePath ".\\$FunctionName" -Encoding utf8
Write-Host "Factorial function extracted and saved to '$FunctionName'."
```

Run the advanced script:

```powershell
.\\advanced_llm_script.ps1
```

### e. Create and Use a Reusable Function

For more complex tasks, reusable functions are useful. Create a utility script file.

```powershell
# Create the utility script
$UtilityScriptName = "llm_utils.ps1"
New-Item -ItemType File -Path ".\\$UtilityScriptName" -Force
```

Edit `llm_utils.ps1` and add the function:

```powershell
# llm_utils.ps1

# Function to explain code files using llm
function Explain-CodeWithLLM {
  param(
    [Parameter(Mandatory=$true)]
    [string]$CodeFilePath,

    [Parameter(Mandatory=$false)]
    [string]$ExplanationFilePath = "" # Optional path to save the explanation
  )

  # Check if the code file exists
  if (-not (Test-Path $CodeFilePath -PathType Leaf)) {
     Write-Error "Error: Code file '$CodeFilePath' not found."
     return # Stop the function execution
  }

  Write-Host "Explaining code from '$CodeFilePath'..."
  # Execute llm, piping the code file content
  $explanation = Get-Content $CodeFilePath | llm -s "Explain this code clearly and concisely."

  # Check if an output file path was provided
  if (-not [string]::IsNullOrWhiteSpace($ExplanationFilePath)) {
    try {
        $explanation | Out-File -FilePath $ExplanationFilePath -Encoding utf8
        Write-Host "Explanation saved to '$ExplanationFilePath'"
    } catch {
        Write-Error "Failed to save explanation to '$ExplanationFilePath': $_"
    }
  } else {
    # If no file path, return the explanation text
    return $explanation
  }
}

# Note: No Export-ModuleMember needed here because we will dot-source this script.
```

Now, create a script to *use* this function:

```powershell
# Create the script that will use the utility function
$UserScriptName = "use_llm_utils.ps1"
New-Item -ItemType File -Path ".\\$UserScriptName" -Force
```

Edit `use_llm_utils.ps1`:

```powershell
# use_llm_utils.ps1

# Import the function from the utility script using dot-sourcing
# The initial '.' makes the function available in the current scope
. ".\\llm_utils.ps1"

# --- Example 1: Explain the factorial function we created earlier ---
$FactorialScript = "factorial.ps1"
$FactorialExplanation = "factorial_explanation.md"
if (Test-Path $FactorialScript) {
    Explain-CodeWithLLM -CodeFilePath $FactorialScript -ExplanationFilePath $FactorialExplanation
} else {
    Write-Warning "Factorial script '$FactorialScript' not found."
}

# --- Example 2: Explain the sample code and get the explanation back as text ---
$SampleCodeScript = "sample_code.ps1"
if (Test-Path $SampleCodeScript) {
    Write-Host "`n--- Getting explanation for '$SampleCodeScript' as text ---"
    # Call the function without an output file path to get the result directly
    $explanationText = Explain-CodeWithLLM -CodeFilePath $SampleCodeScript
    Write-Host "Explanation Received:"
    Write-Host $explanationText
} else {
    Write-Warning "Sample code script '$SampleCodeScript' not found."
}

# --- Example 3: Handle a non-existent file ---
Write-Host "`n--- Testing with a non-existent file ---"
Explain-CodeWithLLM -CodeFilePath ".\non_existent_script.py" -ExplanationFilePath ".\non_existent_explanation.txt"

Write-Host "`nScript finished."
```

Run the script that uses the function:

```powershell
.\\use_llm_utils.ps1
```

This workflow demonstrates creating scripts, running basic prompts, using advanced features like system prompts and file processing, and building reusable functions for common `llm` tasks within PowerShell.