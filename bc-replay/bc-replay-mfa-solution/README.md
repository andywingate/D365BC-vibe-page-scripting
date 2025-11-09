# BC Replay TOTP MFA Solution - README

## Overview
This solution enables bc-replay to work with Business Central accounts that have TOTP (Time-based One-Time Password) MFA enabled. Automatic TOTP code generation integrates seamlessly with bc-replay's AAD authentication flow.

## 📁 Files in This Solution

| File | Purpose |
|------|---------|
| **README.md** | This file - complete documentation and setup guide |
| **SOLUTION.md** | Technical approach, design decisions, and testing history |
| **apply-mfa-patch.ps1** | **Automated patch installer** - recommended installation method |
| **commands.js.patch** | The actual code modification (applied automatically by script) |
| **test-mfa-template.ps1** | PowerShell test script template for your projects |
| **REFERENCE-working-non-mfa-test.ps1** | Example of working non-MFA test for comparison |

## 🚀 Quick Start (5 Minutes)

Get MFA working in 6 easy steps:

### 1. Install Dependencies
```powershell
cd bc-replay
npm install @microsoft/bc-replay otplib --save
```

### 2. Apply MFA Patch (Automated)
```powershell
cd bc-replay-mfa-solution
.\apply-mfa-patch.ps1
```

The script automatically:
- ✅ Finds bc-replay installation
- ✅ Creates backup
- ✅ Applies MFA patch
- ✅ Verifies success

### 3. Get Your TOTP Seed

⚠️ **CRITICAL:** Capture your TOTP seed during account MFA setup - you can NEVER retrieve it later!

See the main [project README](../../README.md#-setting-up-totp-for-test-accounts) for complete TOTP account setup instructions with screenshots.

### 4. Create Test Script

Copy `test-mfa-template.ps1` and update:
- Your email: `YOUR_EMAIL@YOUR_TENANT.onmicrosoft.com`
- Your tenant: `YOUR_TENANT`
- Your environment: `YOUR_ENVIRONMENT`
- Your script: `YOUR_SCRIPT.yml`

### 5. Run Test
```powershell
.\your-test-script.ps1
```
Enter password and TOTP seed when prompted.

### 6. Verify Success
Look for:
```
MFA TOTP prompt detected - generating code
Generated TOTP code: 123456
TOTP code entered
Clicked Verify and navigated
  1 passed (XX.Xs)
```

✅ Done! Your bc-replay now supports MFA!

**Manual patching (if automated script fails):**
1. Open: `node_modules/@microsoft/bc-replay/player/dist/commands.js`
2. Find the `aadAuthenticate` function (around line 189)
3. Add the MFA handling code from `commands.js.patch` after password submission
4. Save the file

---

**Need technical details?** See `SOLUTION.md` for design decisions and testing history.  
**Need troubleshooting?** Continue reading below.

## What's Working ✅
- Automatic TOTP code generation during authentication
- Seamless integration with bc-replay's AAD authentication flow
- Clean test execution with MFA-enabled accounts
- No modification to bc-replay source needed (just node_modules patch)
- Safe fallback for non-MFA accounts

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