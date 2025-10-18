# Security Guidelines for BC Page Scripting Project

## Overview

This repository contains Business Central page automation scripts and tools. Before using these scripts in your environment, please review and follow these security guidelines.

## 🔐 Sensitive Information to Configure

### 1. Authentication Credentials

**Files Affected:** `npx-run.ps1`, `PO Post Prep-3 PS Variants/npx-run.ps1`

**What to Update:**
```powershell
# Replace this placeholder:
$env:BC_AAD_USERNAME = "YOUR_TEST_ACCOUNT@yourdomain.onmicrosoft.com"

# With your actual test account:
$env:BC_AAD_USERNAME = "test.runner@yourcompany.onmicrosoft.com"
```

⚠️ **Never commit actual passwords to version control.** These scripts prompt for passwords at runtime.

### 2. Environment URLs

**Files Affected:** `npx-run.ps1`, `PO Post Prep-3 PS Variants/npx-run.ps1`

**What to Update:**
```powershell
# Replace this placeholder:
-StartAddress "https://businesscentral.dynamics.com/YOUR_TENANT.onmicrosoft.com/YOUR_ENVIRONMENT"

# With your actual BC environment:
-StartAddress "https://businesscentral.dynamics.com/contoso.onmicrosoft.com/Production"
```

### 3. File Paths

**Files Affected:** `Generate-BC-Script-Variants.ps1`

The script now uses relative paths (`.\Script Prompts\Run Me`). If your folder structure differs:

```powershell
# Update the OutputFolder parameter when calling the script:
.\Generate-BC-Script-Variants.ps1 -BaseScriptPath ".\YourPath\Base.yml" -ProjectFolder ".\YourProject" -OutputFolder ".\YourOutput"
```

## 🛡️ Best Practices

### For Development

1. **Use Test Accounts Only**
   - Never use production credentials
   - Create dedicated test accounts with minimal permissions
   - Use accounts without MFA for automation (in isolated test environments only)

2. **Isolate Test Environments**
   - Run scripts only in sandbox/test environments
   - Never point scripts at production BC instances
   - Use separate tenants for testing when possible

3. **Protect Local Copies**
   - Keep local copies of scripts with real credentials outside version control
   - Use `.gitignore` patterns for personal configuration files
   - Consider using environment variables or secure credential stores

### For Sharing/Publishing

1. **Before Committing:**
   - ✅ Replace all credentials with placeholders
   - ✅ Replace tenant names with generic examples
   - ✅ Replace personal file paths with relative paths
   - ✅ Remove any company-specific data or references

2. **Use Personal Config Files:**
   - Create `npx-run.local.ps1` with your actual credentials (gitignored)
   - Keep `npx-run.ps1` with placeholders in version control
   - Document this pattern for team members

3. **Review Before Push:**
   - Use `git diff` to review changes
   - Search for email addresses: `@.*\.com`
   - Search for URLs: `https://businesscentral`
   - Search for absolute paths: `C:\Users\`

## 📋 Pre-Publish Checklist

Before sharing this repository publicly or with colleagues:

- [ ] All authentication credentials replaced with placeholders
- [ ] All tenant/environment URLs replaced with generic examples
- [ ] All absolute file paths converted to relative paths
- [ ] No personal email addresses in files
- [ ] No company-specific internal data
- [ ] `.gitignore` includes patterns for sensitive files
- [ ] README includes security setup instructions
- [ ] Test data uses only demo/sample company data

## 🚨 What NOT to Commit

### Never commit:
- ❌ Actual passwords or API keys
- ❌ Production environment URLs
- ❌ Personal email addresses
- ❌ Company-internal server names or IP addresses
- ❌ Customer data or real business information
- ❌ Files ending in `.local.*`, `.personal.*`, or `.private.*`

### Safe to commit:
- ✅ Placeholder credentials (e.g., `YOUR_TEST_ACCOUNT@yourdomain.onmicrosoft.com`)
- ✅ Demo/sample data from standard BC demo company
- ✅ Generic environment references
- ✅ Relative file paths
- ✅ Documentation and guides

## 🔍 How to Check for Sensitive Information

Run these searches before committing:

```powershell
# Search for email patterns
git grep -i "@.*\.onmicrosoft\.com"

# Search for specific domain (replace with your domain)
git grep -i "yourcompany"

# Search for absolute paths
git grep -i "C:\\Users\\"

# Search for URLs
git grep -i "https://businesscentral"
```

## 📞 Questions?

If you're unsure whether something is safe to commit, ask yourself:
1. Would I be comfortable with this information being public?
2. Could this information be used to access our systems?
3. Does this contain any customer or company-specific data?

When in doubt, use placeholders and document what users need to configure.

## 📝 Setting Up for First Use

1. Copy `npx-run.ps1` to `npx-run.local.ps1`
2. Update credentials and URLs in the `.local.ps1` file
3. Run your local version: `.\npx-run.local.ps1`
4. Never commit the `.local.ps1` file (it's in `.gitignore`)

This way you maintain a clean version-controlled template while keeping your actual credentials safe and local.

---

**Last Updated:** October 2025  
**Maintainer:** Project Team
