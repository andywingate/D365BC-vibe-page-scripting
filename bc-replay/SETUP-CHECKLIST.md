# BC Test Account Setup - Checklist

## 🎯 Goal
Create a BC test account with MFA (TOTP/Authenticator) and capture the seed for automation.

## ⚠️ CRITICAL: Capture TOTP Seed During Setup!
**You only get ONE chance to see the seed during MFA setup!**  
Have this checklist open and ready before you start.

---

## 📋 Setup Checklist

### Phase 1: Create Test Account in Azure AD

- [ ] **Navigate to Azure AD / Entra ID admin portal**
  - URL: https://entra.microsoft.com or https://portal.azure.com

- [ ] **Create new user**
  - Name: `BC Test Runner` (or similar)
  - Username: `testrunner@yourtenant.onmicrosoft.com` (adjust as needed)
  - Initial password: (will be prompted to change on first login)
  - **Write down username:** ________________________________

- [ ] **Assign BC permissions**
  - Add user to BC license group
  - Assign necessary roles
  - Add PAGESCRIPTING permissions if required

- [ ] **Configure MFA requirement**
  - Enable MFA for this user
  - Set MFA method: **Authenticator app only** (not SMS/phone)

---

### Phase 2: First Login & MFA Setup (CRITICAL!)

- [ ] **Open incognito/private browser window**
  - This ensures clean session for first login

- [ ] **Navigate to BC URL**
  - URL: https://businesscentral.dynamics.com/yourtenant/yourenvironment
  - Or: https://portal.azure.com (will redirect to MFA setup)

- [ ] **Enter test account credentials**
  - Username: `testrunner@yourtenant.onmicrosoft.com`
  - Temporary password
  - Change password when prompted
  - **New password:** ________________________________

- [ ] **MFA Setup Screen Appears**
  - Should say "More information required" or "Set up authenticator app"

---

### Phase 3: Extract TOTP Seed (MOST IMPORTANT!)

**⚠️ THIS IS THE CRITICAL STEP! ⚠️**

**Option A: From QR Code (Recommended)**

- [ ] **QR Code is displayed for scanning**

- [ ] **Right-click on QR code → Inspect Element**
  
- [ ] **Find the "Can't scan the barcode?" or "Enter code manually" link**
  - Click it to reveal the manual entry option

- [ ] **Copy the text code shown**
  - Should look like: `JBSW Y3DP EHPK 3PXP` (with spaces)
  - Or find link like: `otpauth://totp/Microsoft:user@tenant.com?secret=JBSWY3DPEHPK3PXP`

- [ ] **Extract and clean the seed:**
  - Remove spaces: `JBSWY3DPEHPK3PXP`
  - **TOTP Seed:** ________________________________
  - Must be base32 format (A-Z, 2-7 only, no 0, 1, 8, 9)

**Option B: Parse QR Code URL**

- [ ] **Right-click QR code → Inspect Element**

- [ ] **Find the image source or nearby `otpauth://` URL**
  - Look for: `otpauth://totp/Microsoft:username?secret=SEED&issuer=Microsoft`

- [ ] **Copy full URL:** 
  ```
  ________________________________
  ```

- [ ] **Parse URL using helper:**
  ```powershell
  node totp-seed-helper.js parse "YOUR_OTPAUTH_URL"
  ```

- [ ] **Extract secret from output:**
  - **TOTP Seed:** ________________________________

---

### Phase 4: Complete MFA Setup

- [ ] **Add account to your REAL authenticator app**
  - Scan QR code with Microsoft Authenticator (or Google Authenticator)
  - **IMPORTANT:** This is your backup access method!

- [ ] **Verify setup**
  - Enter code from authenticator app
  - Azure should confirm: "Authentication method set up successfully"

- [ ] **Choose "Stay signed in" preference**
  - For testing, you can choose "No"

- [ ] **Complete any additional prompts**
  - Security questions (if required)
  - Backup email/phone (if required)

- [ ] **Verify BC access**
  - Should now be logged into Business Central
  - Browse to a page to confirm access works

---

### Phase 5: Validate TOTP Seed IMMEDIATELY

**⚠️ DO THIS RIGHT AWAY! ⚠️**

- [ ] **Open PowerShell in bc-replay folder**
  ```powershell
  cd c:\Git\D365BC-vibe-page-scripting\bc-replay
  ```

- [ ] **Validate seed format:**
  ```powershell
  node totp-seed-helper.js validate "YOUR_SEED_HERE"
  ```
  - Should show: ✅ Valid

- [ ] **Generate codes and compare with authenticator app:**
  ```powershell
  node totp-seed-helper.js generate "YOUR_SEED_HERE" 5 5
  ```
  - Codes should EXACTLY match your authenticator app
  - If they don't match, the seed is wrong!

- [ ] **Codes match?**
  - ✅ YES: Perfect! Continue to next phase
  - ❌ NO: STOP! Seed is incorrect, need to re-setup MFA

---

### Phase 6: Store Credentials Securely

- [ ] **Create local environment file:**
  ```powershell
  cd c:\Git\D365BC-vibe-page-scripting\bc-replay
  copy setup-local-env.ps1.template setup-local-env.ps1
  ```

- [ ] **Edit setup-local-env.ps1 with your credentials:**
  ```powershell
  notepad setup-local-env.ps1
  ```

- [ ] **Fill in values:**
  ```powershell
  $env:BC_USERNAME = "testrunner@yourtenant.onmicrosoft.com"
  $env:BC_PASSWORD = "YourActualPassword"
  $env:BC_MFA_SEED = "JBSWY3DPEHPK3PXP"  # Your actual seed
  $env:BC_URL = "https://businesscentral.dynamics.com/tenant/environment"
  ```

- [ ] **Verify file is NOT tracked by Git:**
  ```powershell
  git status
  # Should NOT show setup-local-env.ps1 (it's in .gitignore)
  ```

- [ ] **Store in password manager (optional but recommended)**
  - Add entry: "BC Test Account - MFA Seed"
  - Store username, password, seed, URL

---

### Phase 7: Test Authentication with Our Module

- [ ] **Load environment variables:**
  ```powershell
  cd c:\Git\D365BC-vibe-page-scripting\bc-replay
  . .\setup-local-env.ps1
  ```

- [ ] **Verify environment variables are set:**
  ```powershell
  Write-Host "Username: $env:BC_USERNAME"
  Write-Host "Password: $('*' * 12)"
  Write-Host "Seed: $($env:BC_MFA_SEED.Substring(0,4))****"
  Write-Host "URL: $env:BC_URL"
  ```

- [ ] **Run authentication test (opens browser):**
  ```powershell
  node test-mfa-auth.js
  ```
  OR
  ```powershell
  .\npx-run-mfa.ps1 -TestAuthOnly
  ```

- [ ] **Watch the browser automation:**
  - ✅ Opens browser
  - ✅ Navigates to BC URL
  - ✅ Enters username
  - ✅ Enters password
  - ✅ Detects MFA prompt
  - ✅ Generates TOTP code
  - ✅ Submits code
  - ✅ Handles "Stay signed in"
  - ✅ Loads BC home page
  - ✅ Takes screenshot: `mfa-auth-success.png`

- [ ] **Check results:**
  - Look for: "✅ Authentication Test PASSED!"
  - Screenshot should show BC home page
  - No errors in console

---

## 📊 Success Criteria

✅ **Setup Complete When:**
- Test account created in Azure AD
- TOTP seed captured and validated
- Codes from seed match authenticator app
- Environment file created (not in Git)
- Authentication test passes
- Screenshot shows BC home page

## 🐛 Troubleshooting

### Codes Don't Match Authenticator
**Problem:** Generated codes don't match your authenticator app

**Solutions:**
1. Verify seed exactly (no typos, no spaces)
2. Check seed is base32 format only (A-Z, 2-7)
3. Sync system time: `w32tm /resync /force`
4. Try re-extracting seed from QR code
5. Worst case: Reset MFA on account and setup again

### Can't Find TOTP Seed
**Problem:** QR code doesn't show manual entry option

**Solutions:**
1. Look for "Can't scan?" or "Enter code manually" link
2. Try right-click → Inspect Element on page
3. Look in browser developer tools for `otpauth://` URL
4. Take screenshot of QR code and use QR reader tool:
   ```powershell
   # Install QR reader (if needed)
   npm install -g qrcode-reader-cli
   
   # Read QR code from image
   qrcode-reader path/to/screenshot.png
   ```

### Authentication Test Fails
**Problem:** `node test-mfa-auth.js` fails

**Common Issues:**
1. Environment variables not set → Run `. .\setup-local-env.ps1`
2. Wrong BC URL → Verify URL in browser first
3. Account locked → Check Azure AD user status
4. MFA timeout → Codes valid for 30 seconds, timing matters
5. Page selectors changed → Run with headed mode to watch

**Debug Commands:**
```powershell
# Check environment
Get-ChildItem env: | Where-Object {$_.Name -like "BC_*"}

# Test TOTP generation
node -e "const {authenticator} = require('otplib'); console.log(authenticator.generate(process.env.BC_MFA_SEED));"

# Run in headed mode (watch browser)
node test-mfa-auth.js
# Edit test-mfa-auth.js: change headless: false
```

---

## 📝 Information to Capture

**Record these details for the team:**

| Item | Value | Notes |
|------|-------|-------|
| **Username** | ________________________________ | Azure AD account |
| **Password** | ________________________________ | Store in vault |
| **TOTP Seed** | ________________________________ | Base32 format |
| **BC URL** | ________________________________ | Full URL with tenant/env |
| **Tenant ID** | ________________________________ | From URL or Azure |
| **Environment** | ________________________________ | Sandbox/Production name |
| **Setup Date** | November 9, 2025 | For credential rotation |
| **Test Status** | ________________________________ | PASSED / FAILED / PENDING |

---

## 🎯 Next Steps After Success

Once authentication test passes:

1. **Update TEST-RESULTS.md** with actual test results
2. **Commit success documentation** to feature branch
3. **Move to Phase 2:** bc-replay integration research
4. **Test with simple BC page script**
5. **Share results with team**

---

## 💡 Tips

**Before You Start:**
- Have this checklist open
- Have PowerShell terminal ready
- Have authenticator app ready on phone
- Use incognito browser for clean session

**During Setup:**
- Take screenshots of each step
- Copy seed immediately when you see it
- Validate seed before completing setup
- Don't close browser until seed is validated

**After Setup:**
- Test authentication immediately
- Store credentials in password manager
- Document any issues encountered
- Update team on progress

---

**Good luck with the setup!** 🚀

**If you run into any issues, refer to `MFA_SETUP_GUIDE.md` for detailed troubleshooting.**
