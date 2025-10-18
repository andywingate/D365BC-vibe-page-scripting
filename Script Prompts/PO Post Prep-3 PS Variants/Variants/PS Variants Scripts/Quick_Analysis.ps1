# Quick Test Results Analysis Script
# Run this in PowerShell to get key statistics

$failedLines = Get-Content "Results-failed"
$passedLines = Get-Content "Results-Passed"

# Count basic statistics
$totalPassed = ($passedLines | Where-Object { $_ -match "Variant-V" }).Count
$totalFailed = ($failedLines | Where-Object { $_ -match "Variant-V" }).Count

Write-Host "=== SUMMARY STATISTICS ===" -ForegroundColor Green
Write-Host "Total Passed: $totalPassed"
Write-Host "Total Failed: $totalFailed"
Write-Host "Total Tests: $($totalPassed + $totalFailed)"
Write-Host "Pass Rate: $([math]::Round(($totalPassed/($totalPassed + $totalFailed)) * 100, 1))%"
Write-Host ""

# Vendor-specific analysis
Write-Host "=== VENDOR FAILURE BREAKDOWN ===" -ForegroundColor Red
$vendors = @("10000", "20000", "30000", "40000", "50000", "64000")
foreach ($vendor in $vendors) {
    $failCount = ($failedLines | Where-Object { $_ -match "V$vendor" }).Count
    $passCount = ($passedLines | Where-Object { $_ -match "V$vendor" }).Count
    $total = $failCount + $passCount
    $failRate = if ($total -gt 0) { [math]::Round(($failCount / $total) * 100, 1) } else { 0 }
    Write-Host "Vendor $vendor`: $failCount failed / $total total ($failRate% failure rate)"
}

Write-Host ""
Write-Host "=== CRITICAL FINDINGS ===" -ForegroundColor Yellow

# Check for Vendor 50000 issue
$v50000Failures = ($failedLines | Where-Object { $_ -match "V50000" }).Count
if ($v50000Failures -gt 300) {
    Write-Host "🚨 CRITICAL: Vendor 50000 has $v50000Failures failures - Complete vendor failure!" -ForegroundColor Red
}

# Check timeout patterns
$timeoutLines = $failedLines | Where-Object { $_ -match "31\.\ds|32\.\ds|33\.\ds|34\.\ds" }
if ($timeoutLines.Count -gt 200) {
    Write-Host "⚠️  WARNING: $($timeoutLines.Count) tests show timeout pattern (31-34 seconds)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Analysis complete. See BC_Test_Results_Analysis.md for detailed report."