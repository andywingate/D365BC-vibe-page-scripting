# Business Central Page Scripting Project

Automate Business Central page testing using YAML-based scripts executed via Playwright. Record once, generate variants, test multiple combinations.

## 🚀 Quick Start

1. **Review Structure** - `page-scripting/` for scripts, `bc-replay/` for execution
2. **Study Examples** - See `page-scripting/PO Post DirectionsEMEA/` for working patterns
3. **Read the Guide** - Full walkthrough in [GETTING_STARTED.md](GETTING_STARTED.md)

**Core Principle:** Always request reference recordings before implementing new BC actions. Never guess!

## 🔒 Security Setup

**Before using:**
- Replace placeholder credentials in `bc-replay/npx-run.ps1`
- Update BC URL with your tenant/environment
- Never commit actual passwords

📖 **See [SECURITY.md](SECURITY.md) for complete setup instructions.**

## Project Structure

**`page-scripting/`** - Script generation and variant automation
- PowerShell generators (`Generate-BC-Script-Variants.ps1`)
- Project folders (e.g., `PO Post DirectionsEMEA/`, `PO Post DirectionsEMEA - Volume/`)
- Each folder contains: BASE recording, data files, process docs, and Variants output

**`bc-replay/`** - Test execution
- Script runner (`npx-run.ps1`)
- Test configuration and utilities

### Variant Generation Approaches

- **Standard (2D):** Items × Locations = 2D variant set
- **Volume (3D):** Vendors × Items × Locations = 3D variant set

Use `var-vendors`, `var-items`, `var-locations` naming for 3D generation.

### Project Folder Requirements

Each project needs:
- `*.yml` - Tested BASE recording
- `Process.md` - Business process documentation  
- `Prompt.md` - AI instructions template
- Data files (`Items`, `Locations`, `var-vendors`, etc.) - one value per line
- `Variants/` - Generated scripts output
- `TODO.md` (optional) - Progress tracking

## 🚨 Critical Rules for Script Generation

### 1. Always Request Examples First
Never implement BC actions without reference recordings. Use recorded patterns as-is; only change specific field values (items, locations, vendors).

### 2. Essential YAML Patterns

   **Header Fields:**
   ```yaml
   - type: input
     target:
       - page: Purchase Order
         runtimeRef: b3z4
       - field: [FieldName]
     value: "[Value]"
     description: Input <value>[Value]</value> into <caption>[FieldName]</caption>
   ```

   **First Line Entry:**
   ```yaml
   - type: focus
     target:
       - page: Purchase Order
         runtimeRef: b3z4
       - part: PurchLines
       - page: Purchase Order Subform
       - repeater: Control1
       - field: No.
     description: Focus <caption>No.</caption>
   - type: input
     target:
       - page: Purchase Order
         runtimeRef: b3z4
       - part: PurchLines
       - page: Purchase Order Subform
       - repeater: Control1
       - field: No.
     value: "[ItemNo]"
     description: Input <value>[ItemNo]</value> into <caption>No.</caption>
   ```

   **Additional Lines:**
   ```yaml
   - type: set-current-row
     target:
       - page: Purchase Order
         runtimeRef: b3z4
       - part: PurchLines
       - page: Purchase Order Subform
       - repeater: Control1
     targetRecord:
       relative: 1
     description: Set current row in <caption>Control1</caption>
   # Then follow with focus and input steps
   ```

### 3. Field Dependencies
Location Code requires Ship-to option = "Location" (value: 1) first. Always set dependencies before accessing fields.

### 4. Testing Approach
- Build clean BASE script → test manually
- Create single variant → validate substitution  
- Generate full suite → only after confirmation
- When in doubt, request recording

### 📋 Pre-Implementation Checklist
- [ ] Do I have a reference recording for each action?
- [ ] Have I preserved the YAML structure exactly as recorded?
- [ ] Are field dependencies properly set?
- [ ] Does the script follow established patterns?
- [ ] Have I only changed known variable fields (items, locations)?

### 🎯 Success Metrics
- Scripts execute without errors
- All fields are properly populated
- Actions complete successfully
- Scripts are maintainable and readable
- Performance is optimized (no unnecessary steps)

**Remember: When in doubt, ask for an example recording. It's better to request clarification than to guess and create non-working scripts.**

## 🔧 PowerShell Automation

### Generate-BC-Script-Variants.ps1
This script automates the creation of multiple test script variations from:
- A BASE recording YAML file
- Data files containing field values (Items, Locations, Vendors, etc.)

**Usage:**
```powershell
cd page-scripting
.\Generate-BC-Script-Variants.ps1
```

**Enhanced Version:**
`EXAMPLE Generate-BC-Script-Variants-Enhanced.ps1` adds:
- Improved error handling and detailed logging
- Variant validation before write
- Built-in support for `var-items`, `var-locations`, and `var-vendors`

The volume project (`PO Post DirectionsEMEA - Volume/`) demonstrates the multi-dimension variant approach and includes `PS script copilot-instructions.md` with AI-assisted PowerShell development guidance.

## 🐛 Troubleshooting

| Issue | Cause | Solution |
|-------|-------|----------|
| Field not found/visible | Missing dependency (e.g., Ship-to option not set) | Set all field dependencies before accessing dependent fields |
| Multiple line entry fails | Using "New Line" action instead of set-current-row | Use `set-current-row` with `targetRecord: relative: 1` |
| Script works once then fails | Runtime references change between sessions | Ensure runtimeRef values are consistent across recordings |
| Data values mismatch | CSV file doesn't match BC test environment | Verify all Items, Locations, Vendors exist in test company |

### Debug Checklist
- [ ] All prerequisite data exists in BC (vendors, items, locations)
- [ ] Test-Runner account has proper permissions
- [ ] Dependencies set before accessing dependent fields
- [ ] YAML structure preserved as closely to original as possible from recorded example scripts
- [ ] BASE script tested successfully before creating variants

## 🎯 Project Workflow

### Starting a New BC Page Scripting Project

1. **Create Project Subfolder**
   - Name: `PO Post [Description]` (e.g., "PO Post SCS", "PO Post Inventory")
   - Location: Inside `page-scripting/` folder

2. **Setup Project Files**
   - Create `PO Post Simple Process.md` with business process documentation
   - Create `PO Post Simple Prompt.md` for AI prompt template
   - Create `BASE Recording.yml` - your tested base script
   - Create data files (`Items`, `Locations`, `var-vendors`, etc.)
   - Create `Variants/` subfolder
   - Create `TODO-[ProjectName].md` (optional)

3. **Initialize AI Chat Session**
   - Attach the project prompt file
   - Include reference scripts from existing projects
   - Provide business process documentation
   - Start with Step 1: Verify Prerequisites

4. **Follow Proven Methodology**
   - Build and test clean reference script first (BASE script)
   - Create single test variation with data files
   - Generate full series only after validation
   - Document lessons learned in the TODO file

### Existing Project Examples

- **`page-scripting/PO Post DirectionsEMEA/`** - Clean reference with BASE + Items + Locations and a working variant
- **`page-scripting/PO Post DirectionsEMEA - Volume/`** - Volume generation with `var-vendors`, `var-items`, `var-locations` producing large variant sets

## 🎯 Complete Prompt Template for Future BC Page Script Generation

### Copy this template for future chat sessions:

```
**Instructions:**
- You are an expert BC page script generator. I need you to create/modify Business Central (BC) page automation scripts in YAML format following proven patterns.
- You must ALWAYS request reference recordings before implementing any new BC actions. Never guess or improvise - follow exact patterns from examples.
- Do not generate new steps in scripts unless you have been provided an example that shows the exact pattern.
- You must be provided with an explanation of the business processes we are following in MD format so you can understand the steps and help to use this language when debugging issues
- You must iterate scripts gradually and test with me before creating any large batches of scripts 
– Always create a script project to-do list in MD format, make a plan and check off action create and test the scripts together.
- The main task is to help me create a clean reference script for the full business process described and then create a series of iterations based on additional data provided in a series of CSV files for field values. 


**Steps:**
1. **Verify Prerequisites:** Check if I've provided reference recordings for all requested actions in the business process. If any actions lack examples, STOP and request recordings before proceeding.
2. **Test Reference Script:** Ask me if I have tested the base script and it works for the test-runner account before proceeding to variations.
3. **Plan Data Integration:** Review all CSV/text files containing field values and plan how to create script variations using this data.
4. **Create Test Iteration:** Generate ONE test script variation using CSV data, validate it works completely.
5. **Generate Full Series:** Only after validating the pattern works, create the complete series of script iterations using all CSV data for field values.
6. **Final Quality Check:** Ensure all scripts follow known patterns (i.e. tested examples have been provided), and include clear documentation.


**Format:**
- Use YAML page script format for Business Central
- Follow the clean patterns shown in examples
- Use consistent runtimeRef and field targeting

**Example:**
Base all work on proven patterns added to the project folders once we start working  

**Notes:**
- CRITICAL: Request recording examples if you don't have them
- Test dependencies before accessing dependent fields
- Build complexity gradually with tested patterns
- Follow the pre-implementation checklist from the README

**Current task:** 
[Describe your specific BC page script requirement here including which fields will have lists provided for the iterated scripts]
```

### Data File Format

Data files (Items, Locations, Vendors) should be plain text with one value per line:

**Example - Items file:**
```
1896-S
1900-S
1906-S
```

**Example - Locations file:**
```
BLUE
EAST
MAIN
```

**Note:** Ensure all values exist in your BC test environment before generating variants.

### Usage Instructions:
1. Create a new project subfolder following the structure above
2. Copy and customize the template as your project prompt file (e.g., `PO Post Simple Prompt.md`)
3. Gather all required reference materials and data files
4. Create business process documentation (e.g., `PO Post Simple Process.md`)
5. Attach the prompt file and context to a new chat session
6. Follow the 6-step process systematically
7. Update the TODO file with progress and lessons learned (if applicable)

## 📝 Best Practices

### Do's ✅
- Always test the BASE script before creating variants
- Use plain text files for data (one value per line)
- Keep business process documentation updated
- Document lessons learned in TODO files
- Follow the 6-step methodology
- Request example recordings for new actions
- Build complexity gradually
- Ensure each generated script has a unique `telemetryId` (the provided generators do this)
- Prefer filename-safe values in data files; avoid OS-reserved characters. Punctuation like periods is allowed but may clutter variant names—normalize if desired.

### Don'ts ❌
- Don't skip testing the BASE script
- Don't create variants without validating the pattern first
- Don't use CSV/text field values that don't exist in BC
- Don't improvise BC action patterns without examples
- Don't batch generate scripts without testing one first
- Don't forget to update documentation

## 🔗 Related Resources

- [GETTING_STARTED.md](GETTING_STARTED.md) - Complete step-by-step guide
- [SECURITY.md](SECURITY.md) - Security guidelines and setup
- [South Coast Summit 2025 Blog Post](https://blog.wingate365.com/2025/10/south-coast-summit-2025-ai-driven-page.html) - AI-driven BC page scripting methodology
- `page-scripting/PO Post DirectionsEMEA/` - Standard 2D variant generation example
- `page-scripting/PO Post DirectionsEMEA - Volume/` - Volume 3D variant generation example

---

**Maintainer:** Project Team