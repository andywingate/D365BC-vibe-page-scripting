# Business Central Page Scripting Project - Master Guide

## Overview

This repository contains comprehensive guidance and resources for generating reliable Business Central (BC) page automation scripts using AI assistance. Through iterative testing and refinement, we've developed proven patterns and methodologies that work consistently with BC's page scripting tool.

## Project Structure

### Main Repository Organization

```
BC Scripts/
├── README.md                    # This master guide
├── Page Script Prompt Engineering Best Practices.md
├── PO Scripts/                  # Legacy examples and patterns
└── [Project Folders]/          # Individual project subfolders
    ├── Prompt-[##] [Name].md   # Project-specific prompt template
    ├── TODO-[ProjectName].md   # Project to-do and progress tracking
    ├── [Reference Scripts]/    # Example starter scripts (.yml)
    ├── [Data Files]/           # CSV files for script variations
    └── [Generated Scripts]/    # Output folder for generated scripts
```

### Project Subfolder Requirements

Each BC page scripting project should have its own subfolder containing:

1. **Base Prompt File** (`Prompt-[##] [Name].md`)
   - Project-specific instructions following the proven template
   - Clear definition of the business process
   - Specific field requirements and CSV data integration points

2. **Project To-Do File** (`TODO-[ProjectName].md`)
   - Working document for progress tracking
   - Milestones and testing checkpoints
   - Issues encountered and resolutions

3. **Reference Scripts**
   - Clean example scripts (.yml files)
   - Raw recordings for comparison
   - Proven patterns specific to the project

4. **Data Files**
   - CSV files containing field values for script variations
   - Data dictionaries or field mapping documentation
   - Sample data for testing

5. **Generated Output**
   - Final working scripts
   - Documentation of successful patterns
   - Performance metrics and test results

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

## 🎯 Project Workflow

### Starting a New BC Page Scripting Project

1. **Create Project Subfolder**
   - Name: `[Project Number] - [Business Process]` (e.g., "01 - Purchase Order Posting")
   - Location: Under main BC Scripts folder

2. **Setup Project Files**
   - Copy and customize the base prompt template as `Prompt-[##] [Name].md`
   - Create `TODO-[ProjectName].md` for tracking progress
   - Gather reference recordings and clean scripts
   - Prepare CSV data files with field values

3. **Initialize AI Chat Session**
   - Attach the project prompt file
   - Include reference scripts and patterns as context
   - Provide business process documentation
   - Start with Step 1: Verify Prerequisites

4. **Follow Proven Methodology**
   - Build and test clean reference script first
   - Create single test variation with CSV data
   - Generate full series only after validation
   - Document lessons learned in the TODO file

### Existing Project Examples

- **PO Scripts/**: Legacy purchase order examples and patterns
- **SCS Demo 1/**: Purchase order posting demonstration project

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
2. **Create Project Plan:** Generate a script project to-do list in MD format with clear milestones and testing checkpoints for the full business process.
3. **Analyze Business Process:** Review the provided business process documentation (MD format) to understand the complete workflow and use appropriate business language.
4. **Build Clean Reference Script:** Help create a single, comprehensive clean reference script that covers the entire business process - this becomes the master template.
5. **Test Reference Script:** Validate the clean reference script works completely before proceeding to variations.
6. **Plan Data Integration:** Review all CSV files containing field values and plan how to create script variations using this data.
7. **Create Test Iteration:** Generate ONE test script variation using CSV data, validate it works completely.
8. **Generate Full Series:** Only after validating the pattern works, create the complete series of script iterations using all CSV data for field values.
9. **Final Quality Check:** Ensure all scripts follow clean patterns, have proper dependencies set, and include clear documentation.


**Format:**
- Use YAML page script format for Business Central
- Follow the clean patterns shown in examples
- Use consistent runtimeRef and field targeting

**Example:**
Base all work on proven patterns added to the project folders once we start working  

**Notes:**
- CRITICAL: Request recording examples if you don't have them
- Remove artifacts: isFilterAsYouType, FilteredTypeField, lookup page events
- Use set-current-row instead of "New Line" actions
- Test dependencies before accessing dependent fields
- Build complexity gradually with tested patterns
- Follow the pre-implementation checklist from the README

**Current task:** 
[Describe your specific BC page script requirement here including which fields will have lists provided for the iterated scripts]
```

### Usage Instructions:
1. Create a new project subfolder following the structure above
2. Copy and customize the template as `Prompt-[##] [Name].md`
3. Gather all required reference materials and CSV data
4. Attach the prompt file and context to a new chat session
5. Follow the 9-step process systematically
6. Update the TODO file with progress and lessons learned

## 📊 Success Metrics Across Projects

- **Script Reliability:** 95%+ execution success rate
- **Development Efficiency:** 70% reduction in development time vs trial-and-error
- **Pattern Reusability:** Proven templates reduce new project setup time
- **Quality Consistency:** Standardized clean patterns across all projects
- **Knowledge Retention:** Documented patterns and gotchas prevent repeated mistakes

## 🔗 Related Resources

- `Page Script Prompt Engineering Best Practices.md` - Detailed presentation materials
- `PO Scripts/` - Legacy examples and established patterns
- Individual project folders for specific business processes