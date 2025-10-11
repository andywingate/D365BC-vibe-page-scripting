# Prompt user for AAD password (secure input)
$securePassword = Read-Host -AsSecureString "Enter password for test.runner@venturedemos.onmicrosoft.com"

# Convert SecureString to plain text
$unsecurePassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword))

# Set credentials as environment variables
$env:BC_AAD_USERNAME = "test.runner@venturedemos.onmicrosoft.com"
$env:BC_AAD_PASSWORD = $unsecurePassword

# Run BC Replay with AAD authentication
Set-Location "C:\bc-replay"
npx replay "C:\Users\AndrewWingate\andy@wingateuk.com\OneDrive\Presentations & Colabs\2025-10 SCS 2025\BC\Script Prompts\Run Me\*.yml" `
    -StartAddress "https://businesscentral.dynamics.com/venturedemos.onmicrosoft.com/Sandbox-Andy" `
    -Authentication AAD `
    -UserNameKey BC_AAD_USERNAME `
    -PasswordKey BC_AAD_PASSWORD

# Show the test report
npx playwright show-report