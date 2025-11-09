# Prompt user for AAD password (secure input)
$securePassword = Read-Host -AsSecureString "Enter password for test.runner@venturedemos.onmicrosoft.com"

# Convert SecureString to plain text
$unsecurePassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword))

# Set credentials as environment variables
$env:BC_USERNAME = "test.runner@venturedemos.onmicrosoft.com"
$env:BC_PASSWORD = $unsecurePassword

# Run BC Replay with AAD authentication
Set-Location ..
npx replay ".\bc-page-script-simple-example.yml" `
    -StartAddress "https://businesscentral.dynamics.com/venturedemos.onmicrosoft.com/Sandbox-Andy" `
    -Authentication AAD `
    -UserNameKey BC_USERNAME `
    -PasswordKey BC_PASSWORD

# Show the test report
npx playwright show-report
