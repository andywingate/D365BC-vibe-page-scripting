# BC Replay TOTP MFA Solution - README

## Overview
This solution enables bc-replay to work with Business Central accounts that have TOTP (Time-based One-Time Password) MFA enabled.

## What's Working ✅
- Automatic TOTP code generation during authentication
- Seamless integration with bc-replay's AAD authentication flow
- Clean test execution with MFA-enabled accounts
- No modification to bc-replay source needed (just node_modules patch)

## Solution Components

### 1. commands.js.patch
The core modification to bc-replay's authentication flow. This adds TOTP handling after password entry.

**What it does:**
- Detects TOTP prompt after password submission
- Reads `BC_MFA_SEED` environment variable
- Generates 6-digit TOTP code using otplib
- Automatically fills and submits the code
- Continues with normal authentication flow

### 2. test-mfa-template.ps1
PowerShell test script template for MFA-enabled accounts.

**Usage:**
1. Copy to your testing folder
2. Replace placeholders:
   - `YOUR_EMAIL@YOUR_TENANT.onmicrosoft.com`
   - `YOUR_TENANT`
   - `YOUR_ENVIRONMENT`
   - `YOUR_SCRIPT.yml`
3. Run the script - it will prompt for password and TOTP seed

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