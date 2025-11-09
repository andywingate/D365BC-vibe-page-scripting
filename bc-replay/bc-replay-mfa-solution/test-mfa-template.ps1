# BC Replay MFA Test Script Template
# Copy this to your testing folder and fill in your account details

# Prompt user for AAD password (secure input)
$securePassword = Read-Host -AsSecureString "Enter password for YOUR_EMAIL@YOUR_TENANT.onmicrosoft.com"

# Convert SecureString to plain text
$unsecurePassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword))

# Prompt for TOTP seed (secure input)
$secureSeed = Read-Host -AsSecureString "Enter TOTP seed (base32 string from authenticator setup)"
$totpSeed = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureSeed))

# Set credentials as environment variables
$env:BC_USERNAME = "YOUR_EMAIL@YOUR_TENANT.onmicrosoft.com"
$env:BC_PASSWORD = $unsecurePassword
$env:BC_MFA_SEED = $totpSeed

# Run BC Replay with AAD authentication
Set-Location ..
npx replay ".\YOUR_SCRIPT.yml" `
    -StartAddress "https://businesscentral.dynamics.com/YOUR_TENANT/YOUR_ENVIRONMENT" `
    -Authentication AAD `
    -UserNameKey BC_USERNAME `
    -PasswordKey BC_PASSWORD

# Show the test report
npx playwright show-report
