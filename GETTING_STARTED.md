# Getting Started with BC Page Script Variants

Welcome! This guide will walk you through creating your own Business Central page automation script variants using the resources and proven patterns in this repository.

## 📋 What You'll Learn

By following this guide, you'll be able to:
- Create a BASE recording script for your business process
- Generate multiple test variants from a single BASE script
- Use data files to automate variant creation
- Test and validate your scripts in BC

## 🎯 Prerequisites

Before you start, make sure you have:

### Technical Requirements
- ✅ Access to a Business Central test environment (Sandbox recommended)
- ✅ A test account with appropriate permissions (Test-Runner account)
- ✅ BC Page Scripting tool installed (Playwright-based)
- ✅ PowerShell (for automation scripts)
- ✅ Git (for cloning this repository)

### Knowledge Requirements
- ✅ Basic understanding of Business Central navigation
- ✅ Familiarity with the business process you want to automate
- ✅ Basic understanding of YAML format (helpful but not required)

### Security Setup
⚠️ **Important:** Before proceeding, read [SECURITY.md](SECURITY.md) and configure your credentials.

## 🚀 Quick Start (30 Minutes)

### Step 1: Clone and Configure (5 minutes)

1. **Clone the repository:**
   ```bash
   git clone https://github.com/andywingate/D365BC-vibe-page-scripting.git
   cd D365BC-vibe-page-scripting
   ```

2. **Configure credentials:**
   - Copy `npx-run.ps1` to `npx-run.local.ps1`
   - Edit `npx-run.local.ps1` and update:
     - `YOUR_TEST_ACCOUNT@yourdomain.onmicrosoft.com` → Your test account
     - `YOUR_TENANT.onmicrosoft.com` → Your BC tenant
     - `YOUR_ENVIRONMENT` → Your BC environment name

### Step 2: Study an Example (10 minutes)

1. **Review a clean reference script:**
   ```
   Open: PO Post Prep-3/PO create and post - 1896-S.yml
   ```

2. **Understand the structure:**
   - `name:` - Script identifier
   - `description:` - What the script does
   - `start:` - Which BC role center to start from
   - `steps:` - The actions to perform

3. **Review the business process:**
   ```
   Open: PO Post SCS/PO Post Simple Process.md
   ```

### Step 3: Create Your BASE Script (10 minutes)

**Option A: Record a New Script**

1. Use BC's page scripting recorder to record your process
2. Save the recording as `[YourProcess] BASE.yml`
3. Place it in a new project folder at root level (e.g., `PO Post MyProject/`)

**Option B: Use an Existing Example**

1. Copy a similar script from `PO Post Prep-1/` or `PO Post Prep-3/`
2. Modify field values for your specific needs
3. Test it works in your environment

### Step 4: Create Data Files (3 minutes)

Create text files with values for fields you want to vary:

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

Save these in your project folder (e.g., `Items`, `Locations`, `Vendors`)

### Step 5: Generate Variants (2 minutes)

Use the PowerShell script to generate variants:

```powershell
.\Generate-BC-Script-Variants.ps1 `
    -BaseScriptPath ".\YourProject\YourScript BASE.yml" `
    -ProjectFolder ".\YourProject" `
    -OutputFolder ".\YourProject\Variants"
```

This creates multiple variants combining all data file values!

## 📚 Detailed Walkthrough

### Part 1: Understanding the Repository Structure

#### Project Folders
This is where project work lives:

```
BC/
├── YourProject/                    # Create your project here
│   ├── YourProcess BASE.yml       # Your base recording
│   ├── Items                      # Data file for items
│   ├── Locations                  # Data file for locations
│   ├── Process.md                 # Business process doc
│   ├── Prompt.md                  # AI instructions (optional)
│   └── Variants/                  # Generated variants go here
├── PO Post Prep-1/                # Example complete project
├── PO Post Prep-2/                # Example alternative approach
└── PO Post Prep-3/                # Raw recordings example
```

#### Reference Examples
These existing folders contain proven patterns to learn from:

- **PO Post Prep-1/**: ⭐ Complete project with BASE, data files, and variants
- **PO Post Prep-3/**: Raw recordings and test scripts
- **PO Post SCS/**: SCS demonstration project

### Part 2: Creating Your First Project

#### Step 1: Create Project Folder

```powershell
# Create your project folder
New-Item -Path ".\My First Project" -ItemType Directory

# Navigate to it
cd ".\My First Project"
```

#### Step 2: Document Your Process

Create `Process.md` documenting your business process:

```markdown
# My Purchase Order Process

## Purpose
Post a simple purchase order to test vendor and item combinations

## Preconditions
- Vendor exists in system
- Items exist with proper setup
- Locations configured

## Steps
1. Navigate to Purchase Orders
2. Create new PO
3. Select vendor
4. Set location
5. Add item line
6. Set quantity
7. Post the order

## Expected Results
- PO successfully posted
- Posted purchase receipt created
```

#### Step 3: Record Your BASE Script

**Using BC Page Scripting Recorder:**

1. Start the recorder in BC
2. Perform your process exactly once with specific values:
   - Vendor: 10000
   - Item: 1896-S
   - Location: MAIN
   - Quantity: 1
3. Stop recording
4. Save as `My Process BASE.yml` in your project folder

**Key Recording Tips:**
- ✅ Use clear, common values in BASE recording
- ✅ Keep it simple - one complete happy path
- ✅ Don't add extra validation steps yet
- ✅ Complete the process fully (don't stop halfway)

#### Step 4: Test Your BASE Script

Before creating variants, test the BASE script works:

```powershell
# Copy BASE script to Run Me folder
Copy-Item "My Process BASE.yml" "..\Run Me\"

# Navigate to repository root
cd ..\..

# Run the script
.\npx-run.local.ps1
```

**Validation:**
- ✅ Script runs without errors
- ✅ All fields populate correctly
- ✅ Process completes successfully
- ✅ Expected results created in BC

⚠️ **Don't proceed to variants until BASE script is 100% working!**

#### Step 5: Create Data Files

Based on what you want to vary, create data files:

**Items file** (save as `Items`):
```
1896-S
1900-S
1906-S
1920-S
```

**Locations file** (save as `Locations`):
```
BLUE
EAST
MAIN
WEST
```

**Vendors file** (save as `Vendors` - if needed):
```
10000
20000
30000
```

**File Format Rules:**
- Plain text files (no extension)
- One value per line
- No quotes or special characters
- Values must exactly match BC data

#### Step 6: Generate Variants

```powershell
# Run variant generation script
.\Generate-BC-Script-Variants.ps1 `
    -BaseScriptPath ".\My First Project\My Process BASE.yml" `
    -ProjectFolder ".\My First Project" `
    -OutputFolder ".\My First Project\Variants"
```

**What this does:**
- Reads your BASE script
- Reads all data files (Items, Locations)
- Creates a variant for each combination
- Example: 4 items × 4 locations = 16 variants

**Generated files:**
```
My First Project/Variants/
├── My Process BASE Variant-1896-S-BLUE.yml
├── My Process BASE Variant-1896-S-EAST.yml
├── My Process BASE Variant-1896-S-MAIN.yml
├── My Process BASE Variant-1896-S-WEST.yml
├── My Process BASE Variant-1900-S-BLUE.yml
... (16 total)
```

#### Step 7: Test ONE Variant

Before running all variants, test one:

```powershell
# Navigate to your Variants folder and test one
cd ".\My First Project\Variants"
# Run the test
..\..\..\npx-run.local.ps1
```

Verify:
- ✅ Variant uses correct item from data file
- ✅ Variant uses correct location from data file
- ✅ All other fields correct
- ✅ Process completes successfully

#### Step 8: Run Full Test Suite

Once one variant works, run all of them:

```powershell
# All variants are in your Variants folder
# npx-run.local.ps1 runs all .yml files in that folder
..\..\..\npx-run.local.ps1
```

**Review results:**
- Check Playwright report
- Identify any failures
- Fix issues in BASE script
- Regenerate variants
- Re-test

### Part 3: Working with AI Assistance (Optional)

If you want to use AI (like GitHub Copilot) to help create or modify scripts:

#### Step 1: Create AI Prompt File

Copy the template from README.md and save as `Prompt.md` in your project:

```markdown
**Instructions:**
- You are an expert BC page script generator...
[Full template from README]

**Current task:** 
I need to create variants of a PO posting process for items [1896-S, 1900-S] 
and locations [BLUE, EAST, MAIN]. Start by reviewing the BASE script.
```

#### Step 2: Chat with AI

1. Attach your `Prompt.md` file
2. Attach your `Process.md` file
3. Attach your `BASE.yml` script
4. Attach your data files (Items, Locations)
5. Ask AI to help create/review variants

**Example prompts:**
- "Review my BASE script for any issues"
- "Help me create one variant for item 1900-S and location EAST"
- "Explain what fields need to change for variants"

## 🎯 Real-World Example

Let's walk through a complete example:

### Scenario: Test PO Posting Across Multiple Items and Locations

**Goal:** Create 6 test scripts (3 items × 2 locations)

**Step 1: Document Process**

Created `PO Post Test/Process.md`:
```markdown
# PO Post Test

Test posting POs with different item and location combinations.

Vendor: Always 10000
Items: 1896-S, 1900-S, 1906-S
Locations: BLUE, EAST
Quantity: Always 1
```

**Step 2: Record BASE**

Recorded process manually:
- Vendor: 10000
- Item: 1896-S
- Location: BLUE
- Quantity: 1
- Posted successfully

Saved as: `PO Post Test BASE.yml`

**Step 3: Create Data Files**

`Items`:
```
1896-S
1900-S
1906-S
```

`Locations`:
```
BLUE
EAST
```

**Step 4: Generate Variants**

```powershell
.\Generate-BC-Script-Variants.ps1 `
    -BaseScriptPath ".\PO Post Test\PO Post Test BASE.yml" `
    -ProjectFolder ".\PO Post Test" `
    -OutputFolder ".\PO Post Test\Variants"
```

**Result:** 6 variants created!

```
✅ PO Post Test BASE Variant-1896-S-BLUE.yml
✅ PO Post Test BASE Variant-1896-S-EAST.yml
✅ PO Post Test BASE Variant-1900-S-BLUE.yml
✅ PO Post Test BASE Variant-1900-S-EAST.yml
✅ PO Post Test BASE Variant-1906-S-BLUE.yml
✅ PO Post Test BASE Variant-1906-S-EAST.yml
```

**Step 5: Test and Validate**

Ran all 6 scripts - all passed! ✅

## 🐛 Common Issues and Solutions

### Issue 1: BASE Script Doesn't Work

**Symptoms:** Script fails, fields not found, timeout errors

**Solutions:**
- ✅ Verify all test data exists in BC (vendor, items, locations)
- ✅ Check Test-Runner account has permissions
- ✅ Review recording - remove any artifacts (isFilterAsYouType)
- ✅ Ensure field dependencies are set (e.g., Ship-to option)

### Issue 2: Variants Not Generated

**Symptoms:** PowerShell script runs but no variants created

**Solutions:**
- ✅ Check data file format (no quotes, one value per line)
- ✅ Verify file paths are correct
- ✅ Check OutputFolder exists
- ✅ Review PowerShell error messages

### Issue 3: Variant Values Not Substituted

**Symptoms:** Variants created but still use BASE values

**Solutions:**
- ✅ Check data file names match expected (Items, Locations)
- ✅ Verify BASE script has values that can be replaced
- ✅ Review PowerShell script replacement patterns
- ✅ Test with simple data first (2 items, 2 locations)

### Issue 4: Some Variants Fail, Others Pass

**Symptoms:** Intermittent failures

**Solutions:**
- ✅ Check failed variants use valid data (item/location exists)
- ✅ Review BC permissions for specific items/locations
- ✅ Check for timing issues (add waits if needed)
- ✅ Verify inventory setup for test items

## 📚 Next Steps

Once you've mastered the basics:

### Level 2: Advanced Techniques
- Create multi-field variants (vendor + item + location)
- Use AI to help clean up recordings
- Create reusable patterns for your team
- Build test suites for comprehensive coverage

### Level 3: Automation
- Set up scheduled test runs
- Create CI/CD pipelines
- Generate test reports
- Monitor test reliability

### Level 4: Contribution
- Share your patterns back to this repository
- Document new field patterns you discover
- Help others in the community
- Improve the automation scripts

## 🎓 Learning Resources

### In This Repository
- [README.md](README.md) - Complete reference guide
- [SECURITY.md](SECURITY.md) - Security setup and best practices
- `PO Post Prep-1/` - Complete example project with variants
- `PO Post Prep-3/` - Raw recordings and test scripts

### External Resources
- [Blog Post: AI-Driven Page Scripting](https://blog.wingate365.com/2025/10/south-coast-summit-2025-ai-driven-page.html)
- Microsoft BC Documentation
- Playwright Documentation

## ✅ Checklist: Your First Project

Use this checklist to track your progress:

- [ ] Repository cloned
- [ ] Credentials configured in `npx-run.local.ps1`
- [ ] Test environment accessible
- [ ] Reviewed example scripts in `PO Post Prep-1/` or `PO Post Prep-3/`
- [ ] Created project folder at root level
- [ ] Documented business process in `Process.md`
- [ ] Recorded BASE script
- [ ] Tested BASE script successfully
- [ ] Created data files (Items, Locations, etc.)
- [ ] Generated variants using PowerShell script
- [ ] Tested one variant
- [ ] Ran full test suite
- [ ] Reviewed and documented results

## 💡 Tips for Success

### Recording Tips
1. **Keep it simple** - Don't add extra steps in BASE recording
2. **Use common values** - Make replacement easier
3. **Complete the process** - Don't stop halfway
4. **Avoid manual delays** - Let BC load naturally

### Data File Tips
1. **Start small** - Test with 2-3 values first
2. **Verify in BC** - Ensure all values exist
3. **Use exact values** - Match BC data precisely
4. **One value per line** - No commas or quotes

### Testing Tips
1. **Test BASE first** - Don't create variants until BASE works
2. **Test one variant** - Validate pattern before bulk generation
3. **Review failures** - Learn from errors
4. **Iterate quickly** - Fix, regenerate, test

### Automation Tips
1. **Version control** - Commit BASE scripts and data files
2. **Document changes** - Note what worked/didn't work
3. **Share patterns** - Help your team
4. **Automate reporting** - Track test results

## 🆘 Getting Help

If you get stuck:

1. **Check the Troubleshooting Guide** in README.md
2. **Review example projects** - Check `PO Post Prep-1/`, `PO Post Prep-2/`, and `PO Post Prep-3/` folders
3. **Search for similar patterns** in existing scripts
4. **Check security setup** in SECURITY.md
5. **Review error messages** carefully

## 🎉 Success!

You're now ready to create your own BC page script variants!

Remember:
- Start simple and build complexity gradually
- Always test BASE before creating variants
- Use proven patterns from this repository
- Document what you learn
- Share your success with others

**Happy scripting! 🚀**

---

**Questions or feedback?** Open an issue on GitHub or contribute your improvements!

**Version:** 1.0  
**Last Updated:** October 2025  
**Maintainer:** Project Team
