# Getting Started with BC Page Script Variants

Get up and running with BC page automation in 15 minutes.

## 📋 What You Need

- Business Central test environment (Sandbox)
- Test account with permissions (MFA disabled)
- PowerShell, Git, and BC Page Scripting tool (Playwright-based bc-replay)

⚠️ **Important:** Configure credentials first - see [SECURITY.md](SECURITY.md)

## 🚀 Setup (5 Minutes)

1. **Clone the repository**
   ```bash
   git clone https://github.com/andywingate/D365BC-vibe-page-scripting.git
   cd D365BC-vibe-page-scripting
   ```

2. **Configure environment**  
   Edit `bc-replay/npx-run.ps1` with your BC tenant, environment, and test account details

3. **Verify test data**  
   Ensure test vendors, items, and locations exist in your BC test company

## 📂 Repository Structure

- **`page-scripting/`** - Scripts and automation
  - PowerShell generators
  - Project folders with BASE recordings and data files
  
- **`bc-replay/`** - Test execution
  - Test runner and Playwright environment

## 🎯 Create Your First Variants (10 Minutes)

### 1. Study an Example
Look at `page-scripting/PO Post DirectionsEMEA/` to see:
- A BASE recording
- Data files (Items, Locations)
- Generated variants

**Concept:** 1 BASE recording + data files = multiple test variants

### 2. Create Your Project
```powershell
cd page-scripting
mkdir "MyProject"
```

### 3. Add Your Files
- Record a BASE script using BC's recorder → save as `BASE Recording.yml`
- Create data files: `Items` and `Locations` (plain text, one value per line)

### 4. Generate Variants
```powershell
.\Generate-BC-Script-Variants.ps1 `
    -BaseScriptPath ".\MyProject\BASE Recording.yml" `
    -ProjectFolder ".\MyProject" `
    -OutputFolder ".\MyProject\Variants"
```

### 5. Run Tests
```powershell
cd ..\bc-replay
.\npx-run.ps1
```

## 📚 Next Steps

- **[README.md](README.md)** - Detailed patterns, methodology, and best practices
- **[page-scripting/PAGE_SCRIPTING_QUICK_START.md](page-scripting/PAGE_SCRIPTING_QUICK_START.md)** - BC recording guide
- **[bc-replay/BC_REPLAY_QUICK_START.md](bc-replay/BC_REPLAY_QUICK_START.md)** - Test execution guide
- **[SECURITY.md](SECURITY.md)** - Security configuration
- **`.github/copilot-instructions.md`** - YAML patterns and examples
- **Example projects** - Study the working examples in `page-scripting/`

## � Quick Troubleshooting

| Issue | Check |
|-------|-------|
| Script fails | Test data exists in BC? Account has permissions? |
| Variants not generated | Data files formatted correctly (plain text, one per line)? |
| Need help | See [README.md](README.md) Troubleshooting section |