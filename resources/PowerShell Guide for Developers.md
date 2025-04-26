# **PowerShell Guide for Junior Developers: Getting Started, Installation & Basics**

Welcome! This guide aims to introduce you, as a junior developer, to PowerShell and how it can be a valuable tool in your development workflow, even beyond traditional system administration tasks.

_(Much of the initial content for this guide is adapted from the excellent "PowerShell 101" book by Mike F. Robbins, focusing on core concepts applicable across PowerShell versions)._


## **1. What is PowerShell?**

PowerShell is a powerful, cross-platform tool from Microsoft that combines a **command-line shell**, a **scripting language**, and an **automation framework**. It runs on Windows, Linux, and macOS.

Think of it as a supercharged command prompt or terminal window that's designed for automating tasks and managing systems, but it's also incredibly useful for developers.

**Key Takeaways:**

- **Cross-Platform:** Use it on your preferred OS.

- **More than just a Shell:** It's also a robust scripting language.

- **Object-Oriented:** Unlike traditional shells that deal purely with text, PowerShell works with **.NET objects**. This is a major advantage, as it allows you to manipulate structured data directly without complex text parsing.


## **2. Core Components**

PowerShell consists of several key parts:

- **Command-line Shell:**

* Provides an interactive command-line interface (like bash or cmd.exe).

* Features include robust command history, tab completion, command prediction, aliases (shortcuts for commands), and a powerful pipeline for chaining commands together.

* Has a built-in help system (Get-Help), similar to man pages in Unix/Linux.

- **Scripting Language:**

* Built on the .NET Common Language Runtime (CLR).

* Used for automating system management, building/testing/deploying solutions (especially in CI/CD pipelines).

* Features include functions, classes, scripts, modules, and built-in support for data formats like CSV, JSON, and XML.

- **Automation Platform & Configuration Management:**

* Through modules, PowerShell can manage various technologies (Azure, AWS, Google Cloud, Windows, SQL, VMware, etc.).

* Includes **Desired State Configuration (DSC)** for managing infrastructure using configuration as code (more advanced topic).


## **3. PowerShell vs. Windows PowerShell**

It's important to know the difference:

- **Windows PowerShell:**

* The older version included _with_ Windows.

* Runs only on Windows and uses the full .NET Framework.

* Latest version is 5.1 and is no longer receiving new features. It often runs in the legacy "Windows PowerShell ISE" (Integrated Scripting Environment), which is also no longer updated.

- **PowerShell (Core):**

* The modern, open-source, cross-platform version (Windows, Linux, macOS).

* Built on newer versions of .NET (.NET 6, 7, 8, etc.).

* Actively developed and recommended for new work.

* Installs side-by-side with Windows PowerShell; it doesn't replace it.

* Often used within modern terminals like Windows Terminal or with editors like Visual Studio Code (VS Code) with the PowerShell extension.

**This guide focuses on the modern, cross-platform PowerShell.** While some examples might originate from Windows PowerShell 5.1 contexts, the core concepts apply broadly.


## **4. Basic Terminology**

- **Command Shell:** An interactive program to run commands (e.g., PowerShell, bash, zsh). It reads your input, evaluates it, executes commands, and prints output (a REPL - Read-Eval-Print Loop).

- **Terminal:** The application that _hosts_ a command shell, providing the window, text display, tabs, etc. (e.g., Windows Terminal, iTerm2, macOS Terminal).

- **Cmdlet (Command-let):** A native PowerShell command, built into PowerShell or added via modules. They follow a standard Verb-Noun naming convention (e.g., Get-Command, Set-Location, Start-Process).

* **Verb:** Specifies the action (Get, Set, Add, Remove, Start, Stop, etc.).

* **Noun:** Specifies the resource the action applies to (Process, Service, Item, Content, etc.).

- **Function/Script Cmdlet:** Commands written using the PowerShell scripting language, often following the same Verb-Noun convention.

- **Alias:** A shortcut or nickname for a command (e.g., gci is often an alias for Get-ChildItem).

- **Native Command:** External executables or OS commands (like ping.exe, ipconfig.exe, ls, grep) that can be run from within PowerShell.


## **5. Installing PowerShell**

(Refer to the previous sections for installation steps on Windows, macOS, Linux, and Docker)


## **6. Finding, Launching, and Checking Your Version**

### **6.1 Finding and Launching PowerShell (Windows Example)**

- **Search Bar:** The easiest way is to type PowerShell in the Windows search bar. You might see multiple entries:

* PowerShell or pwsh: Modern PowerShell (recommended).

* Windows PowerShell: The older, built-in version (5.1).

* Windows PowerShell ISE: The older scripting environment for 5.1.

* (x86) versions: 32-bit versions (usually use the 64-bit version if available).

- **Running as Administrator:**

* Standard User: Launching normally runs PowerShell with your standard user privileges. Commands requiring administrative rights will fail (often due to User Access Control - UAC).

* Administrator: Right-click the PowerShell shortcut and select "Run as administrator". You'll likely be prompted for admin credentials. The window title usually indicates "(Administrator)". **Run elevated only when necessary.** Targeting remote computers usually doesn't require running elevated locally.

- **Pinning to Taskbar:** Right-click the desired PowerShell shortcut in the search results and select "Pin to taskbar" for quick access. To launch elevated from the taskbar, hold Shift while right-clicking the icon and select "Run as administrator".

_(Launching on macOS and Linux typically involves opening your preferred terminal application and typing pwsh)_.


### **6.2 Checking Your Version**

PowerShell has built-in _automatic variables_ that store information about the current session. $PSVersionTable is a hash table containing version details.

$PSVersionTable

Look for the PSVersion (e.g., 7.4.1) and PSEdition (Core for modern PowerShell, Desktop for Windows PowerShell 5.1).


## **7. Understanding Execution Policy**

- **What it is:** A safety feature in PowerShell that controls whether you can run scripts (.ps1 files). It helps prevent accidentally running malicious scripts downloaded from the internet. **It is NOT a security boundary**; a determined user can bypass it.

- **How it affects you:** It only affects running commands _from script files_. You can always run any command interactively in the console, regardless of the policy.

- **Common Policies:**

* Restricted: (Default on Windows clients) Prevents _all_ scripts from running.

* AllSigned: Only scripts signed by a trusted publisher can run.

* RemoteSigned: (Default on Windows Servers) Locally written scripts can run. Scripts downloaded from the internet must be signed by a trusted publisher. **This is generally the recommended setting for learning and development.**

* Unrestricted: All scripts can run (use with caution).

* Bypass: Nothing is blocked, no warnings or prompts.

* Undefined: No policy is set at this scope; PowerShell checks the next scope.

- **Checking the Policy:**\
  Get-ExecutionPolicy\
  \# To see policies set at different levels (scopes):\
  Get-ExecutionPolicy -List

- **Changing the Policy:** Requires administrator privileges to change for the whole machine (LocalMachine scope).\
  \# Run PowerShell as Administrator first!\
  Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine\
  \
  You'll be prompted to confirm. If you don't have admin rights, you _might_ be able to set it just for your user account (less common):\
  Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

- **Key Takeaway:** For learning, setting the policy to RemoteSigned (as administrator) is usually necessary to run your own practice scripts.


## **8. Discovering Commands: The Help System**

Experts don't memorize every command; they know how to _find_ the commands and _learn_ how to use them using PowerShell's built-in help.


### **8.1 Core Discovery Cmdlets**

- **Get-Command**: Finds commands based on name, verb, noun, module, etc.

- **Get-Help**: Displays detailed help information about commands and concepts.

- **Get-Member**: (Covered next) Shows the structure (properties, methods) of the objects that commands output.


### **8.2 Using Get-Help (and the help function)**

- **Getting Help for a Command:**\
  Get-Help Get-Process

- **Updating Help:** Help files aren't always included by default. Run Update-Help (as administrator) periodically to download the latest help content. You might be prompted the first time you run Get-Help.\
  \# Run PowerShell as Administrator\
  Update-Help -Force\
  \
  _(Note: Update-Help requires internet access. Use Save-Help on an internet-connected machine and Update-Help -SourcePath on an offline machine if needed)._

- **The help Function:** This is often preferred over Get-Help for interactive use because it pages the output (like less or more in Linux/macOS). Press Spacebar for the next page, Q to quit.\
  help Get-Process

- **Getting More Detail:**

* help Get-Process -Full: Shows the complete help file, including parameter details, inputs, outputs, and notes.

* help Get-Process -Detailed: Similar to -Full but slightly less verbose.

* help Get-Process -Examples: Shows only usage examples.

* help Get-Process -Online: Opens the most current help page in your web browser (recommended for latest info).

* help Get-Process -Parameter Name: Shows detailed help just for the specified parameter (Name in this case).

* help Get-Process -ShowWindow: Opens help in a separate, searchable GUI window (requires a GUI environment, may have bugs).

- **Understanding Syntax:** The SYNTAX section uses brackets:

* \[-ParameterName]: Optional parameter.

* \[-ParameterName \<Type>]: Optional parameter taking a value of \<Type>.

* \<Type\[]>: Parameter accepts multiple values (an array).

* \[\[-ParameterName] \<Type>]: Optional _positional_ parameter. You can omit -ParameterName if the value is in the correct position. Check the PARAMETERS section (using -Full) for position numbers.

* \[-SwitchParameter]: A switch parameter doesn't take a value; its presence means true.

- **Finding Commands with help:** Use wildcards (\*). If no exact match is found, help searches _all_ help content.\
  help \*process\* # Find commands with "process" in the name\
  help process     # Often does the same as above due to full-text search fallback\
  help \*-process   # Find commands ending in "-process" (quote if starting with '-')\
  help about\_\* # Find conceptual help topics (like about\_Execution\_Policies)


### **8.3 Using Get-Command**

- **Finding Commands:** More direct than Get-Help for just locating commands. Accepts wildcards for Name, Noun, Verb.\
  Get-Command -Name \*process\* # Find commands with "process" in the name (includes native .exe)\
  Get-Command -Noun Process            # Find PowerShell commands acting on "Process"\
  Get-Command -Verb Get                # Find PowerShell commands starting with "Get"\
  Get-Command -Verb Get -Noun Service  # Find PowerShell commands matching Get-Service pattern\
  Get-Command -CommandType Cmdlet      # Find only Cmdlets\
  Get-Command -CommandType Function,Alias # Find Functions and Aliases

- **Getting Syntax:** Quickly see parameter names and types (less detail than Get-Help).\
  Get-Command -Name Get-Process -Syntax


## **9. Working with Objects: Properties and Methods**

PowerShell's power comes from its object-oriented nature. Instead of just text, commands pass structured **objects** between each other. Understanding these objects is key.


### **9.1 Discovering Object Structure with Get-Member**

The Get-Member cmdlet is your primary tool for inspecting the objects that commands produce. You pipe the output of a command to Get-Member to see its structure.

- **Properties:** These are the attributes or data associated with an object (like 'Eye Color' on a driver's license).

- **Methods:** These are actions you can perform _on_ the object (like 'Revoke' on a driver's license).

Let's look at the Get-Service cmdlet:

\# Get the Windows Time service object\
Get-Service -Name w32time\
\
\# Now, pipe it to Get-Member to see its structure\
Get-Service -Name w32time | Get-Member

The output from Get-Member shows:

- **TypeName:** The full .NET class name of the object (e.g., System.ServiceProcess.ServiceController). This tells you exactly what kind of object you're dealing with.

- **Name:** The name of the property or method.

- **MemberType:** Indicates if it's a Property, Method, AliasProperty (a shortcut name for another property), Event, etc.

- **Definition:** Shows the type/signature for properties and methods.


### **9.2 Working with Properties**

- **Default Display vs. All Properties:** Commands often display only a few key properties by default. Get-Member reveals _all_ available properties.

- **Selecting Properties:** Use Select-Object (alias select) to choose which properties to display.\
  \# Select all properties\
  Get-Service -Name w32time | Select-Object -Property \*\
  \
  \# Select specific properties\
  Get-Service -Name w32time | Select-Object -Property Status, Name, DisplayName, StartType\
  \
  \# Use wildcards to select properties\
  Get-Service -Name w32time | Select-Object -Property Status, DisplayName, Can\*

- **Calculated Properties:** Sometimes, the default output includes columns that aren't direct properties but are calculated (like NPM(K), CPU(s) from Get-Process). Get-Member shows the real underlying properties (often AliasProperty or ScriptProperty) used to calculate these.


### **9.3 Working with Methods**

- **Viewing Methods:** Filter Get-Member to see only methods.\
  Get-Service -Name w32time | Get-Member -MemberType Method

- **Invoking Methods:** Use dot notation . after the object (or command enclosed in parentheses ()) followed by the method name and parentheses (). Methods might require arguments inside the parentheses.\
  \# Stop the service using its Stop() method (Requires Admin privileges)\
  (Get-Service -Name w32time).Stop()\
  \
  \# Verify it stopped\
  Get-Service -Name w32time

- **Methods vs. Cmdlets:** If a dedicated cmdlet exists (like Stop-Service, Start-Service), it's generally better to use the cmdlet than the method. Cmdlets often offer more features (like the -PassThru parameter) and follow standard PowerShell patterns. However, sometimes only a method is available for a specific action.


### **9.4 Handling Commands Without Output (-PassThru)**

You can only pipe objects to Get-Member. Some cmdlets (like Start-Service or Stop-Service) don't produce output by default. Piping them directly to Get-Member will cause an error.

\# This FAILS because Start-Service produces no output by default\
Start-Service -Name w32time | Get-Member\
\
\# This WORKS because -PassThru makes Start-Service output the service object\
Start-Service -Name w32time -PassThru | Get-Member

- **Key Point:** Use the -PassThru parameter (if available) on cmdlets that don't normally produce output if you need to pipe their resulting object to another command like Get-Member or Select-Object.

- **Note:** Some commands like Out-Host are designed _only_ to display information on the screen and never produce pipeline objects, so they cannot be piped to Get-Member.


### **9.5 Finding Related Commands (Get-Command -ParameterType)**

Once you know the TypeName of an object from Get-Member, you can find other commands that accept that type of object as input using Get-Command -ParameterType.

\# Find commands that accept a ServiceController object (from Get-Service)\
Get-Command -ParameterType ServiceController


### **9.6 Example: Working with Module-Specific Objects (Active Directory)**

_(Note: The following examples require the Active Directory PowerShell module, often installed via Remote Server Administration Tools - RSAT. This illustrates general concepts applicable to many modules)._

Modules often define their own object types. Commands within those modules might return only a subset of properties by default for performance reasons.

- **Limited Default Properties:** Get-ADUser returns only a few properties by default.\
  \# Get a user (replace 'username' with a valid user)\
  Get-ADUser -Identity username | Get-Member -MemberType Properties

- **Retrieving More Properties:** Use the -Properties parameter (common in many modules, not just AD).\
  \# Get ALL properties for the user (use cautiously in large environments)\
  Get-ADUser -Identity username -Properties \* | Get-Member -MemberType Properties\
  \
  \# Get specific additional properties\
  Get-ADUser -Identity username -Properties DisplayName, EmailAddress, LastLogonDate

- **Performance & Filtering:**

* **Filter at the source:** Only request the properties you need using -Properties Property1, Property2. This is much more efficient than getting all properties (-Properties \*) and then filtering with Select-Object.

* **Store results:** If exploring data from a potentially slow or resource-intensive command, run it once with the necessary properties and store the results in a variable. Then, analyze the variable.\
  \# Run the query once\
  $User = Get-ADUser -Identity username -Properties DisplayName, EmailAddress, LastLogonDate\
  \
  \# Explore the stored object(s)\
  $User | Select-Object DisplayName, LastLogonDate\
  $User | Get-Member


## **10. One-Liners and the Pipeline**

One of the most powerful features of PowerShell is the **pipeline**, which allows you to send the output (objects) of one command directly as input to another command using the pipe symbol (|).


### **10.1 What is a One-Liner?**

- A PowerShell **one-liner** is a single, continuous pipeline, potentially involving multiple commands chained together with |.

- It's **not** necessarily a command that fits on one physical line in your editor or console.

- For readability, long one-liners are often broken at the pipe | symbol or other natural breaking points (like commas , or opening brackets \[ { (). Avoid using the backtick \` for line continuation if possible.

\# This is ONE one-liner, even though it spans multiple lines\
Get-Service |\
    Where-Object CanPauseAndContinue -EQ $true |\
    Select-Object -Property DisplayName, Status, StartType\
\
\# This is TWO separate commands on one line, NOT a one-liner\
$Service = 'w32time'; Get-Service -Name $Service


### **10.2 Filter Left: Efficiency Matters**

- **Filter Left:** It's a best practice to filter data as early (as far to the left) in the pipeline as possible.

- **Use Parameters:** If the initial command (e.g., Get-Service, Get-ADUser) has parameters for filtering (like -Name, -Filter, -Include), use them!

- **Avoid Inefficiency:** Don't retrieve _all_ objects (Get-Service) and _then_ pipe them to Where-Object if you could have filtered initially with a parameter (Get-Service -Name w32time). This is especially important with large datasets (like Active Directory users).

\# Efficient: Filter Left using the -Name parameter\
Get-Service -Name w32time\
\
\# Inefficient: Gets ALL services, then filters\
Get-Service | Where-Object Name -EQ w32time


### **10.3 Command Order Matters**

The order of commands in the pipeline is crucial, especially when selecting and filtering properties.

- Filter _before_ you select properties with Select-Object if your filter relies on properties that might be removed by Select-Object.

\# INCORRECT: Fails because CanPauseAndContinue wasn't selected first\
Get-Service |\
    Select-Object -Property DisplayName, Status | # Removes CanPauseAndContinue\
    Where-Object CanPauseAndContinue             # Tries to filter on a non-existent property\
\
\# CORRECT: Filters first, then selects the desired properties from the filtered results\
Get-Service |\
    Where-Object CanPauseAndContinue |\
    Select-Object -Property DisplayName, Status


### **10.4 How Pipeline Input Works (Binding)**

PowerShell automatically tries to match the output objects from one command to the input parameters of the next command in the pipeline. This matching process is called **parameter binding**.

- **Check the Help:** Use Get-Help \<CmdletName> -Full and look at the INPUTS section and the details for each parameter (Accept pipeline input?).

- **Binding Methods:**

* **By Value (By Type):** PowerShell tries to match the .NET _type_ of the incoming object to the type required by a parameter. This is the primary binding method.

* **By Property Name:** If binding By Value fails, PowerShell looks for a parameter on the next cmdlet whose name matches a property name on the incoming object. It then uses the _value_ of that property as the input for the parameter.

- **Priority:** PowerShell attempts to bind **By Value (Type)** first. If that fails, it tries **By Property Name**.

**Example: Stop-Service Pipeline Input**

From help Stop-Service -Full, we see:

- The InputObject parameter accepts ServiceController objects ByValue.

- The Name parameter accepts String objects ByValue AND accepts input ByPropertyName.

\# 1. Binding By Value (Type: ServiceController -> InputObject)\
\# Get-Service outputs ServiceController objects. Stop-Service's InputObject parameter accepts these ByValue.\
Get-Service -Name w32time | Stop-Service\
\
\# 2. Binding By Value (Type: String -> Name)\
\# 'w32time' is a String. Stop-Service's Name parameter accepts strings ByValue.\
'w32time' | Stop-Service\
\
\# 3. Binding By Property Name (Property: Name -> Name)\
\# Create a custom object with a 'Name' property\
$customObject = \[pscustomobject]@{ Name = 'w32time' }\
\# Pipe the custom object. It's not a ServiceController or String (so ByValue fails).\
\# PowerShell sees the 'Name' property on $customObject matches the 'Name' parameter on Stop-Service.\
\# It binds the \*value\* of the Name property ('w32time') to the Name parameter.\
$customObject | Stop-Service\
\
\# 4. Binding Failure (No matching Type or Property Name)\
$customObject2 = \[pscustomobject]@{ Service = 'w32time' }\
\# This fails because $customObject2 is not a ServiceController or String,\
\# AND it doesn't have a property named 'Name' to bind ByPropertyName.\
$customObject2 | Stop-Service # Error!


### **10.5 Renaming Properties for Pipeline Binding**

If an output object's property name doesn't match the required input parameter name, you can use Select-Object with a calculated property to rename it on the fly.

$customObject2 = \[pscustomobject]@{ Service = 'w32time' }\
\
\# Rename the 'Service' property to 'Name' so it binds ByPropertyName to Stop-Service's Name parameter\
$customObject2 |\
    Select-Object -Property @{Name='Name';Expression={$\_.Service}} |\
    Stop-Service


### **10.6 Using Command Output Without Piping (Command Substitution)**

If a parameter doesn't accept pipeline input, you can often use the output of another command directly as the parameter's value by enclosing the command in parentheses ().

\# Stop-Service -DisplayName does NOT accept pipeline input.\
\# Get-Content reads service names from a file.\
\# The output of Get-Content (inside parentheses) is passed as the value to -DisplayName.\
Stop-Service -DisplayName (Get-Content -Path C:\path\to\services.txt)


### **10.7 Finding and Installing Modules (PowerShellGet)**

- **PowerShell Gallery:** A public repository (powershellgallery.com) for sharing PowerShell modules and scripts. **Use with caution!** Always review and test code from the gallery in an isolated environment before using it in production.

- **PowerShellGet Module:** Contains cmdlets for interacting with repositories like the PowerShell Gallery.

* Find-Module: Searches for modules in a repository.

* Install-Module: Downloads and installs modules. (You might be prompted to install the 'NuGet provider' the first time).

* Update-Module: Updates installed modules.

* Save-Module: Downloads a module without installing it.

\# Find a module (you might be prompted to install NuGet provider)\
Find-Module -Name SomeModuleName\
\
\# Install a module for the current user only (safer than installing for AllUsers)\
Install-Module -Name SomeModuleName -Scope CurrentUser -Force # Use -Force cautiously

_(Note: Some community modules, like MrToolkit mentioned in the source article, provide helper functions like Get-MrPipelineInput to simplify identifying pipeline-accepting parameters.)_


## **11. Formatting Output (Format Right)**

While filtering should happen early in the pipeline ("Filter Left"), formatting the output for display should happen as late as possible ("Format Right").

- **Formatting Cmdlets:** Format-Table, Format-List, Format-Wide, Format-Custom. These control how objects are displayed on the screen.

- **Why Format Last?** Formatting cmdlets change the type of object in the pipeline. They output _formatting objects_, not the original data objects (like ServiceController or Process). These formatting objects cannot be easily piped to most other cmdlets (except some Out-\* cmdlets like Out-File or Out-String).

- **Overriding Defaults:** You can use format cmdlets to change the default display (e.g., force a table view when the default is a list, or vice-versa).

\# Default output for Get-Service might be a table\
Get-Service -Name w32time\
\
\# Force list output (might show more properties than the default table)\
Get-Service -Name w32time | Format-List\
\
\# Select specific properties, then force table output\
Get-Service -Name w32time |\
    Select-Object -Property Status, DisplayName, Can\* |\
    Format-Table\
\
\# INCORRECT: Trying to pipe after formatting breaks things\
\# Get-Member receives formatting objects, not the ServiceController object\
Get-Service -Name w32time | Format-List | Get-Member # Error or unexpected output!

- **Key Takeaway:** Do all your data retrieval, filtering (Where-Object), and data manipulation (Select-Object) _before_ you send the final objects to a Format-\* cmdlet for display.


## **12. Aliases**

- **What they are:** Short nicknames for cmdlets (e.g., gcm for Get-Command, gm for Get-Member, select for Select-Object, where for Where-Object).

- **Finding Aliases:** Use Get-Alias.\
  \# Find what command 'gcm' is an alias for\
  Get-Alias -Name gcm\
  \# Or using the positional parameter:\
  Get-Alias gcm\
  \
  \# Find aliases defined for specific commands\
  Get-Alias -Definition Get-Command, Get-Member

- **Usage:** Aliases are fine for interactive use in the console to save typing.

- **Recommendation:** **Do NOT use aliases in scripts or any code you save or share.** Using the full cmdlet and parameter names makes code self-documenting and much easier for others (and your future self) to understand. Aliases you define yourself only exist in your current session.


## **13. Providers and PSDrives**

PowerShell uses **Providers** to give file system-like access to different data stores. Think of them as adapters.

- **Built-in Providers:** PowerShell comes with providers for:

* FileSystem: Accessing traditional file drives (C:, D:, etc.).

* Registry: Accessing the Windows Registry (HKLM:, HKCU:).

* Alias: Accessing defined aliases (Alias:).

* Variable: Accessing variables in the current session (Variable:).

* Function: Accessing defined functions (Function:).

* Environment: Accessing environment variables (Env:).

* Certificate: Accessing certificate stores (Cert:).

- **Module Providers:** Modules can add their own providers (e.g., ActiveDirectory adds AD:, SqlServer adds SQLSERVER:).

- **Finding Providers:**\
  Get-PSProvider

- **PSDrives:** Providers expose their data stores through **PSDrives**. These look like drive letters but aren't necessarily physical or logical drives.

- **Finding PSDrives:**\
  Get-PSDrive

- **Accessing PSDrives:** Use standard file system cmdlets like Get-ChildItem (alias gci, ls, dir), Set-Location (alias sl, cd), Get-Item (alias gi), etc.\
  \# List environment variables\
  Get-ChildItem -Path Env:\
  \
  \# Navigate into the Alias drive\
  Set-Location -Path Alias:\
  \
  \# List items in the HKLM registry hive\
  Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft


## **14. Comparison Operators**

PowerShell uses specific operators for comparing values, often used with Where-Object or in conditional statements (if).

- **Case-Insensitive by Default:** Most comparison operators ignore case. Add a c prefix for case-sensitive comparison (e.g., -ceq, -clike).

- **Common Operators:**

* -eq: Equal to ('hi' -eq 'HI' is $true)

* -ceq: Case-sensitive equal to ('hi' -ceq 'HI' is $false)

* -ne: Not equal to

* -cne: Case-sensitive not equal to

* -gt: Greater than (5 -gt 3 is $true)

* -ge: Greater than or equal to (5 -ge 5 is $true)

* -lt: Less than

* -le: Less than or equal to

* -like: Wildcard comparison ('PowerShell' -like 'P\*Shell' is $true). Uses \* (matches zero or more characters) and ? (matches exactly one character).

* -clike: Case-sensitive wildcard comparison.

* -notlike: Does not match wildcard pattern.

* -match: Regular Expression (regex) comparison ('PowerShell' -match '^P.\*rShell$' is $true). More powerful pattern matching than -like.

* -cmatch: Case-sensitive regex comparison.

* -notmatch: Does not match regex pattern.

* -contains: Checks if a collection _contains_ a specific value ((1, 2, 3) -contains 2 is $true).

* -ccontains: Case-sensitive contains.

* -notcontains: Checks if a collection does _not_ contain a specific value ((1, 2, 3) -notcontains 4 is $true).

* -in: Checks if a specific value is _in_ a collection (2 -in (1, 2, 3) is $true). (Opposite of -contains).

* -cin: Case-sensitive in.

* -notin: Checks if a specific value is _not in_ a collection (4 -notin (1, 2, 3) is $true).

* -replace: Replaces text using regex patterns. ('PSShell' -replace 'SS', 'ower' gives 'PowerShell'). Case-insensitive by default.

- **-replace Operator vs. .Replace() Method:**

* The -replace _operator_ uses regular expressions and is case-insensitive by default.

* The .Replace() _string method_ performs a literal, case-sensitive replacement.

'PowerShell' -replace 'shell', 'House' # Gives 'PowerHouse' (Case-insensitive)\
'PowerShell'.Replace('shell', 'House') # Gives 'PowerShell' (Case-sensitive, no match)\
'PowerShell'.Replace('Shell', 'House') # Gives 'PowerHouse' (Case-sensitive, matches)\
Generally, prefer operators over methods when available for consistency and case-insensitivity benefits unless case-sensitivity is specifically required.


## **15. Flow Control and Scripting Basics**

As you move beyond simple one-liners, you'll start writing scripts. A PowerShell script is simply a text file containing PowerShell commands, saved with a .ps1 extension. Scripts allow you to combine commands with logic and loops to perform more complex tasks.


### **15.1 Looping Constructs**

Loops allow you to repeat a block of code multiple times, often iterating over a collection of items.

- **ForEach-Object Cmdlet:**

* Designed for use _within_ the pipeline.

* Processes objects one by one as they come through the pipeline (streaming).

* Uses $\_ or $PSItem (since PS v3.0) to represent the current object in the pipeline.

\# Get commands for two modules using the pipeline and ForEach-Object\
'ActiveDirectory', 'SQLServer' |\
    ForEach-Object { Get-Command -Module $\_ } |\
    Group-Object -Property ModuleName -NoElement

- **foreach Statement (Keyword):**

* A language construct used _outside_ the pipeline.

* Requires the entire collection of items to be loaded into memory first.

* Often clearer syntax for script blocks.

\# Get AD computer info for computers stored in a variable\
$ComputerNames = 'DC01', 'WEB01'\
foreach ($Computer in $ComputerNames) {\
    Get-ADComputer -Identity $Computer\
}

- **Confusion Point:** foreach is _also_ a default alias for the ForEach-Object cmdlet. In scripts, use the full ForEach-Object name if you mean the cmdlet, or the foreach ($item in $collection) {...} syntax for the keyword loop.

* **When Loops Are Necessary (and When Not):**

- Some cmdlets accept only a single item for certain parameters (like Get-ADComputer -Identity). In these cases, you _must_ use a loop (foreach statement or ForEach-Object cmdlet) to process multiple items passed via parameter.

- However, many cmdlets are designed to accept multiple items _via the pipeline_. If a parameter accepts pipeline input (ByValue or ByPropertyName), you can often pipe a collection directly without an explicit loop.

\# This works because Get-ADComputer accepts pipeline input for Identity\
'DC01', 'WEB01' | Get-ADComputer\
Always check the help (Get-Help \<CmdletName> -Full) to see if parameters accept pipeline input before assuming a loop is needed.

- **for Statement:**

* Iterates based on an initializer, a condition, and an iterator step.

* Useful when you need fine-grained control over the loop counter.

\# Loop 4 times, incrementing $i each time\
for ($i = 1; $i -lt 5; $i++) {\
    Write-Output "Iteration number $i"\
    Start-Sleep -Seconds 1\
}

- **do...until Statement:**

* Executes the script block _at least once_, then checks the condition.

* Loops _until_ the condition is $true.

$number = Get-Random -Minimum 1 -Maximum 5\
do {\
    $guess = Read-Host -Prompt "Guess a number (1-5)"\
    if ($guess -lt $number) { Write-Output 'Too low!' }\
    elseif ($guess -gt $number) { Write-Output 'Too high!' }\
} until ($guess -eq $number)\
Write-Output "Correct!"

- **do...while Statement:**

* Executes the script block _at least once_, then checks the condition.

* Loops _while_ the condition is $true.

$counter = 0\
do {\
    $counter++\
    Write-Output "Counter is $counter"\
} while ($counter -lt 3)

- **while Statement:**

* Checks the condition _before_ executing the script block.

* Loops _while_ the condition is $true.

* The block might never execute if the condition is initially false.

$counter = 0\
while ($counter -lt 3) {\
    $counter++\
    Write-Output "Counter is $counter"\
}


### **15.2 Controlling Loop Flow**

- **break Keyword:** Immediately exits the _entire_ innermost loop (for, foreach, while, do, switch). Execution continues after the loop block.\
  for ($i = 1; $i -lt 5; $i++) {\
      if ($i -eq 3) {\
          break # Exit the loop when $i is 3\
      }\
      Write-Output $i\
  }\
  \# Output: 1, 2

- **continue Keyword:** Skips the _rest of the current iteration_ and proceeds to the next iteration of the innermost loop.\
  for ($i = 1; $i -lt 5; $i++) {\
      if ($i -eq 3) {\
          continue # Skip iteration when $i is 3\
      }\
      Write-Output $i\
  }\
  \# Output: 1, 2, 4

- **return Keyword:** Exits the current _scope_ (script, function, or script block). If used inside a loop within a function, it exits the function, not just the loop. It can optionally return a value.\
  function Find-FirstEvenNumber {\
      param($Numbers)\
      foreach ($n in $Numbers) {\
          if ($n % 2 -eq 0) {\
              return $n # Return the first even number found and exit the function\
          }\
      }\
      # This part is only reached if no even number is found\
      Write-Warning "No even number found."\
  }\
  \
  Find-FirstEvenNumber -Numbers (1, 3, 5, 6, 7, 8) # Output: 6


## **16. Working with WMI and CIM**

Windows Management Instrumentation (WMI) is a core Windows technology for querying system information and performing management tasks. PowerShell provides ways to interact with WMI.


### **16.1 WMI Cmdlets vs. CIM Cmdlets**

- **Legacy WMI Cmdlets:** (Get-WmiObject, Invoke-WmiMethod, etc.)

* Shipped with Windows PowerShell 5.1 and earlier.

* Use the older DCOM protocol for remote connections.

* **Deprecated:** Not available in modern PowerShell (6+) and not recommended for new development.

- **Modern CIM Cmdlets:** (Get-CimInstance, Invoke-CimMethod, Get-CimSession, etc.)

* Part of the CimCmdlets module, available since PowerShell 3.0.

* Use the modern WS-Management (WSMan) protocol by default for remote connections (more firewall-friendly).

* Can also use DCOM via session options for backward compatibility.

* **Recommended:** Use these for all new PowerShell development, even when interacting with WMI data stores.


### **16.2 Querying WMI/CIM Data with Get-CimInstance**

- **By Class Name:** The most common way. Specify the WMI class you want to query.\
  \# Get BIOS information\
  Get-CimInstance -ClassName Win32\_BIOS\
  \
  \# Get Operating System information\
  Get-CimInstance -ClassName Win32\_OperatingSystem

- **By WQL Query:** You can use WMI Query Language (WQL), similar to SQL, if you're migrating old scripts or need complex filtering at the source.\
  Get-CimInstance -Query 'Select \* from Win32\_BIOS'\
  \
  \# Filter using WQL\
  Get-CimInstance -Query "Select Name, State from Win32\_Service where Name = 'w32time'"

- **Filtering Efficiently:**

* **Filter Left (WMI):** Use the -Filter parameter with Get-CimInstance (uses WQL syntax) or a -Query for efficient filtering at the source.

* **Limit Properties:** Use the -Property parameter on Get-CimInstance to retrieve only the specific properties you need. This reduces network traffic and processing time, especially for remote queries.\
  \# Efficiently get only the serial number\
  Get-CimInstance -ClassName Win32\_BIOS -Property SerialNumber\
  \
  \# Inefficient: Gets all properties, then filters locally\
  Get-CimInstance -ClassName Win32\_BIOS | Select-Object -Property SerialNumber

* **Extracting Single Values:** Use Select-Object -ExpandProperty or dot notation () to get just the value of a property, not the object containing the property.\
  \# Get just the serial number string using ExpandProperty\
  Get-CimInstance -ClassName Win32\_BIOS -Property SerialNumber | Select-Object -ExpandProperty SerialNumber\
  \
  \# Get just the serial number string using dot notation\
  (Get-CimInstance -ClassName Win32\_BIOS -Property SerialNumber).SerialNumber


### **16.3 Querying Remote Computers**

- **-ComputerName Parameter:** The simplest way for a quick query, but has limitations. Uses WSMan by default.\
  \# Query BIOS on a remote computer (requires appropriate permissions and network config)\
  Get-CimInstance -ClassName Win32\_BIOS -ComputerName 'RemoteServerName'

- **Permissions:** Running CIM cmdlets against remote machines requires appropriate permissions on the target machine. You often need local administrator rights on the remote machine. If you run PowerShell as a standard user, remote queries will likely fail with an "Access Denied" error.

- **Credentials:** Get-CimInstance **does not** have a -Credential parameter. If you need to use different credentials for the remote connection, you _must_ use a CIM Session.


### **16.4 Using CIM Sessions**

CIM Sessions provide a more robust and efficient way to manage connections to remote computers, especially when:

- You need to use alternate credentials.

- You need to use a different protocol (like DCOM).

- You are making multiple queries to the same remote computer (avoids connection setup/teardown overhead for each command).

- **Creating a Session:** Use New-CimSession.\
  \# Create a WSMan session (default) using alternate credentials\
  $cred = Get-Credential # Prompts for username/password\
  $wsmanSession = New-CimSession -ComputerName 'RemoteServerName' -Credential $cred\
  \
  \# Create a DCOM session option (for older systems without WSMan/PowerShell v3+)\
  $dcomOption = New-CimSessionOption -Protocol Dcom\
  $dcomSession = New-CimSession -ComputerName 'LegacyServerName' -SessionOption $dcomOption -Credential $cred

- **Using a Session:** Pass the session variable to the -CimSession parameter of CIM cmdlets.\
  \# Query using the WSMan session\
  Get-CimInstance -CimSession $wsmanSession -ClassName Win32\_OperatingSystem\
  \
  \# Query using the DCOM session\
  Get-CimInstance -CimSession $dcomSession -ClassName Win32\_BIOS

- **Querying Multiple Computers:** You can pass an array of sessions to -CimSession.\
  $allSessions = Get-CimSession # Gets all active sessions\
  Get-CimInstance -CimSession $allSessions -ClassName Win32\_LogicalDisk

- **Managing Sessions:**

* Get-CimSession: Lists active CIM sessions.

* Remove-CimSession: Closes sessions and releases resources. It's good practice to remove sessions when you're finished.\
  \# Remove a specific session\
  Remove-CimSession -Id $wsmanSession.Id\
  \
  \# Remove all sessions\
  Get-CimSession | Remove-CimSession


## **17. PowerShell Remoting**

While CIM cmdlets are great for querying WMI data remotely, PowerShell also has a dedicated remoting system built primarily around the WSMan protocol for running _any_ PowerShell command or script on remote machines.


### **17.1 Enabling Remoting**

PowerShell Remoting needs to be enabled on the _target_ machine you want to connect to. Run this command in an elevated PowerShell session on the target machine:

Enable-PSRemoting -Force # Use -Force to skip confirmation prompts

This command configures the WinRM (Windows Remote Management) service, sets firewall rules, and registers session configurations.


### **17.2 One-to-One Remoting (Interactive Session)**

Use Enter-PSSession to start an interactive session on a single remote computer. It's like being logged directly into the console of the remote machine.

\# Store credentials if needed (prompts for username/password)\
$cred = Get-Credential\
\
\# Enter the session\
Enter-PSSession -ComputerName 'RemoteServerName' -Credential $cred\
\
\# Your prompt changes to indicate the remote connection:\
\# \[RemoteServerName]: PS C:\Users\YourUser\Documents>\
\
\# Commands run here execute on the \*remote\* machine\
\[RemoteServerName]: Get-Process -Name notepad\
\
\# Exit the remote session and return to your local prompt\
\[RemoteServerName]: Exit-PSSession


### **17.3 One-to-Many Remoting (Invoke-Command)**

Use Invoke-Command to run a script block (commands enclosed in {}) on one or more remote computers simultaneously. This is extremely powerful for automation across multiple systems.

\# Get the status of the w32time service on multiple servers\
Invoke-Command -ComputerName server1, server2, server3 -ScriptBlock {\
    Get-Service -Name w32time\
} -Credential $cred\
\
\# Stop the w32time service on multiple servers\
Invoke-Command -ComputerName server1, server2, server3 -ScriptBlock {\
    Stop-Service -Name w32time -Force\
} -Credential $cred


### **17.4 Deserialized Objects**

When Invoke-Command runs commands remotely, the results (objects) are sent back to your local machine. These objects are **deserialized** – they are snapshots of the object's state (properties) at the time the command ran remotely.

- **What's Missing?** Deserialized objects typically lose their original methods. They are inert representations, not live objects.

- **Implication:** You cannot call methods (like .Stop() or .Start()) on the objects _after_ they have been returned to your local session by Invoke-Command.

- **Workaround:** If you need to call a method, do it _inside_ the -ScriptBlock parameter of Invoke-Command so it executes on the remote machine before the object is deserialized and returned.

\# Get deserialized service objects (methods won't work locally)\
$remoteServices = Invoke-Command -ComputerName server1 -ScriptBlock { Get-Service -Name w32time } -Credential $cred\
\
\# This will likely FAIL because $remoteServices contains deserialized objects without a Stop() method\
\# $remoteServices.Stop() # Error!\
\
\# CORRECT way to call a method remotely: Call it inside the script block\
Invoke-Command -ComputerName server1 -ScriptBlock {\
    (Get-Service -Name w32time).Stop() # Call Stop() method remotely\
} -Credential $cred


### **17.5 Persistent PowerShell Sessions (PSSessions)**

Similar to CIM Sessions, PSSessions provide a persistent connection to remote computers, which is more efficient than Invoke-Command -ComputerName if you're running multiple commands against the same machine(s).

- **Creating Sessions:** Use New-PSSession.\
  $cred = Get-Credential\
  $mySession = New-PSSession -ComputerName server1, server2 -Credential $cred

- **Using Sessions:** Pass the session variable(s) to the -Session parameter of Invoke-Command.\
  \# Run multiple commands using the same persistent session\
  Invoke-Command -Session $mySession -ScriptBlock { Get-Service -Name w32time }\
  Invoke-Command -Session $mySession -ScriptBlock { Get-Process -Name notepad }

- **Managing Sessions:**

* Get-PSSession: Lists active PSSessions.

* Remove-PSSession: Closes sessions. Always remove sessions when finished.\
  Remove-PSSession -Session $mySession\
  \# Or remove all sessions\
  Get-PSSession | Remove-PSSession


## **18. Creating Reusable Tools: Functions**

As your PowerShell commands become more complex or you find yourself repeating sequences, it's time to turn them into reusable functions. Functions are more tool-oriented and can be packaged into modules for easy sharing and distribution.


### **18.1 Basic Function Syntax**

A function is declared using the function keyword, followed by the function name, and a script block ({}) containing the code.

function Get-Greeting {\
    Write-Output "Hello, Developer!"\
}\
\
\# Call the function\
Get-Greeting


### **18.2 Naming Conventions**

- **Verb-Noun:** Use an approved PowerShell verb (Get, Set, New, Invoke, etc.) followed by a singular noun. Find approved verbs with Get-Verb.

- **PascalCase:** Capitalize the first letter of the verb and the noun (e.g., Get-Something, Invoke-MyAction).

- **Prefixing:** To avoid naming conflicts with built-in cmdlets or other modules, prefix the noun part (e.g., Get-MyCompanyData, Invoke-JSTool). Choose a standard prefix (like company initials, project name) and stick to it. Using unapproved verbs or generic names can cause import warnings and make functions harder to discover.

\# Good: Approved verb, PascalCase, prefixed noun\
function Get-MyPSVersion {\
    $PSVersionTable.PSVersion\
}\
\
\# Less Good: Generic name, potential conflict\
function Get-Version {\
    $PSVersionTable.PSVersion\
}


### **18.3 Parameters**

Functions become truly reusable when you use parameters instead of hardcoding values.

- **param() Block:** Define parameters inside a param() block at the beginning of the function.

- **Standard Names:** Use standard parameter names where applicable (e.g., ComputerName, Path, Identity, Credential) to maintain consistency with built-in cmdlets.

- **Data Typing:** Always specify a data type for your parameters (e.g., \[string], \[int], \[string\[]] for an array of strings). This provides basic validation.

- **Mandatory Parameters:** Use the \[Parameter(Mandatory)] attribute (or \[Parameter(Mandatory=$true)] for PS v2 compatibility) to require a value for a parameter. The user will be prompted if it's omitted.

- **Default Values:** Provide a default value if a parameter is optional (\[string]$ComputerName = $env:COMPUTERNAME). Cannot be used with Mandatory.

- **Validation Attributes:** Use attributes like \[ValidateNotNullOrEmpty()] to ensure a parameter isn't null or an empty string, even if it has a default value or isn't mandatory.

function Get-RemoteServiceStatus {\
    param (\
        # Parameter is mandatory, accepts an array of strings\
        \[Parameter(Mandatory)]\
        \[string\[]]$ComputerName,\
\
        # Optional parameter, defaults to 'WinRM'\
        \[string]$ServiceName = 'WinRM'\
    )\
\
    # Function logic using $ComputerName and $ServiceName\
    foreach ($Computer in $ComputerName) {\
        Get-Service -ComputerName $Computer -Name $ServiceName\
    }\
}


### **18.4 Advanced Functions (CmdletBinding)**

Adding the \[CmdletBinding()] attribute above the param() block turns a simple function into an _advanced function_.

- **Common Parameters:** Advanced functions automatically gain the common parameters (-Verbose, -Debug, -ErrorAction, -WarningAction, -OutVariable, etc.) without you needing to define them.

- **SupportsShouldProcess:** Add SupportsShouldProcess within CmdletBinding (\[CmdletBinding(SupportsShouldProcess)]) for functions that make changes (e.g., stopping services, deleting files). This automatically adds the -WhatIf and -Confirm parameters, allowing users to test the command or confirm actions. You'll need to incorporate if ($PSCmdlet.ShouldProcess(...)) checks within your function logic to respect -WhatIf and -Confirm.

function Stop-MyProcess {\
    \[CmdletBinding(SupportsShouldProcess)] # Enable common parameters + WhatIf/Confirm\
    param(\
        \[Parameter(Mandatory)]\
        \[string]$ProcessName\
    )\
\
    # Check if we should proceed (respects -WhatIf and -Confirm)\
    if ($PSCmdlet.ShouldProcess($ProcessName, "Stop Process")) {\
        # Actual command to stop the process\
        Write-Host "Stopping process $ProcessName..."\
        # Stop-Process -Name $ProcessName # Example action\
    }\
}


### **18.5 Verbose Output (Write-Verbose)**

Instead of inline comments (#) for explaining steps within your function, use Write-Verbose.

- **User Control:** The output from Write-Verbose is only displayed if the user runs the function with the -Verbose common parameter.

- **Clarity:** Provides operational insight to the user when needed, without cluttering the standard output.

function Process-MyData {\
    \[CmdletBinding()]\
    param($InputData)\
\
    Write-Verbose "Starting data processing for: $InputData"\
    # ... processing logic ...\
    Write-Verbose "Finished data processing."\
    # Return results\
}\
\
\# Normal run - no verbose output\
Process-MyData -InputData "Example"\
\
\# Run with -Verbose to see the messages\
Process-MyData -InputData "Example" -Verbose


### **18.6 Accepting Pipeline Input**

Make your functions work seamlessly in the pipeline like built-in cmdlets.

- **process Block:** Place the main logic of your function that needs to operate on _each_ pipeline object inside a process { ... } block.

- **ValueFromPipeline Attribute:** To accept input By Value (Type), add \[Parameter(ValueFromPipeline)] to the parameter definition. Only one parameter per type can accept input this way.

- **ValueFromPipelineByPropertyName Attribute:** To accept input By Property Name, add \[Parameter(ValueFromPipelineByPropertyName)] to the parameter definition. The incoming object must have a property with the _exact same name_ as the parameter (or a defined alias). Multiple parameters can accept input this way.

function Test-PipelineInput {\
    \[CmdletBinding()]\
    param (\
        # Accepts pipeline input if the incoming object IS a string (By Value)\
        # OR if the incoming object has a property named 'ComputerName' (By Property Name)\
        \[Parameter(Mandatory,\
&#x20;                  ValueFromPipeline,\
&#x20;                  ValueFromPipelineByPropertyName)]\
        \[string\[]]$ComputerName\
    )\
\
    # This block runs ONCE for EACH object coming from the pipeline\
    process {\
        foreach ($Computer in $ComputerName) { # Handle arrays if multiple values passed at once\
&#x20;            Write-Output "Processing computer: $Computer"\
&#x20;            # Test-Connection -ComputerName $Computer -Count 1 # Example action\
        }\
    }\
}\
\
\# Example Usage:\
\# By Value (piping strings)\
'Server1', 'Server2' | Test-PipelineInput\
\
\# By Property Name (piping objects with a 'ComputerName' property)\
Get-ADComputer -Filter \* | Select-Object Name, @{N='ComputerName'; E={$\_.Name}} | Test-PipelineInput

- **begin and end Blocks:**

* begin { ... }: Code runs _once_ before any pipeline input is processed. Good for initialization. Cannot access pipeline input variables ($\_).

* end { ... }: Code runs _once_ after all pipeline input has been processed. Good for cleanup or summarizing results.


### **18.7 Error Handling (Try/Catch)**

Handle potential errors gracefully using Try/Catch blocks.

- **Try { ... }:** Place the code that might generate an error inside the Try block.

- **Catch { ... }:** If a _terminating_ error occurs in the Try block, the code in the Catch block executes. You can access the error details via the automatic $\_ variable within the Catch block.

- **Terminating vs. Non-Terminating Errors:** By default, Try/Catch only catches _terminating_ errors (those that stop the command completely). Many cmdlets generate _non-terminating_ errors by default (they write an error but continue processing).

- **Forcing Termination (-ErrorAction Stop):** To catch a non-terminating error with Try/Catch, you must convert it to a terminating error by adding -ErrorAction Stop to the command inside the Try block.

function Test-MyConnection {\
    \[CmdletBinding()]\
    param(\
        \[Parameter(ValueFromPipeline)]\
        \[string]$ComputerName\
    )\
    process {\
        try {\
            # Test-WSMan generates a non-terminating error by default if it fails\
            # Add -ErrorAction Stop to make it terminating so Catch block runs\
            Test-WSMan -ComputerName $ComputerName -ErrorAction Stop\
            Write-Output "$ComputerName is reachable."\
        }\
        catch {\
            # $\_ here contains the error record\
            Write-Warning "Failed to connect to $ComputerName. Error: $($\_.Exception.Message)"\
        }\
    }\
}


### **18.8 Comment-Based Help**

Make your functions discoverable and usable by adding comment-based help. Place a special comment block (<# ... #>) directly _before_ the function keyword or the param() block.

- **Keywords:** Use dot-sourced keywords like .SYNOPSIS, .DESCRIPTION, .PARAMETER ParameterName, .EXAMPLE, .INPUTS, .OUTPUTS, .NOTES.

- **Discoverability:** Get-Help works on functions with comment-based help just like built-in cmdlets.

<#\
.SYNOPSIS\
  Gets the PowerShell version from one or more computers.\
.DESCRIPTION\
  A longer description explaining what the function does. It uses Test-WSMan\
  to check connectivity before attempting to get the version remotely via\
  Invoke-Command.\
.PARAMETER ComputerName\
  Specifies the target computer(s). Accepts pipeline input By Value and\
  By Property Name. Defaults to the local computer.\
.EXAMPLE\
  Get-MyRemotePSVersion -ComputerName Server01, Server02\
.EXAMPLE\
  'Server01', 'ServerDC' | Get-MyRemotePSVersion\
.INPUTS\
  String\[]\
.OUTPUTS\
  PSCustomObject\
.NOTES\
  Author: Your Name\
  Requires PowerShell Remoting to be enabled on target computers.\
\#>\
function Get-MyRemotePSVersion {\
    \[CmdletBinding()]\
    param(\
        \[Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]\
        \[ValidateNotNullOrEmpty()]\
        \[string\[]]$ComputerName = $env:COMPUTERNAME\
    )\
    process {\
        foreach ($Computer in $ComputerName) {\
            Write-Verbose "Processing $Computer"\
            try {\
                if (Test-WSMan -ComputerName $Computer -ErrorAction Stop) {\
                    Invoke-Command -ComputerName $Computer -ScriptBlock {\
                        $PSVersionTable.PSVersion\
                    } | Select-Object \* -ExcludeProperty RunspaceId, PSShowComputerName |\
                      Add-Member -MemberType NoteProperty -Name ComputerName -Value $Computer -PassThru\
                }\
            }\
            catch {\
                Write-Warning "Could not connect to or get version from $Computer. Error: $($\_.Exception.Message)"\
            }\
        }\
    }\
}


## **19. Packaging Code: Script Modules**

When you have functions you want to reuse or share, package them into a **script module**. This makes your code more organized, professional, and easier to distribute.


### **19.1 Dot-Sourcing vs. Modules**

- **Dot-Sourcing (. .\MyScript.ps1):** If you define functions in a regular .ps1 script file, they only exist in the Script scope and disappear when the script finishes. Dot-sourcing executes the script in the _current_ scope (usually Global), making the functions available in your session. However, this is cumbersome for managing multiple functions or sharing code.\
  \# Assume Get-MrPSVersion function is defined in .\Get-MrPSVersion.ps1\
  \
  \# Dot-source the script to load the function into the current scope\
  . .\Get-MrPSVersion.ps1\
  \
  \# Now the function can be called\
  Get-MrPSVersion

- **Modules:** The preferred way to package reusable functions.


### **19.2 Creating a Script Module**

- **File Extension:** A basic script module is simply a file containing one or more PowerShell functions saved with a .psm1 extension (instead of .ps1).

- **Example:** Save these functions in a file named MyScriptModule.psm1:\
  \# Contents of MyScriptModule.psm1\
  function Get-MrPSVersion {\
      $PSVersionTable\
  }\
  function Get-MrComputerName {\
      $env:COMPUTERNAME\
  }\
  \# By default, all functions in a .psm1 are exported unless specified otherwise


### **19.3 Using Modules: Importing and Autoloading**

- **Manual Import:** Use Import-Module to load the functions from a .psm1 file into your current session.\
  Import-Module C:\path\to\MyScriptModule.psm1\
  Get-MrComputerName # Now works

- **Module Autoloading (Recommended):** PowerShell (v3+) can automatically load modules when you first call one of their commands. For this to work:

1. Create a folder with the **exact same name** as your .psm1 file (e.g., MyScriptModule folder for MyScriptModule.psm1).

2. Place the .psm1 file inside that folder.

3. Place that folder inside one of the directories listed in your $env:PSModulePath environment variable.

- Common paths include:

* C:\Users\\\<YourUser>\Documents\WindowsPowerShell\Modules (Current User)

* C:\Program Files\WindowsPowerShell\Modules (All Users - requires admin rights to write here)

* System paths (usually best left for OS/Microsoft modules)

- Check your paths: $env:PSModulePath -split ';'

* Once set up correctly, just calling Get-MrComputerName will automatically load the MyScriptModule module.


### **19.4 Module Manifests (.psd1)**

While not strictly required for a basic script module, a **module manifest** (.psd1 file) is highly recommended. It provides metadata about your module.

- **Purpose:** Stores information like version number, author, description, required modules, and crucially, controls exactly which functions/cmdlets/variables are exported.

- **Creating a Manifest:** Use New-ModuleManifest.

* -Path: Specify the path for the .psd1 file (should be in the module folder, same base name as the module, e.g., MyScriptModule.psd1).

* -RootModule: Specify the name of your main module file (e.g., MyScriptModule.psm1).

* Other useful parameters: -Author, -Description, -CompanyName, -ModuleVersion.

\# Example creating a manifest\
$manifestParams = @{\
    Path              = "C:\Program Files\WindowsPowerShell\Modules\MyScriptModule\MyScriptModule.psd1"\
    RootModule        = 'MyScriptModule.psm1' # Link to the .psm1 file\
    ModuleVersion     = '1.0.0'\
    Author            = 'Your Name'\
    Description       = 'A module containing my useful functions.'\
    FunctionsToExport = '\*' # Export all functions by default, or list specific ones\
}\
New-ModuleManifest @manifestParams

- **Updating:** Use Update-ModuleManifest to modify an existing manifest. Don't use New-ModuleManifest again, as it creates a new unique ID (GUID).


### **19.5 Controlling Function Visibility (Public vs. Private)**

You often have helper functions within a module that shouldn't be directly callable by the user.

- **Without a Manifest (Export-ModuleMember):** If you only have a .psm1 file, add Export-ModuleMember -Function FunctionNameToExport at the end of the file. Only functions explicitly listed will be exported; others remain private (but usable by other functions within the .psm1).\
  \# Inside MyScriptModule.psm1\
  function Get-PublicFunction { # This will be exported\
      Write-Host "Public function called."\
      Invoke-PrivateHelper # Can call private function\
  }\
  function Invoke-PrivateHelper { # This will NOT be exported\
      Write-Host "Private helper called."\
  }\
  Export-ModuleMember -Function Get-PublicFunction

- **With a Manifest (FunctionsToExport - Recommended):** This is the preferred method. In the .psd1 manifest file, list the specific function names you want to make public in the FunctionsToExport section. You can use wildcards (\*) to export all, but explicitly listing is safer. Functions _not_ listed here remain private to the module.\
  \# Inside MyScriptModule.psd1\
  @{\
  \# ... other manifest settings ...\
  RootModule = 'MyScriptModule.psm1'\
  \# Export only Get-PublicFunction, Invoke-PrivateHelper remains private\
  FunctionsToExport = 'Get-PublicFunction'\
  \# ... more settings ...\
  }


## **20. Why PowerShell for Developers?**

While often seen as an admin tool, PowerShell is great for developers too:

- **Automating Build/Test/Deploy Tasks:** Scripting CI/CD pipeline steps.

- **Managing Cloud Resources:** Interacting with Azure, AWS, GCP APIs.

- **Working with Data:** Easily handling JSON, CSV, XML data.

- **Environment Setup:** Scripting the configuration of development environments.

- **Git Integration:** Many Git commands work directly, and specific modules enhance the experience.

- **Cross-Platform Scripting:** Write scripts that work across different operating systems.

This guide now covers packaging functions into script modules. Let me know what's next!
