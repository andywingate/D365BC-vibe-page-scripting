# BC Replay TOTP MFA Solution

✅ **Status:** Production Ready (November 9, 2025)

## What This Is

A working solution to enable bc-replay to work with Business Central accounts that have TOTP (Time-based One-Time Password) MFA enabled.

## Quick Start

1. **Install dependency:** `npm install otplib --save`
2. **Apply patch:** Follow `QUICK-SETUP.md`
3. **Create test script:** Copy `test-mfa-template.ps1`
4. **Run test:** Script will prompt for password and TOTP seed

## Files in This Folder

| File | Purpose |
|------|---------|
| **README.md** | Complete documentation and troubleshooting |
| **QUICK-SETUP.md** | Fast setup guide (< 5 minutes) |
| **SOLUTION.md** | Technical approach and design decisions |
| **commands.js.patch** | The actual code modification to apply |
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
Changes will be lost when running `npm install` - keep `commands.js.patch` and reapply as needed.

---

**Start here:** `QUICK-SETUP.md`
