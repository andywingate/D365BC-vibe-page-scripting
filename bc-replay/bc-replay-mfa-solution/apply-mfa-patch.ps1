<#
.SYNOPSIS
    Automatically applies the MFA TOTP patch to bc-replay

.DESCRIPTION
    This script patches node_modules/@microsoft/bc-replay/player/dist/commands.js
    to add TOTP MFA support. Run this after npm install.

.EXAMPLE
    .\apply-mfa-patch.ps1
    
.EXAMPLE
    .\apply-mfa-patch.ps1 -Verbose
#>

[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

Write-Host "`n🔐 BC-Replay MFA TOTP Patch Installer" -ForegroundColor Cyan
Write-Host "=" * 50 -ForegroundColor Cyan

# Check if we're in the right directory
$currentDir = Get-Location
Write-Verbose "Current directory: $currentDir"

# Find the bc-replay installation
$targetFile = Join-Path $currentDir ".." "node_modules" "@microsoft" "bc-replay" "player" "dist" "commands.js"

if (-not (Test-Path $targetFile)) {
    Write-Host "`n❌ ERROR: bc-replay not found!" -ForegroundColor Red
    Write-Host "`nExpected location: $targetFile" -ForegroundColor Yellow
    Write-Host "`nPlease ensure:" -ForegroundColor Yellow
    Write-Host "  1. You're in the bc-replay/bc-replay-mfa-solution/ folder" -ForegroundColor Yellow
    Write-Host "  2. You've run 'npm install @microsoft/bc-replay' in the parent folder" -ForegroundColor Yellow
    exit 1
}

Write-Host "`n✓ Found bc-replay installation" -ForegroundColor Green
Write-Verbose "Target file: $targetFile"

# Read the current file
Write-Host "`n📖 Reading commands.js..." -ForegroundColor Yellow
$content = Get-Content $targetFile -Raw

# Check if already patched
if ($content -match "MFA TOTP prompt detected") {
    Write-Host "`n✓ Patch already applied!" -ForegroundColor Green
    Write-Host "`nThe MFA TOTP code is already present in commands.js" -ForegroundColor Cyan
    Write-Host "No changes needed." -ForegroundColor Cyan
    exit 0
}

# Create backup
$backupFile = "$targetFile.backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
Write-Host "`n💾 Creating backup..." -ForegroundColor Yellow
Copy-Item $targetFile $backupFile -Force
Write-Host "   Backup saved: $backupFile" -ForegroundColor Gray

# Read the patch
$patchFile = Join-Path $PSScriptRoot "commands.js.patch"
if (-not (Test-Path $patchFile)) {
    Write-Host "`n❌ ERROR: Patch file not found!" -ForegroundColor Red
    Write-Host "   Expected: $patchFile" -ForegroundColor Yellow
    exit 1
}

Write-Host "`n📝 Reading patch file..." -ForegroundColor Yellow
$patchContent = Get-Content $patchFile -Raw

# Find the insertion point (after password navigation)
$insertionPattern = '(?s)(await\s+this\.page\.waitForNavigation.*?;)\s*\}'

if ($content -notmatch $insertionPattern) {
    Write-Host "`n❌ ERROR: Could not find insertion point in commands.js" -ForegroundColor Red
    Write-Host "`nThe file structure may have changed in a newer version of bc-replay." -ForegroundColor Yellow
    Write-Host "Please check commands.js.patch and apply manually." -ForegroundColor Yellow
    exit 1
}

# Apply the patch
Write-Host "`n🔧 Applying MFA TOTP patch..." -ForegroundColor Yellow

$patchedContent = $content -replace $insertionPattern, "`$1`n`n$patchContent`n        }"

# Verify the patch was applied
if ($patchedContent -notmatch "MFA TOTP prompt detected") {
    Write-Host "`n❌ ERROR: Patch application failed!" -ForegroundColor Red
    Write-Host "   The content was modified but verification failed." -ForegroundColor Yellow
    exit 1
}

# Write the patched file
Write-Host "`n💾 Writing patched file..." -ForegroundColor Yellow
Set-Content $targetFile $patchedContent -NoNewline

# Verify it worked
$verifyContent = Get-Content $targetFile -Raw
if ($verifyContent -match "MFA TOTP prompt detected") {
    Write-Host "`n✅ SUCCESS! MFA TOTP patch applied!" -ForegroundColor Green
    Write-Host "`n📋 Next steps:" -ForegroundColor Cyan
    Write-Host "   1. Install otplib: npm install otplib --save" -ForegroundColor White
    Write-Host "   2. Set up your credentials (see QUICK-SETUP.md)" -ForegroundColor White
    Write-Host "   3. Test with: node ../test-mfa-auth.js" -ForegroundColor White
    Write-Host "`n💡 Note: Rerun this script after 'npm install' to reapply the patch" -ForegroundColor Yellow
} else {
    Write-Host "`n❌ ERROR: Verification failed!" -ForegroundColor Red
    Write-Host "   Restoring from backup..." -ForegroundColor Yellow
    Copy-Item $backupFile $targetFile -Force
    Write-Host "   Backup restored." -ForegroundColor Green
    exit 1
}

Write-Host "`n" -NoNewline
