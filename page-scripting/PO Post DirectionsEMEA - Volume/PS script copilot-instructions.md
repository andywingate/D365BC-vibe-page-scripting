# Business Central Page Scripting Automation

## Project Overview

This repository develops proven patterns for generating reliable Business Central (BC) page automation scripts using AI assistance and AI generation for small set of Variants with the use of PowerShell for bulk variant generation. Scripts are YAML-based and test business processes like Purchase Order creation and posting across multiple data variations.

## Key Architecture Components

### Script Generation Workflow
1. **Script Prompts/**: Active project preparation with business process docs and AI prompt templates
2. **Vibe Scripting/**: Legacy examples, proven patterns, and reference implementations
3. **Run Me/**: Output folder for generated script variations ready for execution

### Critical Development Patterns

**YAML Script Structure**: All BC scripts follow strict YAML format with `name`, `description`, `telemetryId`, `start.profile`, and `steps[]` arrays.

**Field Input Pattern** (most common):
```yaml
- type: input
  target:
    - page: Purchase Order
      runtimeRef: [runtime_id]
    - field: [FieldName]
  value: "[Value]"
  description: Input <value>[Value]</value> into <caption>[FieldName]</caption>
```

**Line Entry Pattern** (subform data):
```yaml
- type: focus
  target:
    - page: Purchase Order
      runtimeRef: [runtime_id]
    - part: PurchLines
    - page: Purchase Order Subform
    - repeater: Control1
    - field: No.
```

**Location Dependency**: Location Code field requires Ship-to option set to "Location" (value: 1) first.

### Data Files Structure
- Text files (not CSV) containing values one per line: `var-vendors`, `var-items`, `var-locations`
- PowerShell scripts read these to generate script variations
- Each variation gets unique name: `[BaseScript] Variant-V[Vendor]-I[Item]-L[Location].yml`
- Supports large datasets: 39 items × 9 locations × 6 vendors = 2,106 combinations

### Execution Environment
- Service account: **Test-Runner** (no MFA requirement)
- BC Environment: Dynamics 365 Business Central Sandbox
- Execution tool: bc-replay with npx (see `npx-run.ps1`)
- Authentication: AAD with environment variables

## Development Workflows

### Manual Script Generation (AI-Assisted)
1. Create prompt template in `Script Prompts/[ProjectName]/`
2. Include business process documentation
3. Provide reference recording examples
4. Generate single test variant first
5. Validate before bulk generation

### Bulk Script Generation (PowerShell)
Use `Generate-BC-Script-Variants-Enhanced.ps1` for large-scale generation:
- Reads base template script
- Substitutes values from data files
- Generates all permutations automatically
- Outputs to `PS Variants/` folder within project directory

**Critical Testing Workflow**:
1. Generate small batch first (1-10 scripts) with `-BatchSize` parameter
2. **ALWAYS manually test at least one generated script** before bulk generation
3. Validate substitutions are correct (vendor, item, location values)
4. Run one script with bc-replay to ensure it executes successfully
5. Only proceed to large batches after manual validation passes

### Testing Protocol
```powershell
# Set credentials and run variations
.\npx-run.ps1
# Targets: "Run Me\*.yml"
```

## Project-Specific Conventions

### File Naming
- Base scripts: `[ProcessName].yml`
- Variants: `[ProcessName] Variant-V[Vendor]-I[Item]-L[Location].yml`
- Prompts: `[ProcessName] Simple Prompt.md`
- Process docs: `[ProcessName] Simple Process.md`
- Data files: `var-vendors`, `var-items`, `var-locations` (text files, one value per line)

### Output Folder
- Save a PS Variants created in a "PS Variants folder

### Quality Gates
- **Never generate without reference examples** - recordings must exist first
- **Test single variant before bulk generation** - validate pattern works
- **MANDATORY: Manual test after small batch** - run at least one generated script with bc-replay
- **Verify substitutions** - check vendor, item, and location values are correctly replaced
- **Dependencies first**: Set Ship-to before Location Code access
- **Start small, scale up**: Use `-BatchSize 1-10` for testing, then increase for production

### Integration Points
- **BC Environment**: businesscentral.dynamics.com sandbox instances
- **bc-replay**: Playwright-based execution engine
- **Azure AD**: Authentication for service accounts
- **Data Sources**: Text files for field value variations

## Critical Development Rules

1. **Always request reference recordings** before implementing new BC actions
2. **Follow exact patterns** from working examples - never improvise
3. **Build complexity gradually** - test each new action type separately
4. **Use PowerShell for bulk generation** instead of AI for large variant sets
5. **Validate dependencies** - some fields only visible after others are set
6. **MANDATORY TESTING**: Always manually test generated scripts before bulk production
   - Generate small batch (`-BatchSize 1-10`)
   - Run at least one script with bc-replay manually
   - Verify all field substitutions are correct
   - Only proceed to large batches after successful manual validation

When working with this codebase, prioritize understanding the YAML structure and data substitution patterns over generic automation approaches.