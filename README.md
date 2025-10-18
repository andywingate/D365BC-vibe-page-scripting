# Business Central Page Scripting Project - Master Guide

## Overview

This repository contains comprehensive guidance and resources for generating reliable Business Central (BC) page automation scripts using AI assistance. Through iterative testing and refinement, we've developed proven patterns and methodologies that work consistently with BC's page scripting tool.

## 🚀 Quick Start

**New to this project?** Follow these steps:

1. **Review Structure** - Understand the difference between `Script Prompts/` (active projects) and `Vibe Scripting/` (proven examples)
2. **Study Examples** - Review `Vibe Scripting/PO Scripts/` for clean reference patterns
3. **Create Project Folder** - Set up a new subfolder under `Script Prompts/` with required files
4. **Use the Template** - Copy the complete prompt template (see below) for your AI session
5. **Follow the Workflow** - Work through the 6-step methodology systematically

**Key Principle:** Always request reference recordings before implementing new actions. Never guess!

## 🔒 Security & Privacy Notice

**Before using this repository:**

1. **Update Authentication Files** - Replace placeholder credentials in `npx-run.ps1` files with your actual test account details
2. **Configure Your Environment** - Update the BC URL with your tenant and environment name
3. **Use Relative Paths** - The scripts use relative paths; adjust if your folder structure differs
4. **Protect Credentials** - Never commit actual passwords or sensitive credentials to version control

**Required Setup:**
- Replace `YOUR_TEST_ACCOUNT@yourdomain.onmicrosoft.com` with your test account
- Replace `YOUR_TENANT.onmicrosoft.com` with your BC tenant
- Replace `YOUR_ENVIRONMENT` with your BC environment name
- Ensure your test account has appropriate BC permissions

📖 **See [SECURITY.md](SECURITY.md) for detailed security guidelines and setup instructions.**

## Project Structure

### 📁 Repository Organization

```
BC/
├── Script Prompts/                     # ✅ ACTIVE: Current project work
│   ├── Generate-BC-Script-Variants.ps1 # PowerShell automation script
│   ├── PO Post Prep-1/                 # Project preparation folder 1
│   ├── PO Post Prep-2/                 # Project preparation folder 2
│   ├── PO Post Prep-3 PS Variants/     # Enhanced PS variant generation
│   ├── PO Post SCS/                    # 🎯 SCS demonstration project
│   └── Run Me/                         # ✅ Generated script output folder
└── Vibe Scripting/                     # 📚 LEGACY: Proven examples & patterns
    ├── How to Create ADO Test Items Guide.md
    ├── PO Scripts/                     # ⭐ Clean reference scripts
    ├── Scripts Batch 1/                # First batch of generated scripts
    ├── ScriptBatch2/                   # Second batch folder
    └── SCS Demo 1/                     # Demo project example
```

**Key Distinction:**
- **Script Prompts/** = Active development, new projects, current work
- **Vibe Scripting/** = Proven patterns, reference examples, legacy scripts

### Project Subfolder Requirements

Each BC page scripting project should have its own subfolder containing:

1. **Process Documentation File** (`PO Post Simple Process.md`)
   - Clear business process documentation
   - Step-by-step workflow description
   - Field requirements and dependencies

2. **AI Prompt Template** (`PO Post Simple Prompt.md`)
   - Project-specific instructions following the proven template
   - Clear definition of the business process for AI
   - Specific field requirements and data integration points

3. **Project To-Do File** (`TODO-[ProjectName].md`) *(for active projects)*
   - Working document for progress tracking
   - Milestones and testing checkpoints
   - Issues encountered and resolutions

4. **Data Files** *(as needed)*
   - Text files containing field values for script variations (e.g., `Items`, `Locations`)
   - Data dictionaries or field mapping documentation
   - Sample data for testing

5. **Generated Output** *(in separate Run Me/ folder)*
   - Final working scripts with variations
   - Documentation of successful patterns
   - Performance metrics and test results

### Legacy Structure (Vibe Scripting folder)

Contains proven examples and working patterns:

1. **Reference Scripts** (`PO Scripts/`)
   - Clean example scripts (.yml files)
   - Proven patterns specific to purchase orders

2. **Script Batches** (`Scripts Batch 1/`, `ScriptBatch2/`)
   - Raw recordings for comparison
   - Generated script variations
   - Data files (e.g., `Itemcodes.txt`)

3. **Demo Projects** (`SCS Demo 1/`)
   - Complete project examples
   - Template patterns for new projects

## AI Instructions for Future BC Page Script Generation

## 🚨 CRITICAL RULES

1. **ALWAYS REQUEST EXAMPLES FIRST**
   - Never implement BC actions without a reference recording
   - If you don't have an example, ask the user to provide one
   - Follow the exact pattern shown in examples, don't improvise
   - Always prefer the clean pattern unless specifically told otherwise

1. **ESSENTIAL PATTERNS FOR SUCCESS**

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

4. **FIELD VISIBILITY DEPENDENCIES**
   - Location Code field requires Ship-to option set to "Location" (value: 1)
   - Always set dependencies before trying to access dependent fields
   - Test the sequence to ensure fields are visible when accessed

5. **WHAT TO AVOID**
   - Don't implement actions without reference examples

6. **TESTING APPROACH**
   - Start with simple scripts and build complexity gradually
   - Test each new action type with a reference example first
   - If something fails, request a new recording of that specific action
   - Clean up successful recordings by removing artifacts

7. **SCRIPT VARIANTS**
   - Use parameterization for item codes, vendor numbers, etc.
   - Create templates that can be easily modified for different scenarios
   - Keep both raw and clean versions for reference

### 📋 Pre-Implementation Checklist
- [ ] Do I have a reference recording for each action?
- [ ] Have I removed all recording artifacts?
- [ ] Are field dependencies properly set?
- [ ] Does the script follow established patterns?
- [ ] Have I tested incremental complexity?

### 🎯 Success Metrics
- Scripts execute without errors
- All fields are properly populated
- Actions complete successfully
- Scripts are maintainable and readable
- Performance is optimized (no unnecessary steps)

**Remember: When in doubt, ask for an example recording. It's better to request clarification than to guess and create non-working scripts.**

## 🔧 PowerShell Automation

The repository includes PowerShell scripts for automating variant generation:

### Generate-BC-Script-Variants.ps1
Located in `Script Prompts/`, this script automates the creation of multiple test script variations from:
- A BASE recording YAML file
- Data files containing field values (Items, Locations, Vendors, etc.)

**Usage:**
```powershell
.\Generate-BC-Script-Variants.ps1
```

**Enhanced Version:**
`PO Post Prep-3 PS Variants/Generate-BC-Script-Variants-Enhanced.ps1` provides additional features:
- Improved error handling
- Detailed logging
- Variant validation

See `PS script copilot-instructions.md` in the project folder for AI-assisted PowerShell development guidance.

## 🐛 Troubleshooting Guide

### Common Issues and Solutions

| Issue | Cause | Solution |
|-------|-------|----------|
| Field not found/visible | Missing dependency (e.g., Ship-to option not set) | Set all field dependencies before accessing dependent fields |
| Lookup page artifacts | Raw recording includes FilterAsYouType events | Remove `isFilterAsYouType` and lookup page events for clean script |
| Multiple line entry fails | Using "New Line" action instead of set-current-row | Use `set-current-row` with `targetRecord: relative: 1` |
| Script works once then fails | Runtime references change between sessions | Ensure runtimeRef values are consistent across recordings |
| Data values mismatch | CSV file doesn't match BC test environment | Verify all Items, Locations, Vendors exist in test company |

### Debug Checklist
- [ ] All prerequisite data exists in BC (vendors, items, locations)
- [ ] Test-Runner account has proper permissions
- [ ] Dependencies set before accessing dependent fields
- [ ] Clean patterns used (artifacts removed)
- [ ] BASE script tested successfully before creating variants

## 🎯 Project Workflow

### Starting a New BC Page Scripting Project

1. **Create Project Subfolder**
   - Name: `[Project Description]` (e.g., "PO Post SCS", "PO Post Prep-1")
   - Location: Under `Script Prompts/` folder for active projects

2. **Setup Project Files**
   - Create `PO Post Simple Process.md` with business process documentation
   - Create `PO Post Simple Prompt.md` for AI prompt template
   - Create data files as needed (`Items`, `Locations`, etc.)
   - Create `TODO-[ProjectName].md` for tracking progress (if needed)

3. **Initialize AI Chat Session**
   - Attach the project prompt file
   - Include reference scripts from `Vibe Scripting/PO Scripts/` as context
   - Provide business process documentation
   - Start with Step 1: Verify Prerequisites

4. **Follow Proven Methodology**
   - Build and test clean reference script first
   - Create single test variation with data files
   - Generate full series only after validation
   - Output to `Script Prompts/Run Me/` folder
   - Document lessons learned in the TODO file

### Existing Project Examples

- **Vibe Scripting/PO Scripts/**: Clean reference scripts and patterns
- **Vibe Scripting/Scripts Batch 1/**: Legacy batch generation examples
- **Vibe Scripting/SCS Demo 1/**: Complete demo project with prompt and TODO
- **Script Prompts/PO Post SCS/**: Current active project with data files

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

### Don'ts ❌
- Don't skip testing the BASE script
- Don't create variants without validating the pattern first
- Don't use CSV field values that don't exist in BC
- Don't improvise BC action patterns without examples
- Don't batch generate scripts without testing one first
- Don't forget to update documentation

## 🎓 Learning Path

**For New Users:**
1. Start with `Vibe Scripting/PO Scripts/` - Review clean examples
2. Read `How to Create ADO Test Items Guide.md`
3. Study `Vibe Scripting/SCS Demo 1/` - Complete project example
4. Practice with a simple project in `Script Prompts/`

**For Experienced Users:**
- Use `Generate-BC-Script-Variants.ps1` for automation
- Contribute proven patterns back to the repository
- Help document new field patterns and gotchas

## 📊 Success Metrics Across Projects

- **Script Reliability:** 95%+ execution success rate
- **Development Efficiency:** 70% reduction in development time vs trial-and-error
- **Pattern Reusability:** Proven templates reduce new project setup time
- **Quality Consistency:** Standardized clean patterns across all projects
- **Knowledge Retention:** Documented patterns and gotchas prevent repeated mistakes

## 🔗 Related Resources

### External Resources
- [South Coast Summit 2025: AI-Driven Page Scripting Blog Post](https://blog.wingate365.com/2025/10/south-coast-summit-2025-ai-driven-page.html) - Detailed writeup on AI-driven BC page scripting methodology

### Internal Documentation
- [SECURITY.md](SECURITY.md) - **Important:** Security guidelines and setup instructions
- `Vibe Scripting/How to Create ADO Test Items Guide.md` - Azure DevOps integration guidance
- `Vibe Scripting/PO Scripts/` - ⭐ Clean reference scripts and established patterns
- `Vibe Scripting/Scripts Batch 1/` - Legacy examples and batch generation patterns
- `Script Prompts/PO Post Prep-3 PS Variants/PS script copilot-instructions.md` - PowerShell development guide
- `Script Prompts/` - Active project preparation and current work
- Individual project folders for specific business processes

## 📞 Support & Contribution

### Getting Help
- Review the Troubleshooting Guide above
- Check existing project folders for similar examples
- Consult the complete prompt template for methodology

### Contributing
- Document new field patterns you discover
- Share successful project structures
- Update this README with lessons learned
- Add proven examples to the repository

---

**Version:** 1.1  
**Last Updated:** October 2025  
**Maintainer:** Project Team