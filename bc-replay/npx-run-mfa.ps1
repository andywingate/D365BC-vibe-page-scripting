# BC-Replay with MFA Support
# 
# This script executes BC page scripts using accounts with MFA enabled.
# It uses TOTP (Time-based One-Time Password) generation to programmatically
# handle MFA challenges during authentication.
#
# Prerequisites:
#   1. Node.js and npm installed
#   2. npm packages: playwright, otplib, @microsoft/bc-replay
#   3. TOTP seed from authenticator app setup
#
# Setup Instructions:
#   1. Set up authenticator app for BC test account
#   2. During setup, save the TOTP seed (base32 string or QR code data)
#   3. Set environment variables (see below)
#   4. Run this script
#
# Environment Variables Required:
#   BC_USERNAME      - Azure AD username (e.g., testuser@tenant.onmicrosoft.com)
#   BC_PASSWORD      - Account password
#   BC_MFA_SEED      - Base32-encoded TOTP seed from authenticator setup
#   BC_URL          - Business Central URL
#
# Security Notes:
#   - NEVER commit the MFA seed to version control
#   - Store seed in secure key vault for CI/CD pipelines
#   - Use separate test accounts, not production accounts
#   - Rotate credentials regularly

param(
    [Parameter(Mandatory=$false)]
    [string]$ScriptsPath = ".\recordings\*.yml",
    
    [Parameter(Mandatory=$false)]
    [string]$ResultDir = ".\results",
    
    [Parameter(Mandatory=$false)]
    [switch]$Headed = $false,
    
    [Parameter(Mandatory=$false)]
    [switch]$TestAuthOnly = $false
)

Write-Host ""
Write-Host "=" -NoNewline -ForegroundColor Cyan
Write-Host (" BC-Replay with MFA Support " * 2) -NoNewline -ForegroundColor White
Write-Host "=" -ForegroundColor Cyan
Write-Host ""

# Check if required environment variables are set
$requiredVars = @{
    "BC_USERNAME" = "Azure AD username"
    "BC_PASSWORD" = "Account password"
    "BC_MFA_SEED" = "TOTP seed (base32)"
    "BC_URL" = "Business Central URL"
}

$missingVars = @()
foreach ($var in $requiredVars.Keys) {
    if (-not (Test-Path "env:$var")) {
        $missingVars += $var
    }
}

if ($missingVars.Count -gt 0) {
    Write-Host "❌ Missing required environment variables:" -ForegroundColor Red
    foreach ($var in $missingVars) {
        Write-Host "   $var - $($requiredVars[$var])" -ForegroundColor Yellow
    }
    Write-Host ""
    Write-Host "Set them using:" -ForegroundColor Cyan
    Write-Host '   $env:BC_USERNAME = "testuser@tenant.onmicrosoft.com"' -ForegroundColor Gray
    Write-Host '   $env:BC_PASSWORD = "YourPassword"' -ForegroundColor Gray
    Write-Host '   $env:BC_MFA_SEED = "YOUR_BASE32_SEED"' -ForegroundColor Gray
    Write-Host '   $env:BC_URL = "https://businesscentral.dynamics.com/tenant/sandbox"' -ForegroundColor Gray
    Write-Host ""
    Write-Host "For secure password input:" -ForegroundColor Cyan
    Write-Host '   $securePassword = Read-Host -AsSecureString "Enter password"' -ForegroundColor Gray
    Write-Host '   $env:BC_PASSWORD = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword))' -ForegroundColor Gray
    Write-Host ""
    exit 1
}

# Display configuration (redacted)
Write-Host "Configuration:" -ForegroundColor Cyan
Write-Host "  Username: $env:BC_USERNAME"
Write-Host "  Password: $('*' * 12)"
Write-Host "  MFA Seed: $($env:BC_MFA_SEED.Substring(0, 4))$('*' * ($env:BC_MFA_SEED.Length - 4))"
Write-Host "  BC URL: $env:BC_URL"
Write-Host ""

# Check if Node.js packages are installed
Write-Host "Checking dependencies..." -ForegroundColor Cyan
$packageJsonPath = Join-Path $PSScriptRoot "package.json"

if (-not (Test-Path $packageJsonPath)) {
    Write-Host "⚠️  No package.json found. Installing required packages..." -ForegroundColor Yellow
    Write-Host ""
    
    # Initialize package.json if it doesn't exist
    npm init -y | Out-Null
    
    # Install required packages
    Write-Host "Installing packages: playwright, otplib, @microsoft/bc-replay" -ForegroundColor Gray
    npm install playwright otplib @microsoft/bc-replay --save
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Failed to install npm packages" -ForegroundColor Red
        exit 1
    }
    
    Write-Host "✓ Packages installed successfully" -ForegroundColor Green
    Write-Host ""
}

# Test authentication only (useful for initial setup)
if ($TestAuthOnly) {
    Write-Host "🧪 Testing MFA authentication only (no script execution)..." -ForegroundColor Cyan
    Write-Host ""
    
    node test-mfa-auth.js
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "✅ MFA authentication test passed!" -ForegroundColor Green
        Write-Host "   You can now run the full script execution." -ForegroundColor Gray
    } else {
        Write-Host ""
        Write-Host "❌ MFA authentication test failed!" -ForegroundColor Red
        Write-Host "   Fix authentication issues before running scripts." -ForegroundColor Gray
    }
    
    exit $LASTEXITCODE
}

# Create results directory if it doesn't exist
if (-not (Test-Path $ResultDir)) {
    New-Item -ItemType Directory -Path $ResultDir -Force | Out-Null
}

# Run bc-replay with MFA-authenticated context
Write-Host "🚀 Starting BC-Replay with MFA support..." -ForegroundColor Cyan
Write-Host ""
Write-Host "This will:" -ForegroundColor Gray
Write-Host "  1. Authenticate to BC using MFA (TOTP codes)" -ForegroundColor Gray
Write-Host "  2. Execute scripts: $ScriptsPath" -ForegroundColor Gray
Write-Host "  3. Save results to: $ResultDir" -ForegroundColor Gray
Write-Host ""

# TODO: This is where we'll integrate with bc-replay
# For now, this is a placeholder for the integration work

Write-Host "⚠️  INTEGRATION IN PROGRESS" -ForegroundColor Yellow
Write-Host ""
Write-Host "Current status: MFA authentication module is ready for testing" -ForegroundColor Gray
Write-Host ""
Write-Host "To test authentication:" -ForegroundColor Cyan
Write-Host "   .\npx-run-mfa.ps1 -TestAuthOnly" -ForegroundColor Gray
Write-Host ""
Write-Host "Next implementation steps:" -ForegroundColor Cyan
Write-Host "   1. Test MFA authentication independently" -ForegroundColor Gray
Write-Host "   2. Research bc-replay's browser context handling" -ForegroundColor Gray
Write-Host "   3. Create bridge between authenticated context and bc-replay" -ForegroundColor Gray
Write-Host "   4. Test full workflow with actual BC scripts" -ForegroundColor Gray
Write-Host ""

# Placeholder for bc-replay integration
# Once we confirm authentication works, we'll add:
#
# Option A: Use authenticated browser state
# node bc-replay-mfa-wrapper.js --scripts "$ScriptsPath" --result-dir "$ResultDir"
#
# Option B: Pre-authenticate and pass context
# npx replay "$ScriptsPath" -StartAddress "$env:BC_URL" -ResultDir "$ResultDir" -UseAuthContext
#
# Option C: Fork bc-replay and add MFA support natively

Write-Host "=" -NoNewline -ForegroundColor Cyan
Write-Host (" End of Script " * 3) -NoNewline -ForegroundColor White
Write-Host "=" -ForegroundColor Cyan
Write-Host ""
