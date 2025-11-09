# BC-Replay Test Runner

Execute Business Central page scripting YAML files in automated pipelines using Playwright.

## 🚀 Standard BC-Replay (No MFA)

### Quick Start

```powershell
# Install bc-replay
npm install @microsoft/bc-replay --save

# Run your scripts
npx replay .\recordings\*.yml -StartAddress https://your-bc-url

# View results
npx playwright show-report
```

### Complete Guide

📖 **[BC_REPLAY_QUICK_START.md](BC_REPLAY_QUICK_START.md)** - Full setup, authentication options, troubleshooting

---

## 🔐 MFA TOTP Support (NEW!)

**Problem:** Your organization requires MFA on all accounts, blocking automation.

**Solution:** Use TOTP (authenticator app) MFA with automated code generation.

### 👉 Complete MFA Solution

**[bc-replay-mfa-solution/](bc-replay-mfa-solution/)** - Everything you need to run bc-replay with MFA-enabled accounts:

- **README.md** - Complete documentation and setup guide
- **SOLUTION.md** - Technical details and approach

### What You'll Need

1. BC account with TOTP MFA enabled (authenticator app)
2. The TOTP seed from account setup (one-time capture - see solution docs)
3. Standard bc-replay installation
4. 5 minutes to apply the patch

### What It Does

✅ Automatically generates TOTP codes during authentication  
✅ Works with Microsoft Entra ID MFA  
✅ Safe fallback for non-MFA accounts  
✅ No changes to your existing scripts  

---

## 📚 Documentation

| Guide | Purpose |
|-------|---------|
| **[BC_REPLAY_QUICK_START.md](BC_REPLAY_QUICK_START.md)** | Standard bc-replay usage (no MFA) |
| **[bc-replay-mfa-solution/](bc-replay-mfa-solution/)** | Complete MFA setup and usage |

---

## 🆘 Need Help?

**Standard bc-replay:** See [BC_REPLAY_QUICK_START.md](BC_REPLAY_QUICK_START.md) troubleshooting section  
**MFA setup:** See [bc-replay-mfa-solution/README.md](bc-replay-mfa-solution/README.md) troubleshooting section

**Resources:**
- [BC-Replay npm Package](https://www.npmjs.com/package/@microsoft/bc-replay)
- [Playwright Documentation](https://playwright.dev/)
- [BC Page Scripting Overview](https://learn.microsoft.com/dynamics365/business-central/dev-itpro/developer/devenv-page-scripting)

---

## � What's in This Folder

```
bc-replay/
├── bc-replay-mfa-solution/      # Complete MFA solution (start here for MFA)
├── BC_REPLAY_QUICK_START.md     # Standard bc-replay guide
├── README.md                    # This file
└── setup-local-env.ps1.template # Credential template (for MFA setup)
```

**Development/utility files:**
- `mfa-auth.js`, `test-mfa-auth.js`, `npx-run-mfa.ps1` - MFA development utilities
- `totp-seed-helper.js` - TOTP seed validation tool
- `*.yml` - Example scripts

---

**Ready to automate BC testing with MFA?** Start here: **[bc-replay-mfa-solution/README.md](bc-replay-mfa-solution/README.md)** 🚀
