# 🔑 TOTP Seed Capture - Quick Guide

**⚠️ CRITICAL: You only get ONE chance to capture the seed during MFA setup!**

---

## During Azure AD MFA Setup:

### When you see the QR code:

**Option 1: Click "Can't scan?" link**
```
→ Copy the code shown
→ Remove spaces: JBSW Y3DP EHPK 3PXP → JBSWY3DPEHPK3PXP
→ Write it down NOW!
```

**Option 2: Inspect QR code**
```
→ Right-click QR code → Inspect Element
→ Find: otpauth://totp/Microsoft:user@tenant.com?secret=JBSWY3DPEHPK3PXP
→ Extract: JBSWY3DPEHPK3PXP (the part after secret=)
→ Write it down NOW!
```

**YOUR SEED:** ________________________________

---

## Immediately Validate:

```powershell
cd c:\Git\D365BC-vibe-page-scripting\bc-replay

# Validate format
node totp-seed-helper.js validate "YOUR_SEED"

# Generate codes - MUST match your authenticator app!
node totp-seed-helper.js generate "YOUR_SEED" 3
```

**✅ Codes match app?** → Continue  
**❌ Codes don't match?** → Seed is wrong, reset MFA and try again

---

## Store Credentials:

```powershell
# Edit this file (it's in .gitignore)
notepad setup-local-env.ps1

# Add:
$env:BC_USERNAME = "testrunner@yourtenant.onmicrosoft.com"
$env:BC_PASSWORD = "YourPassword"
$env:BC_MFA_SEED = "JBSWY3DPEHPK3PXP"  # Your actual seed!
$env:BC_URL = "https://businesscentral.dynamics.com/tenant/env"
```

---

## Test Authentication:

```powershell
# Load environment
. .\setup-local-env.ps1

# Test (opens browser)
node test-mfa-auth.js

# Or use wrapper
.\npx-run-mfa.ps1 -TestAuthOnly
```

**✅ Success:** Screenshot shows BC home page  
**❌ Failed:** Check troubleshooting in SETUP-CHECKLIST.md

---

## 🚨 If You Miss the Seed:

**No problem! Just reset MFA:**
1. Go to Azure AD → User → Authentication methods
2. Delete authenticator app registration
3. User logs in again → MFA setup appears again
4. Capture seed this time! 😊

---

**Full details:** See `SETUP-CHECKLIST.md`
