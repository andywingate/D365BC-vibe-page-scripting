# MFA Quick Reference Card

## 🎯 Quick Commands

### Setup (First Time)
```powershell
cd bc-replay
npm install
copy setup-local-env.ps1.template setup-local-env.ps1
# Edit setup-local-env.ps1 with your credentials
. .\setup-local-env.ps1
```

### Test Authentication
```powershell
.\npx-run-mfa.ps1 -TestAuthOnly
```

### Validate TOTP Seed
```powershell
node totp-seed-helper.js validate "YOUR_SEED"
```

### Generate Test Codes
```powershell
node totp-seed-helper.js generate "YOUR_SEED" 5
```

### Run Scripts (When Ready)
```powershell
.\npx-run-mfa.ps1 -ScriptsPath ".\recordings\*.yml"
```

## 📋 Required Environment Variables

| Variable | Example | Where to Get |
|----------|---------|--------------|
| `BC_USERNAME` | `test@tenant.com` | Azure AD account |
| `BC_PASSWORD` | `P@ssw0rd123` | Azure AD password |
| `BC_MFA_SEED` | `JBSWY3DPEHPK3PXP` | Authenticator setup (see guide) |
| `BC_URL` | `https://businesscentral.dynamics.com/...` | BC web client URL |

## 🔑 Getting Your TOTP Seed

### Method 1: From QR Code
1. Go to Azure AD MFA setup
2. Right-click QR code → Inspect Element
3. Find link: "Can't scan? Enter this code manually"
4. Extract secret: `otpauth://...?secret=YOUR_SEED_HERE`

### Method 2: Manual Entry
1. Click "Can't scan the QR code?"
2. Copy displayed code (remove spaces)
3. Example: `JBSW Y3DP EHPK 3PXP` → `JBSWY3DPEHPK3PXP`

### Method 3: Parse QR URL
```powershell
node totp-seed-helper.js parse "otpauth://totp/Microsoft:user@tenant.com?secret=ABC123"
```

## ✅ Pre-Flight Checklist

Before running tests:
- [ ] Environment variables set (`$env:BC_USERNAME`, etc.)
- [ ] TOTP seed validated (codes match authenticator app)
- [ ] npm packages installed (`npm install`)
- [ ] BC URL accessible in browser
- [ ] Test account has BC permissions
- [ ] MFA configured for authenticator app (not SMS/push)

## 🐛 Troubleshooting Quick Fixes

| Symptom | Quick Fix |
|---------|-----------|
| "Module not found" | `npm install` |
| Codes don't match | Verify seed exactly, sync system time: `w32tm /resync /force` |
| MFA prompt not detected | Run with headed mode: `-TestAuthOnly` |
| Environment variable not set | Re-run: `. .\setup-local-env.ps1` |
| Seed format invalid | Run: `node totp-seed-helper.js validate "YOUR_SEED"` |

## 📚 Documentation Files

| File | Purpose |
|------|---------|
| `MFA_SETUP_GUIDE.md` | Complete setup instructions |
| `README-MFA.md` | Implementation overview |
| `BC_REPLAY_QUICK_START.md` | General bc-replay guide (has MFA section) |

## 🔒 Security Reminders

### ✅ DO:
- Store seeds in environment variables
- Use `setup-local-env.ps1` (it's in .gitignore)
- Keep authenticator app as backup
- Rotate credentials every 90 days

### ❌ DON'T:
- Commit seeds to Git
- Share seeds via email/chat
- Use production accounts
- Screenshot QR codes

## 💡 Common Workflows

### Daily Development
```powershell
# 1. Start session
. .\setup-local-env.ps1

# 2. Test auth (if needed)
.\npx-run-mfa.ps1 -TestAuthOnly

# 3. Run your scripts
.\npx-run-mfa.ps1 -ScriptsPath ".\my-test.yml" -Headed
```

### CI/CD Pipeline
```yaml
# GitHub Actions example
- name: Set up credentials
  env:
    BC_USERNAME: ${{ secrets.BC_USERNAME }}
    BC_PASSWORD: ${{ secrets.BC_PASSWORD }}
    BC_MFA_SEED: ${{ secrets.BC_MFA_SEED }}
    BC_URL: ${{ secrets.BC_URL }}
  run: |
    cd bc-replay
    npm install
    .\npx-run-mfa.ps1 -ScriptsPath ".\recordings\*.yml"
```

### Validate New Seed
```powershell
# 1. Validate format
node totp-seed-helper.js validate "NEW_SEED"

# 2. Generate codes
node totp-seed-helper.js generate "NEW_SEED" 3 10

# 3. Compare with authenticator app
# Codes should match exactly!
```

## 🎓 Learning Resources

**Official Docs:**
- TOTP Standard: https://tools.ietf.org/html/rfc6238
- Playwright: https://playwright.dev/
- BC-Replay: https://www.npmjs.com/package/@microsoft/bc-replay

**Project Docs:**
- Full setup guide: `MFA_SETUP_GUIDE.md`
- Implementation details: `README-MFA.md`
- bc-replay basics: `BC_REPLAY_QUICK_START.md`

## 📞 Getting Help

1. **Check troubleshooting section** in `MFA_SETUP_GUIDE.md`
2. **Run diagnostics:**
   ```powershell
   # Verify environment
   Get-ChildItem env: | Where-Object {$_.Name -like "BC_*"}
   
   # Test TOTP generation
   node -e "const {authenticator} = require('otplib'); console.log(authenticator.generate(process.env.BC_MFA_SEED));"
   ```
3. **Open GitHub issue** with:
   - Error messages (redact credentials!)
   - Environment details
   - Steps to reproduce

---

**Print this card and keep it handy!**

Current Status: ✅ Authentication Module Complete | 🚧 bc-replay Integration In Progress
