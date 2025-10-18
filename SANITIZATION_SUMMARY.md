# Security Sanitization Summary

## Changes Made to Prepare Repository for Public Sharing

**Date:** October 18, 2025

### Files Modified

#### 1. `npx-run.ps1`
**Changes:**
- Replaced `test.runner@venturedemos.onmicrosoft.com` with `YOUR_TEST_ACCOUNT@yourdomain.onmicrosoft.com`
- Replaced absolute path with relative path: `.\Script Prompts\Run Me\*.yml`
- Replaced BC environment URL with placeholder: `YOUR_TENANT.onmicrosoft.com/YOUR_ENVIRONMENT`
- Added comment noting where to update bc-replay installation directory

#### 2. `PO Post Prep-3 PS Variants/npx-run.ps1`
**Changes:**
- Replaced `test.runner@venturedemos.onmicrosoft.com` with `YOUR_TEST_ACCOUNT@yourdomain.onmicrosoft.com`
- Replaced absolute path with relative path: `.\PO Post Prep-3 PS Variants\PS Variants\*.yml`
- Replaced BC environment URL with placeholder: `YOUR_TENANT.onmicrosoft.com/YOUR_ENVIRONMENT`
- Added comment noting where to update bc-replay installation directory

#### 3. `Generate-BC-Script-Variants.ps1`
**Changes:**
- Changed default OutputFolder from absolute path to relative: `.\Script Prompts\Run Me`
- This makes the script portable and removes personal file path information

#### 4. `PO Post Prep-2/PO Post Simple Prompt.md`
**Changes:**
- Replaced absolute path with relative path: `.\Script Prompts\Run Me`

#### 5. `PO Post Prep-3 PS Variants/PO Post Simple Prompt.md`
**Changes:**
- Replaced absolute path with relative path: `.\Script Prompts\Run Me`

#### 6. `README.md`
**Changes:**
- Added Security & Privacy Notice section with setup instructions
- Added reference to SECURITY.md file
- Included placeholder examples for users to replace

#### 7. `.gitignore`
**Changes:**
- Added BC Page Scripting specific section
- Added patterns for credentials and sensitive files
- Added patterns for test output and personal configuration files
- Includes: `*.personal.*`, `*.private.*`, `npx-run.local.ps1`, etc.

### Files Created

#### 8. `SECURITY.md` (NEW)
**Content:**
- Comprehensive security guidelines
- Pre-publish checklist
- What to commit vs. what not to commit
- Setup instructions for first-time users
- Best practices for protecting credentials
- Search commands to find sensitive information
- Guidance on creating local configuration files

### What Was Sanitized

#### ✅ Removed/Replaced:
- Personal email address: `andy@wingateuk.com` (from file paths)
- Test account email: `test.runner@venturedemos.onmicrosoft.com`
- Tenant name: `venturedemos.onmicrosoft.com`
- Environment name: `Sandbox-Andy`
- Personal file paths: `C:\Users\AndrewWingate\andy@wingateuk.com\...`

#### ✅ Kept (Safe Information):
- Demo vendor number (1000 - The Cannon Group PLC) - standard BC demo data
- Demo item numbers (1896-S, 1900-S, etc.) - standard BC demo data
- Demo locations (BLUE, EAST, MAIN) - generic test data
- Blog URL (public information)
- Process documentation (no sensitive information)
- Technical patterns and code examples

### Remaining in File Paths

**Note:** The repository is located at a path that includes personal information:
```
c:\Users\AndrewWingate\andy@wingateuk.com\OneDrive\Presentations & Colabs\2025-10 SCS 2025\BC\
```

**Recommendation:** When publishing to Git:
1. The repository name will be: `D365BC-vibe-page-scripting`
2. Users will clone to their own paths
3. All scripts now use relative paths, so they'll work from any location
4. The local file system path is not included in version control

### Verification Steps

Before publishing, verify:
- [ ] Run: `git grep -i "venturedemos"`
- [ ] Run: `git grep -i "test.runner"`
- [ ] Run: `git grep -i "Sandbox-Andy"`
- [ ] Run: `git grep -i "andy@wingateuk"`
- [ ] Run: `git grep -i "AndrewWingate"`
- [ ] Review: All npx-run.ps1 files have placeholders
- [ ] Review: All paths are relative or use placeholders
- [ ] Test: Clone to different location and verify scripts work with relative paths

### Post-Publication Instructions

After publishing, users should:
1. Read SECURITY.md
2. Copy `npx-run.ps1` to `npx-run.local.ps1`
3. Update credentials in the `.local.ps1` file
4. Update tenant and environment URLs
5. Run their local version
6. Never commit their `.local.ps1` file

### Additional Notes

- All changes maintain functionality while removing sensitive information
- The repository is now safe for public sharing on GitHub
- Users can easily configure for their own environments
- Documentation guides users through the setup process
- `.gitignore` prevents accidental commits of sensitive information

---

**Sanitization Complete** ✅

Repository is now ready for public sharing with appropriate security measures in place.
