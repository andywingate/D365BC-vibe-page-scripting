# BC-Replay Quick Start

A practical guide to executing Business Central page scripts in automated pipelines using the bc-replay test runner.

## What is BC-Replay?

BC-replay is an npm package that executes Business Central page scripting YAML files outside the BC web client. It's designed for **automated testing in CI/CD pipelines**, allowing you to run recorded user acceptance tests without manual interaction.

**Key concept:** BC-replay replays scripts created with BC's page scripting tool. Record once in BC, replay automatically in your pipeline.

## Prerequisites

**Required Software:**
- **Node.js** 16.14.0 or later ([download](https://nodejs.org))
- **PowerShell** 7+ ([install guide](https://learn.microsoft.com/powershell/scripting/install/installing-powershell-on-windows))

**Required Scripts:**
- YAML recording files from BC page scripting tool
- Scripts must use authentication that doesn't require MFA (username/password only)

## Quick Setup (5 Minutes)

### 1. Create Folder Structure
```powershell
# Create project folders
mkdir c:\bc-replay
mkdir c:\bc-replay\recordings
mkdir c:\bc-replay\results

cd c:\bc-replay
```

### 2. Install BC-Replay
```powershell
# Install package and Playwright dependencies
npm i @microsoft/bc-replay --save
```

**What this does:** Downloads bc-replay npm package and Playwright browser automation framework (~17MB).

### 3. Add Your Scripts
Copy your recorded YAML files to `c:\bc-replay\recordings\`:
```powershell
# Example: Copy from project folder
copy "c:\Git\MyProject\*.yml" "c:\bc-replay\recordings\"
```

## Running Scripts

### Basic Execution

**Single script:**
```powershell
cd c:\bc-replay
npx replay .\recordings\my-test.yml -StartAddress https://businesscentral.dynamics.com/tenant/environment
```

**All scripts in folder:**
```powershell
npx replay .\recordings\*.yml -StartAddress https://businesscentral.dynamics.com/tenant/environment
```

**With result output:**
```powershell
npx replay .\recordings\*.yml `
  -StartAddress https://businesscentral.dynamics.com/tenant/environment `
  -ResultDir c:\bc-replay\results
```

### Authentication Options

**Windows Authentication (default):**
```powershell
# No additional parameters needed - uses current Windows credentials
npx replay .\recordings\*.yml -StartAddress http://localhost:8080/bc
```

**Azure AD / User Password:**
```powershell
# Set credentials as environment variables
$env:BC_USERNAME = "testuser@yourtenant.onmicrosoft.com"
$env:BC_PASSWORD = "YourPassword123"

# Run with authentication parameters
npx replay .\recordings\*.yml `
  -StartAddress https://businesscentral.dynamics.com/tenant/environment `
  -Authentication UserPassword `
  -UserNameKey BC_USERNAME `
  -PasswordKey BC_PASSWORD `
  -ResultDir c:\bc-replay\results
```

⚠️ **Important:** MFA (multi-factor authentication) is **not supported**. Use a test account with username/password authentication only.

### Advanced Options

**Watch tests run (headed mode):**
```powershell
npx replay .\recordings\*.yml `
  -StartAddress https://businesscentral.dynamics.com/tenant/environment `
  -Headed
```

**Complete example with all options:**
```powershell
$env:BC_USERNAME = "testuser@yourtenant.onmicrosoft.com"
$env:BC_PASSWORD = "YourPassword123"

npx replay .\recordings\*.yml `
  -StartAddress https://businesscentral.dynamics.com/tenant/environment `
  -Authentication UserPassword `
  -UserNameKey BC_USERNAME `
  -PasswordKey BC_PASSWORD `
  -Headed `
  -ResultDir c:\bc-replay\results
```

## Viewing Results

After test execution, view the Playwright HTML report:

```powershell
npx playwright show-report c:\bc-replay\results\playwright-report
```

**What you'll see:**
- ✅ Passed/failed test summary
- 🕒 Execution time per script
- 📸 Screenshots of failures
- 📝 Detailed step-by-step logs
- 🎬 Video recordings (if enabled)

The report opens automatically in your default browser.

## Command Reference

### Full Syntax
```powershell
npx replay
  [-Tests] <String>
  -StartAddress <String>
  [-Authentication Windows|AAD|UserPassword]
  [-UserNameKey <String>]
  [-PasswordKey <String>]
  [-Headed]
  [-ResultDir <String>]
```

### Parameters

| Parameter | Required | Description | Example |
|-----------|----------|-------------|---------|
| `-Tests` | Yes | File glob pattern to select recordings | `.\recordings\*.yml` |
| `-StartAddress` | Yes | BC web client URL | `https://businesscentral.dynamics.com/...` |
| `-Authentication` | No | Auth method: `Windows`, `AAD`, `UserPassword` | `-Authentication UserPassword` |
| `-UserNameKey` | Conditional* | Environment variable name for username | `-UserNameKey BC_USERNAME` |
| `-PasswordKey` | Conditional* | Environment variable name for password | `-PasswordKey BC_PASSWORD` |
| `-Headed` | No | Show browser during test execution | `-Headed` |
| `-ResultDir` | No | Folder for test results and reports | `-ResultDir c:\bc-replay\results` |

*Required when `-Authentication` is `AAD` or `UserPassword`

## Common Scenarios

### Local On-Premises BC
```powershell
# Windows authentication to local BC instance
npx replay .\recordings\*.yml `
  -StartAddress http://localhost:8080/bc250 `
  -ResultDir c:\bc-replay\results
```

### BC SaaS Sandbox
```powershell
# UserPassword authentication to cloud sandbox
$env:BC_USERNAME = "admin@cronus.onmicrosoft.com"
$env:BC_PASSWORD = "P@ssw0rd"

npx replay .\recordings\*.yml `
  -StartAddress https://businesscentral.dynamics.com/12345678-1234-1234-1234-123456789012/Sandbox `
  -Authentication UserPassword `
  -UserNameKey BC_USERNAME `
  -PasswordKey BC_PASSWORD `
  -ResultDir c:\bc-replay\results
```

### Debug Failing Script
```powershell
# Run single script in headed mode to watch execution
npx replay .\recordings\failing-test.yml `
  -StartAddress https://businesscentral.dynamics.com/tenant/environment `
  -Authentication UserPassword `
  -UserNameKey BC_USERNAME `
  -PasswordKey BC_PASSWORD `
  -Headed
```

### CI/CD Pipeline Integration
```powershell
# Typical pipeline execution - headless with results
npx replay .\recordings\*.yml `
  -StartAddress $env:BC_URL `
  -Authentication UserPassword `
  -UserNameKey BC_USERNAME `
  -PasswordKey BC_PASSWORD `
  -ResultDir ./test-results

# Check exit code for pipeline success/failure
if ($LASTEXITCODE -ne 0) { 
    Write-Error "Tests failed"
    exit $LASTEXITCODE 
}
```

## Environment Variables Best Practices

**Local Development:**
```powershell
# Set for current session
$env:BC_USERNAME = "testuser@tenant.com"
$env:BC_PASSWORD = "Password123"

# Or create a local script (DON'T commit to Git!)
# setup-local-env.ps1
$env:BC_USERNAME = "testuser@tenant.com"
$env:BC_PASSWORD = "Password123"
$env:BC_URL = "https://businesscentral.dynamics.com/tenant/sandbox"
```

**CI/CD Pipeline:**
- Store credentials in pipeline secrets (GitHub Secrets, Azure Key Vault, etc.)
- Never hardcode credentials in scripts
- Use pipeline variables: `$env:BC_USERNAME`, `$env:BC_PASSWORD`

## Troubleshooting

| Issue | Cause | Solution |
|-------|-------|----------|
| "Module not found" | bc-replay not installed | Run `npm i @microsoft/bc-replay --save` |
| "Authentication failed" | Wrong credentials or MFA enabled | Verify credentials; disable MFA for test account |
| "Page not found" | Wrong BC URL | Verify `-StartAddress` URL is accessible |
| Scripts pass locally but fail in pipeline | Different data in environments | Ensure test data exists in both environments |
| "Chromium not found" | Playwright browsers not installed | Run `npx playwright install chromium` |

## Project Structure Example

```
c:\bc-replay\
├── node_modules\           # npm packages (created by npm install)
├── recordings\             # YAML script files
│   ├── create-customer.yml
│   ├── create-sales-order.yml
│   └── post-purchase-order.yml
├── results\               # Test execution results (created by npx replay)
│   ├── playwright-report\ # HTML report
│   ├── recordings\        # Copies of executed scripts
│   └── logs\              # Execution logs
└── package.json           # npm dependencies (created by npm install)
```

## Integration with This Repository

This repository provides **script generation** in `page-scripting/` folder and **test execution** in `bc-replay/` folder:

1. **Generate variants:** Use PowerShell scripts in `page-scripting/` to create test combinations
2. **Execute tests:** Use bc-replay in `bc-replay/` to run generated variants
3. **Review results:** Analyze Playwright reports to validate business processes

**Workflow:**
```
Record BASE script → Generate variants → Execute with bc-replay → Review reports
```

## Best Practices

✅ **DO:**
- Store credentials in environment variables, never in scripts
- Use `-ResultDir` to preserve test history
- Run scripts in consistent order for reproducible results
- Use glob patterns (`*.yml`) to run suites
- Add bc-replay folder to CI/CD pipeline

❌ **DON'T:**
- Commit credentials to version control
- Use MFA-enabled accounts for automated testing
- Run headed mode in CI/CD pipelines (causes hanging)
- Assume data exists without validation
- Mix Windows auth and UserPassword auth in same pipeline

## Next Steps

1. **Record your first script** - See `../page-scripting/PAGE_SCRIPTING_QUICK_START.md`
2. **Generate variants** - Use PowerShell scripts in `../page-scripting/`
3. **Set up CI/CD** - Integrate bc-replay into your build pipeline
4. **Monitor results** - Review Playwright reports after each run

## Resources

**Official Documentation:**
- [BC-Replay npm Package](https://www.npmjs.com/package/@microsoft/bc-replay)
- [Page Scripting Overview](https://learn.microsoft.com/dynamics365/business-central/dev-itpro/developer/devenv-page-scripting)
- [Playwright Documentation](https://playwright.dev/docs/intro)

**This Repository:**
- `../README.md` - Complete project documentation
- `../GETTING_STARTED.md` - Repository quick start
- `../page-scripting/PAGE_SCRIPTING_QUICK_START.md` - How to record BC scripts
- `../page-scripting/` - Script generation and variant automation
- `../.github/copilot-instructions.md` - YAML patterns and project conventions

---

**Quick Start Summary:**
```powershell
# 1. Install
mkdir c:\bc-replay; cd c:\bc-replay
npm i @microsoft/bc-replay --save

# 2. Add scripts
copy ".\my-scripts\*.yml" ".\recordings\"

# 3. Run tests
npx replay .\recordings\*.yml -StartAddress https://your-bc-url

# 4. View results
npx playwright show-report .\results\playwright-report
```
