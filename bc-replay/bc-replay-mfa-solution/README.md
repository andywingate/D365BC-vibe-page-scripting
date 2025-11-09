# BC Replay TOTP MFA Solution - README

✅ **Status:** Production Ready (November 9, 2025)

## Overview
This solution enables bc-replay to work with Business Central accounts that have TOTP (Time-based One-Time Password) MFA enabled. Automatic TOTP code generation integrates seamlessly with bc-replay's AAD authentication flow.

## 📁 Files in This Solution

| File | Purpose |
|------|---------|
| **README.md** | This file - complete documentation hub |
| **SETUP-INSTRUCTIONS.md** | Overview and quick reference |
| **QUICK-SETUP.md** | Fast 5-minute setup guide with automated installer |
| **SOLUTION.md** | Technical approach, design decisions, and testing history |
| **apply-mfa-patch.ps1** | **Automated patch installer** - recommended installation method |
| **commands.js.patch** | The actual code modification (applied automatically by script) |
| **test-mfa-template.ps1** | PowerShell test script template for your projects |
| **REFERENCE-working-non-mfa-test.ps1** | Example of working non-MFA test for comparison |

## 🚀 Quick Start

**New users:** Start with `QUICK-SETUP.md` for fastest setup.  
**Curious about how it works:** Read `SOLUTION.md` for technical details.  
**Need troubleshooting:** Continue reading below.

## What's Working ✅
- Automatic TOTP code generation during authentication
- Seamless integration with bc-replay's AAD authentication flow
- Clean test execution with MFA-enabled accounts
- No modification to bc-replay source needed (just node_modules patch)
- Safe fallback for non-MFA accounts

## Core Components

### 1. apply-mfa-patch.ps1 (Automated Installer)
**Recommended installation method** - Run this script to automatically apply the MFA patch.

**What it does:**
- Automatically locates bc-replay installation
- Creates timestamped backup of commands.js
- Applies the MFA patch from commands.js.patch
- Verifies successful installation
- Detects if patch is already applied

**Usage:**
```powershell
.\apply-mfa-patch.ps1
```

### 2. commands.js.patch (Core Modification)
The actual code modification to bc-replay's authentication flow. Adds TOTP handling after password entry.

**What it does:**
- Detects TOTP prompt after password submission
- Reads `BC_MFA_SEED` environment variable
- Generates 6-digit TOTP code using otplib
- Automatically fills and submits the code
- Continues with normal authentication flow

**Location:** Applied to `node_modules/@microsoft/bc-replay/player/dist/commands.js`

### 3. test-mfa-template.ps1 (Test Script Template)
PowerShell template for creating your own MFA-enabled test scripts.

**Usage:**
1. Copy to your testing folder
2. Replace placeholders:
   - `YOUR_EMAIL@YOUR_TENANT.onmicrosoft.com`
   - `YOUR_TENANT`
   - `YOUR_ENVIRONMENT`
   - `YOUR_SCRIPT.yml`
3. Run the script - it prompts securely for password and TOTP seed

## Installation Steps

### Prerequisites
```powershell
npm install otplib --save
```

### Apply the Patch

**Automated (Recommended):**
```powershell
cd bc-replay-mfa-solution
.\apply-mfa-patch.ps1
```

The script will:
- ✅ Locate bc-replay installation
- ✅ Create automatic backup
- ✅ Apply the MFA patch
- ✅ Verify installation
- ✅ Provide next steps

**Manual (If automated fails):**
1. Open: `node_modules/@microsoft/bc-replay/player/dist/commands.js`
2. Find the `aadAuthenticate` function (around line 189)
3. After the password submission block, add the MFA handling code from `commands.js.patch`
4. Save the file

### Test Your Setup
1. Copy `test-mfa-template.ps1` to your testing folder
2. Update the placeholders with your account details
3. Run the script
4. Enter your password when prompted
5. Enter your TOTP seed when prompted
6. Watch bc-replay automatically handle MFA!

## How It Works

```
┌─────────────────────────────────────────────────────────┐
│ BC Replay Authentication Flow with TOTP MFA             │
└─────────────────────────────────────────────────────────┘

1. Enter email → Navigate ✓
2. Enter password → Navigate ✓
3. [NEW] Wait 3 seconds for TOTP prompt
4. [NEW] If detected:
   - Generate TOTP code from BC_MFA_SEED
   - Fill input[name="otc"]
   - Click Verify button
   - Navigate ✓
5. Continue to BC application ✓
```

## Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `BC_USERNAME` | Yes | AAD email address |
| `BC_PASSWORD` | Yes | Account password |
| `BC_MFA_SEED` | Yes (MFA accounts) | Base32 TOTP seed from authenticator setup |

## Troubleshooting

### "MFA TOTP prompt detected" doesn't appear
- Ensure MFA is actually enabled on the account
- Check that `BC_MFA_SEED` environment variable is set
- Verify the TOTP seed is correct (base32 format)

### Generated TOTP code is rejected
- Check your TOTP seed is correct
- Ensure system time is synchronized (TOTP relies on accurate time)
- Try regenerating the seed in Entra ID

### Timeout during authentication
- Check network connectivity
- Verify BC environment URL is correct
- Ensure account isn't locked or disabled

## Testing Non-MFA Accounts
The patch is safe for non-MFA accounts:
- If `BC_MFA_SEED` is not set, MFA handling is skipped
- If TOTP prompt doesn't appear within 3 seconds, flow continues normally
- No impact on existing non-MFA workflows

## Maintenance Notes

⚠️ **Important:** This patch modifies files in `node_modules/@microsoft/bc-replay/`. 

These changes will be **lost** when you:
- Run `npm install`
- Run `npm update`
- Delete and reinstall node_modules

**Solutions:**
1. Keep this patch file and reapply after npm operations
2. Create an npm post-install script to auto-apply the patch
3. Fork bc-replay and maintain your own version
4. Submit a PR to bc-replay project for native MFA support

## Success Criteria

When working correctly, you'll see:
```
MFA TOTP prompt detected - generating code
Generated TOTP code: 123456
TOTP code entered
Clicked Verify and navigated
  1 passed (22.6s)
```

## Future Enhancements

Potential improvements:
- Support for other MFA methods (SMS, phone call)
- Automated patch application via npm scripts
- Configuration file for multiple TOTP seeds
- Integration with password managers