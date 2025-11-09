# Quick Setup Guide - BC Replay TOTP MFA

Fast track to getting MFA working with bc-replay in 6 steps. For troubleshooting or technical details, see `README.md`.

## 1. Install Dependencies
```powershell
cd bc-replay
npm install @microsoft/bc-replay otplib --save
```

## 2. Apply MFA Patch

**Automated (Recommended):**
```powershell
cd bc-replay-mfa-solution
.\apply-mfa-patch.ps1
```

Done! The script automatically:
- ✅ Finds bc-replay installation
- ✅ Creates backup
- ✅ Applies MFA patch
- ✅ Verifies success

**Manual (If needed):**
See `commands.js.patch` for the code to add to `node_modules/@microsoft/bc-replay/player/dist/commands.js`

## 3. Get Your TOTP Seed

⚠️ **CRITICAL:** Capture your TOTP seed during account MFA setup - you can NEVER retrieve it later!

See the main [README.md](../../README.md#-setting-up-totp-for-test-accounts) for complete instructions with screenshots.

## 4. Create Test Script

Copy `test-mfa-template.ps1` and update:
- Your email: `YOUR_EMAIL@YOUR_TENANT.onmicrosoft.com`
- Your tenant: `YOUR_TENANT`
- Your environment: `YOUR_ENVIRONMENT`
- Your script: `YOUR_SCRIPT.yml`

## 5. Run Test
```powershell
.\your-test-script.ps1
```
Enter password and TOTP seed when prompted.

## 6. Verify Success
Look for:
```
MFA TOTP prompt detected - generating code
Generated TOTP code: 123456
TOTP code entered
Clicked Verify and navigated
  1 passed (XX.Xs)
```

✅ Done! Your bc-replay now supports MFA!

---

## 💡 Important Notes

- **Reapply after npm install:** Run `.\apply-mfa-patch.ps1` again if you reinstall packages
- **Seed security:** Store TOTP seeds securely, never commit to git
- **Backup available:** The patch script creates timestamped backups automatically
