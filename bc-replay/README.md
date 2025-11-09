# BC-Replay Test Runner

Execute Business Central page scripting YAML files in automated pipelines using Playwright.

## 🚀 Quick Start

### Standard BC-Replay (No MFA)

```powershell
# Install
npm install

# Run scripts
npx replay .\recordings\*.yml -StartAddress https://your-bc-url

# View results
npx playwright show-report
```

📖 **Full Guide:** [BC_REPLAY_QUICK_START.md](BC_REPLAY_QUICK_START.md)

---

## 🔐 MFA Support (NEW!)

Run automated tests with **MFA-enabled accounts** using TOTP authentication.

### Why MFA Support?

Many organizations require MFA on all accounts, including test accounts. This solution enables automation while maintaining security compliance by programmatically generating TOTP codes (like Microsoft Authenticator).

### Quick MFA Setup

```powershell
# 1. Install dependencies
npm install

# 2. Configure credentials (in testing folder - git-ignored)
cd testing
notepad my-credentials.ps1
# Add: BC_USERNAME, BC_PASSWORD, BC_MFA_SEED, BC_URL

# 3. Load and test
. .\my-credentials.ps1
cd ..
node test-mfa-auth.js
```

📖 **Complete MFA Guide:** [docs/MFA_SETUP_GUIDE.md](docs/MFA_SETUP_GUIDE.md)  
📖 **Quick Reference:** [docs/MFA-QUICK-REFERENCE.md](docs/MFA-QUICK-REFERENCE.md)

---

## 📁 Folder Structure

```
bc-replay/
├── docs/                           # Documentation
│   ├── MFA_SETUP_GUIDE.md         # Complete MFA setup guide
│   ├── MFA-QUICK-REFERENCE.md     # Quick reference card
│   ├── README-MFA.md              # Technical implementation
│   ├── SETUP-CHECKLIST.md         # Setup checklist
│   ├── SEED-CAPTURE-QUICK.md      # TOTP seed capture guide
│   ├── NEXT-STEPS.md              # Development roadmap
│   └── TEST-RESULTS.md            # Test validation results
├── testing/                        # Git-ignored workspace
│   ├── my-credentials.ps1         # Your real credentials (safe!)
│   ├── test-scripts/              # Test BC scripts
│   └── results/                   # Test results
├── mfa-auth.js                     # MFA authentication module
├── test-mfa-auth.js               # Standalone auth test
├── test-totp-only.js              # TOTP generation test
├── totp-seed-helper.js            # Seed validation utilities
├── npx-run-mfa.ps1                # MFA-enabled test runner
├── setup-local-env.ps1.template   # Credentials template
└── BC_REPLAY_QUICK_START.md       # Standard bc-replay guide
```

---

## 📚 Documentation

### For Users
- **[BC_REPLAY_QUICK_START.md](BC_REPLAY_QUICK_START.md)** - Standard bc-replay usage
- **[docs/MFA_SETUP_GUIDE.md](docs/MFA_SETUP_GUIDE.md)** - Complete MFA setup
- **[docs/MFA-QUICK-REFERENCE.md](docs/MFA-QUICK-REFERENCE.md)** - Quick commands

### For Developers
- **[docs/README-MFA.md](docs/README-MFA.md)** - Technical implementation
- **[docs/NEXT-STEPS.md](docs/NEXT-STEPS.md)** - Roadmap and next phases
- **[docs/TEST-RESULTS.md](docs/TEST-RESULTS.md)** - Test validation

### For Setup
- **[docs/SETUP-CHECKLIST.md](docs/SETUP-CHECKLIST.md)** - BC account setup
- **[docs/SEED-CAPTURE-QUICK.md](docs/SEED-CAPTURE-QUICK.md)** - TOTP seed capture

---

## 🎯 Common Tasks

### Run Tests Without MFA
```powershell
npx replay .\recordings\*.yml `
  -StartAddress https://businesscentral.dynamics.com/tenant/env `
  -Authentication Windows
```

### Run Tests With MFA
```powershell
# Load credentials
. .\testing\my-credentials.ps1

# Test authentication
.\npx-run-mfa.ps1 -TestAuthOnly

# Run scripts
.\npx-run-mfa.ps1 -ScriptsPath ".\recordings\*.yml"
```

### Validate TOTP Seed
```powershell
node totp-seed-helper.js validate "YOUR_SEED"
node totp-seed-helper.js generate "YOUR_SEED" 5
```

---

## 🔒 Security

**Git-Ignored Files:**
- `testing/` - Your local testing workspace
- `setup-local-env.ps1` - Credential files
- `*mfa*.png` - Authentication screenshots
- Test results and reports

**Safe to Commit:**
- All documentation in `docs/`
- Source code (`.js`, `.ps1`)
- Templates (`setup-local-env.ps1.template`)

---

## 🛠️ Utilities

### Authentication Testing
```powershell
# Test TOTP generation only
node test-totp-only.js

# Test full authentication flow
node test-mfa-auth.js

# Use PowerShell wrapper
.\npx-run-mfa.ps1 -TestAuthOnly
```

### Seed Validation
```powershell
# Validate seed format
node totp-seed-helper.js validate "SEED"

# Generate test codes
node totp-seed-helper.js generate "SEED" 5

# Parse QR code URL
node totp-seed-helper.js parse "otpauth://..."
```

---

## 📊 Status

| Feature | Status | Documentation |
|---------|--------|---------------|
| Standard bc-replay | ✅ Production | BC_REPLAY_QUICK_START.md |
| TOTP Code Generation | ✅ Complete | docs/README-MFA.md |
| MFA Authentication | ✅ Tested | docs/TEST-RESULTS.md |
| BC Account Setup Guide | ✅ Complete | docs/SETUP-CHECKLIST.md |
| bc-replay Integration | 🚧 In Progress | docs/NEXT-STEPS.md |
| Full Workflow Testing | 📋 Planned | docs/NEXT-STEPS.md |

---

## 🤝 Contributing

This is an open-source project. Contributions welcome!

**Current Focus:**
- Phase 2: bc-replay integration with authenticated contexts
- Phase 3: Full workflow testing and CI/CD examples

See [docs/NEXT-STEPS.md](docs/NEXT-STEPS.md) for detailed roadmap.

---

## 📄 License

MIT License - See repository root for details

---

## 🆘 Support

**Issues?**
1. Check [BC_REPLAY_QUICK_START.md](BC_REPLAY_QUICK_START.md) troubleshooting
2. Review [docs/MFA_SETUP_GUIDE.md](docs/MFA_SETUP_GUIDE.md) for MFA issues
3. See [docs/MFA-QUICK-REFERENCE.md](docs/MFA-QUICK-REFERENCE.md) for quick fixes
4. Open a GitHub issue

**Resources:**
- [BC-Replay npm Package](https://www.npmjs.com/package/@microsoft/bc-replay)
- [Playwright Documentation](https://playwright.dev/)
- [RFC 6238 - TOTP Standard](https://tools.ietf.org/html/rfc6238)

---

**Ready to automate your BC testing with MFA?** 🚀  
Start with [docs/MFA_SETUP_GUIDE.md](docs/MFA_SETUP_GUIDE.md)
