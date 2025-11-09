# BC Replay TOTP MFA Solution

✅ **Status:** Production Ready (November 9, 2025)

## What This Is

A working solution to enable bc-replay to work with Business Central accounts that have TOTP (Time-based One-Time Password) MFA enabled.

## Quick Start

1. **Install dependencies:** `npm install @microsoft/bc-replay otplib --save`
2. **Apply patch:** Run `.\apply-mfa-patch.ps1` (automated!)
3. **Create test script:** Copy `test-mfa-template.ps1`
4. **Run test:** Script will prompt for password and TOTP seed

⚡ **Total time: < 5 minutes with automated patch script!**

## Files in This Folder

| File | Purpose |
|------|---------|
| **SETUP.md** | This file - overview and quick start |
| **QUICK-SETUP.md** | Fast setup guide with automated patch script |
| **README.md** | Complete documentation and troubleshooting |
| **SOLUTION.md** | Technical approach and design decisions |
| **apply-mfa-patch.ps1** | **Automated patch installer** - run this! |
| **commands.js.patch** | The actual code modification (applied by script) |
| **test-mfa-template.ps1** | PowerShell test script template |
| **REFERENCE-working-non-mfa-test.ps1** | Example of working non-MFA test |

## How It Works

Modifies bc-replay's `aadAuthenticate` function to:
1. Detect TOTP prompt after password entry
2. Generate 6-digit TOTP code from `BC_MFA_SEED` environment variable
3. Automatically fill and submit the code
4. Continue with normal authentication flow

## Test Output (Success)

```
MFA TOTP prompt detected - generating code
Generated TOTP code: 821161
TOTP code entered
Clicked Verify and navigated
  1 passed (22.6s)
```

## Requirements

- bc-replay installed (`@microsoft/bc-replay`)
- otplib npm package
- TOTP seed from your authenticator app setup
- BC account with TOTP MFA enabled

## Compatibility

✅ Works with MFA-enabled accounts  
✅ Safe for non-MFA accounts (graceful fallback)  
✅ No impact on existing bc-replay workflows

## Support

See `README.md` for:
- Detailed installation steps
- Troubleshooting guide
- Environment variable reference
- Maintenance notes

## Important Note

⚠️ This patch modifies `node_modules/@microsoft/bc-replay/player/dist/commands.js`  
Changes will be lost when running `npm install` - simply rerun `.\apply-mfa-patch.ps1` to reapply!

✅ The patch script creates automatic backups and is safe to run multiple times.

---

**Start here:** `QUICK-SETUP.md`
