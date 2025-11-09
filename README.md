# Business Central Page Scripting Project

Automate Business Central page testing using YAML-based scripts executed via Playwright. Record once, generate variants, test multiple combinations.

## ✨ Key Features

- 🔄 **Variant generation** - Automatically create test combinations from data files
- 🔐 **MFA TOTP Support for bc-replay** - Use bc-replay on SaaS BC with accounts that require multi-factor authentication
- 🤖 **AI-assisted development** - A methodology for AI script generation

## 🚀 Quick Start

1. **Generation** - See [page-scripting/PAGE_SCRIPTING_QUICK_START.md](page-scripting/PAGE_SCRIPTING_QUICK_START.md) for recording scripts in BC
2. **Execution** - See [bc-replay/BC_REPLAY_QUICK_START.md](bc-replay/BC_REPLAY_QUICK_START.md) for running scripts in pipelines
3. **MFA Support** - If using MFA accounts, see [bc-replay/bc-replay-mfa-solution/](bc-replay/bc-replay-mfa-solution/)
4. **Examples** - Study `page-scripting/PO Post DirectionsEMEA/` for working patterns
5. **Full Guide** - Complete walkthrough in [GETTING_STARTED.md](GETTING_STARTED.md)

## Project Structure

**`page-scripting/`** - Script generation and variant automation
- PowerShell generators for creating test variants
- Project folders with BASE recordings and data files
- [PAGE_SCRIPTING_QUICK_START.md](page-scripting/PAGE_SCRIPTING_QUICK_START.md) - Recording guide

**`bc-replay/`** - Test execution including using accounts with MFA enforced
- Script runner for automated pipelines
- **MFA TOTP solution** for test runner accounts with MFA enabled
- 📖 [BC_REPLAY_QUICK_START.md](bc-replay/BC_REPLAY_QUICK_START.md) - Execution guide
- 📖 [bc-replay-mfa-solution/](bc-replay/bc-replay-mfa-solution/) - MFA setup

## 🔐 MFA TOTP Support for bc-replay

✅ **MFA solution available** for testing with BC accounts that require MFA:
- Automatic TOTP code generation during login
- Seamless integration with bc-replay

**See [bc-replay/bc-replay-mfa-solution/](bc-replay/bc-replay-mfa-solution/) for complete setup**

## 🔒 Security

**Before using:**
- Replace placeholder credentials in test scripts
- Update BC URLs with your tenant/environment
- Never commit actual passwords to the repository

📖 **See [SECURITY.md](SECURITY.md) for complete security guidelines and TOTP account setup**

## Documentation

| Guide | Purpose |
|-------|---------|
| **[GETTING_STARTED.md](GETTING_STARTED.md)** | Complete walkthrough and project overview |
| **[SECURITY.md](SECURITY.md)** | Security guidelines and TOTP account setup |
| **[page-scripting/](page-scripting/)** | Recording scripts and variant generation |
| **[bc-replay/](bc-replay/)** | Execution and MFA support |
| **[.github/copilot-instructions.md](.github/copilot-instructions.md)** | AI agent instructions and YAML patterns |

## 🔗 Resources

- [BC Page Scripting Docs](https://learn.microsoft.com/dynamics365/business-central/dev-itpro/developer/devenv-page-scripting) - Official Microsoft documentation
- [BC-Replay Package](https://www.npmjs.com/package/@microsoft/bc-replay) - npm package for pipeline execution  
- [Playwright](https://playwright.dev/) - Underlying test automation framework
- [Blog: AI-Driven Page Scripting](https://blog.wingate365.com/2025/10/south-coast-summit-2025-ai-driven-page.html) - Methodology deep dive

---

> ⚠️ **Disclaimer:** This project is created for demonstration and research purposes only. Use at your own risk.
