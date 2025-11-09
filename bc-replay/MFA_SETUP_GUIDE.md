# MFA Setup Guide for BC-Replay Automation

This guide explains how to set up and use TOTP-based MFA authentication for automated BC page script testing with accounts that require multi-factor authentication.

## Why This Matters

Many organizations require MFA on all accounts, including service accounts. Standard bc-replay doesn't support MFA, which blocks automation. This solution programmatically generates TOTP codes (like Microsoft Authenticator) so scripts can run unattended while maintaining security compliance.

## Prerequisites

**Software:**
- Node.js 16.14.0+ with npm
- PowerShell 7+
- Playwright, otplib, @microsoft/bc-replay (auto-installed by scripts)

**Account Requirements:**
- BC test account with appropriate permissions
- MFA must be configured to use **authenticator app (TOTP)** only
- SMS and push notification MFA methods are **not supported**

## How TOTP Works

**TOTP (Time-based One-Time Password)** is the industry-standard algorithm (RFC 6238) used by authenticator apps:

1. During setup, you receive a **seed** (base32-encoded secret string)
2. Your authenticator app uses this seed + current time to generate 6-digit codes
3. Codes change every 30 seconds
4. Same seed = same codes at same time

**Key insight:** If we save the seed during setup, we can programmatically generate the same codes as the authenticator app.

## Setup Process

### Step 1: Configure MFA on Test Account

1. **Log in to Azure AD / Entra ID** as administrator
2. **Navigate to user settings** for your BC test account
3. **Enable MFA** and select "Authenticator app" method
4. **Important:** During the authenticator setup process, you'll see either:
   - A QR code (most common)
   - A text string (manual entry option)

### Step 2: Extract TOTP Seed

**Option A: From QR Code (Recommended)**

When Azure shows the QR code for authenticator setup:

1. Instead of scanning with your phone, **right-click the QR code** and "Inspect Element"
2. Find the QR code image source or the manual entry link
3. The manual entry option will show a string like: `otpauth://totp/Microsoft:username@tenant.com?secret=JBSWY3DPEHPK3PXP&issuer=Microsoft`
4. Extract the **secret parameter**: `JBSWY3DPEHPK3PXP`
5. This is your TOTP seed (base32-encoded)

**Option B: Use Manual Entry**

1. Click "Can't scan the QR code?" or similar link
2. Azure will display a code like: `JBSWY 3DPE HPK3 PXP` (spaces for readability)
3. Remove spaces: `JBSWY3DPEHPK3PXP`
4. This is your TOTP seed

**Option C: Use QR Code Reader**

```powershell
# Install QR code reading tool
npm install -g qrcode-reader-cli

# Save QR code image from Azure setup page
# Then read it:
qrcode-reader path/to/qr-code.png

# Extract secret parameter from output
```

### Step 3: Verify Seed

**Test that your seed generates correct codes:**

```powershell
# Set seed temporarily
$env:BC_MFA_SEED = "JBSWY3DPEHPK3PXP"  # Your actual seed

# Generate a code using Node.js
node -e "const {authenticator} = require('otplib'); console.log(authenticator.generate(process.env.BC_MFA_SEED));"

# Compare with your authenticator app
# Codes should match exactly (they change every 30 seconds)
```

**If codes don't match:**
- Verify seed is exactly correct (base32: A-Z, 2-7, no 0, 1, 8, 9)
- Check your system time is synchronized
- Ensure seed doesn't have spaces or special characters

### Step 4: Complete Authenticator Setup

**Important:** You must complete the full MFA setup in Azure:

1. Use the seed to add account to your **actual authenticator app** (phone)
2. Enter a code from your app to verify setup in Azure
3. Complete any backup options Azure requires

**Why:** This ensures:
- MFA is fully activated on the account
- You have backup access if seed is lost
- Account meets organizational security requirements

### Step 5: Store Seed Securely

**Local Development:**

```powershell
# Create a local setup script (add to .gitignore!)
# File: bc-replay/setup-local-env.ps1

$env:BC_USERNAME = "testrunner@yourtenant.onmicrosoft.com"
$env:BC_PASSWORD = "YourPassword123"
$env:BC_MFA_SEED = "JBSWY3DPEHPK3PXP"  # Your actual seed
$env:BC_URL = "https://businesscentral.dynamics.com/yourtenant/sandbox"

Write-Host "✓ Environment configured for local testing"
```

**Usage:**
```powershell
# Source the setup script
. .\bc-replay\setup-local-env.ps1

# Run tests
.\bc-replay\npx-run-mfa.ps1
```

**CI/CD Pipeline:**

Store as **encrypted secrets/variables**:
- GitHub: Repository Settings → Secrets and Variables → Actions
- Azure DevOps: Pipelines → Library → Variable Groups
- Jenkins: Credentials → Secret Text

**Never:**
- Commit seeds to Git
- Store in plain text files
- Share via email/chat
- Use production account seeds

## Testing Authentication

### Test 1: Verify TOTP Generation

```powershell
# Set environment variables
$env:BC_USERNAME = "testrunner@tenant.onmicrosoft.com"
$env:BC_PASSWORD = "YourPassword"
$env:BC_MFA_SEED = "YOUR_BASE32_SEED"
$env:BC_URL = "https://businesscentral.dynamics.com/tenant/sandbox"

# Test authentication only (no script execution)
cd bc-replay
.\npx-run-mfa.ps1 -TestAuthOnly
```

**Expected output:**
- Browser opens and navigates to BC
- Username/password entered automatically
- TOTP code generated and submitted automatically
- "Stay signed in?" prompt handled
- BC home page loads
- Screenshot saved as proof

**What to watch for:**
- Generated code matches your authenticator app
- MFA prompt is detected correctly
- Code is entered in correct field
- Authentication completes without errors

### Test 2: Run Single Script

```powershell
# After authentication test passes, try a simple script
.\npx-run-mfa.ps1 -ScriptsPath ".\test-scripts\simple-test.yml" -Headed
```

### Test 3: Full Test Suite

```powershell
# Run all scripts in directory
.\npx-run-mfa.ps1 -ScriptsPath ".\recordings\*.yml" -ResultDir ".\results"

# View results
npx playwright show-report .\results\playwright-report
```

## Troubleshooting

### Issue: Codes Don't Match Authenticator App

**Causes:**
- Incorrect seed (typo, wrong format)
- System time not synchronized
- Seed contains invalid characters

**Solutions:**
```powershell
# Verify seed format (base32: only A-Z, 2-7)
$seed = "YOUR_SEED"
if ($seed -match '^[A-Z2-7]+$') {
    Write-Host "✓ Seed format is valid"
} else {
    Write-Host "✗ Seed contains invalid characters"
}

# Synchronize system time
w32tm /resync /force

# Test code generation
node -e "const {authenticator} = require('otplib'); console.log('Generated:', authenticator.generate('$seed')); console.log('Check your app for comparison');"
```

### Issue: MFA Prompt Not Detected

**Causes:**
- Different MFA UI than expected
- Page loaded too slowly
- Selectors changed

**Solutions:**
```powershell
# Run in headed mode to watch process
.\npx-run-mfa.ps1 -TestAuthOnly -Headed

# Check console output for detection logs
# Look for: "[MFA] Detected MFA prompt via..."
```

### Issue: Authentication Succeeds But Scripts Fail

**Causes:**
- BC not fully loaded after authentication
- Session cookies not preserved
- bc-replay integration incomplete

**Solutions:**
- Verify authentication test fully completes
- Check BC home page loads completely
- Review bc-replay integration code

### Issue: "TOTP seed not found" Error

**Cause:** Environment variable not set

**Solution:**
```powershell
# Verify environment variables
Get-ChildItem env: | Where-Object {$_.Name -like "BC_*"}

# Set if missing
$env:BC_MFA_SEED = "YOUR_SEED"
```

## Security Best Practices

### ✅ DO:
- Use separate test accounts, never production accounts
- Store seeds in encrypted secret vaults
- Rotate credentials regularly (every 90 days)
- Use different seeds for different environments
- Keep authenticator app as backup access method
- Document seed storage location for team
- Audit who has access to test account seeds
- Use secure password input (Read-Host -AsSecureString)

### ❌ DON'T:
- Commit seeds to version control
- Share seeds via email/Slack/Teams
- Use same seed for multiple accounts
- Disable MFA to avoid this setup
- Store seeds in plain text files
- Use production accounts for testing
- Share authenticator app screenshots (contain QR codes)

## Integration Status

### ✅ Completed:
- TOTP code generation (`mfa-auth.js`)
- MFA prompt detection
- Azure AD authentication flow
- Standalone authentication testing
- PowerShell wrapper script framework

### 🚧 In Progress:
- bc-replay integration (awaiting architecture decision)
- Full workflow testing with BC scripts
- Error handling and retry logic
- Documentation refinement

### 📋 To Do:
- Research bc-replay browser context hooks
- Implement authenticated context passing
- Test with production-scale script suites
- Create CI/CD pipeline examples
- Add video walkthrough

## Architecture Options

We're evaluating three approaches for bc-replay integration:

**Option A: Playwright Test Wrapper**
- Authenticate first, then call bc-replay API directly
- Pro: No bc-replay modification needed
- Con: Requires understanding bc-replay internals

**Option B: Pre-authenticate + Context Sharing**
- Create authenticated browser context
- Pass to bc-replay for script execution
- Pro: Clean separation of concerns
- Con: bc-replay must support external contexts

**Option C: Fork bc-replay**
- Add native MFA support to bc-replay package
- Pro: Seamless integration
- Con: Maintenance overhead, must track upstream changes

**Current recommendation:** Option A (wrapper approach) for fastest implementation.

## Next Steps

1. **Test authentication independently:**
   ```powershell
   .\npx-run-mfa.ps1 -TestAuthOnly
   ```

2. **Verify codes match your authenticator app**

3. **Report results:**
   - ✅ If authentication succeeds: Ready for bc-replay integration
   - ❌ If authentication fails: Review troubleshooting section

4. **Stay tuned:** bc-replay integration is next phase of development

## Resources

**TOTP Standards:**
- [RFC 6238 - TOTP Algorithm](https://tools.ietf.org/html/rfc6238)
- [RFC 4648 - Base32 Encoding](https://tools.ietf.org/html/rfc4648)

**Libraries Used:**
- [otplib](https://github.com/yeojz/otplib) - TOTP generation
- [Playwright](https://playwright.dev/) - Browser automation

**Microsoft Documentation:**
- [Azure AD MFA Setup](https://learn.microsoft.com/entra/identity/authentication/howto-mfa-mfasettings)
- [BC-Replay Package](https://www.npmjs.com/package/@microsoft/bc-replay)

**This Repository:**
- `bc-replay/mfa-auth.js` - MFA authentication module
- `bc-replay/test-mfa-auth.js` - Standalone authentication test
- `bc-replay/npx-run-mfa.ps1` - PowerShell wrapper script

---

**Questions or issues?** Open a GitHub issue with:
- Error messages and console output
- Environment details (Node.js version, OS, BC version)
- Steps to reproduce
- Redact any seeds, passwords, or tenant information!
