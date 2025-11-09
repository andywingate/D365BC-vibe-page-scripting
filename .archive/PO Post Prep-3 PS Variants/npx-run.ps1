# Prompt user for AAD password (secure input)
$securePassword = Read-Host -AsSecureString "Enter password for YOUR_TEST_ACCOUNT@yourdomain.onmicrosoft.com"

# Convert SecureString to plain text
$unsecurePassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword))

# Set credentials as environment variables
$env:BC_AAD_USERNAME = "YOUR_TEST_ACCOUNT@yourdomain.onmicrosoft.com"
$env:BC_AAD_PASSWORD = $unsecurePassword

# Run BC Replay with AAD authentication
# Note: Update the path to your bc-replay installation directory
Set-Location "C:\bc-replay"
npx replay ".\PO Post Prep-3 PS Variants\PS Variants\*.yml" `
    -StartAddress "https://businesscentral.dynamics.com/YOUR_TENANT.onmicrosoft.com/YOUR_ENVIRONMENT" `
    -Authentication AAD `
    -UserNameKey BC_AAD_USERNAME `
    -PasswordKey BC_AAD_PASSWORD

# Show the test report
npx playwright show-report