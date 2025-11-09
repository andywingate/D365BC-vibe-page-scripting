# Quick Setup Guide - BC Replay TOTP MFA

## 1. Install Dependencies
```powershell
npm install otplib --save
```

## 2. Apply Patch
Open: `node_modules/@microsoft/bc-replay/player/dist/commands.js`

Find line ~194 in the `aadAuthenticate` function, right after:
```javascript
await Promise.all([page.waitForNavigation({ timeout: navigationTimeout }), page.click("input[type=submit]", { timeout: navigationTimeout })]);
```

Add this code block:
```javascript
// Check for MFA prompt (TOTP)
const mfaSeed = process.env["BC_MFA_SEED"];
if (mfaSeed) {
    try {
        // Wait briefly for MFA prompt to appear
        const totpInput = await page.waitForSelector('input[name="otc"]', { timeout: 3000 }).catch(() => null);
        if (totpInput) {
            console.log("MFA TOTP prompt detected - generating code");
            const authenticator = require('otplib').authenticator;
            authenticator.options = { step: 30, window: 1 };
            const totpCode = authenticator.generate(mfaSeed);
            console.log(`Generated TOTP code: ${totpCode}`);
            
            await page.fill('input[name="otc"]', totpCode);
            console.log("TOTP code entered");
            
            await Promise.all([page.waitForNavigation({ timeout: navigationTimeout }), page.click('input[type="submit"][value="Verify"]', { timeout: navigationTimeout })]);
            console.log("Clicked Verify and navigated");
        }
    } catch (error) {
        console.warn("MFA handling error:", error.message);
    }
}
```

## 3. Create Test Script
Copy `test-mfa-template.ps1` and update:
- Your email: `YOUR_EMAIL@YOUR_TENANT.onmicrosoft.com`
- Your tenant: `YOUR_TENANT`
- Your environment: `YOUR_ENVIRONMENT`
- Your script: `YOUR_SCRIPT.yml`

## 4. Get Your TOTP Seed
See `../../docs/SEED-CAPTURE-QUICK.md` for instructions on extracting your TOTP seed from authenticator setup.

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

✅ Done!
