# AI Quick Reference: BC Test Analysis

## 🚀 Immediate Analysis Steps

### 1. Load Data
```powershell
$failedLines = Get-Content "Results-failed"
$passedLines = Get-Content "Results-Passed"
```

### 2. Basic Stats
```powershell
$totalPassed = ($passedLines | Where-Object { $_ -match "Variant-V" }).Count
$totalFailed = ($failedLines | Where-Object { $_ -match "Variant-V" }).Count
$passRate = [math]::Round(($totalPassed/($totalPassed + $totalFailed)) * 100, 1)
```

### 3. Vendor Analysis (CRITICAL)
```powershell
$vendors = @("10000", "20000", "30000", "40000", "50000", "64000")
foreach ($vendor in $vendors) {
    $failCount = ($failedLines | Where-Object { $_ -match "V$vendor" }).Count
    $passCount = ($passedLines | Where-Object { $_ -match "V$vendor" }).Count
    $total = $failCount + $passCount
    $failRate = if ($total -gt 0) { [math]::Round(($failCount / $total) * 100, 1) } else { 0 }
    Write-Host "Vendor $vendor`: $failCount failed / $total total ($failRate% failure rate)"
}
```

## 🚨 Alert Thresholds

| Condition | Priority | Action |
|-----------|----------|---------|
| 100% vendor failure | 🔴 CRITICAL | Emergency investigation |
| >50% vendor failure | 🟡 HIGH | Immediate attention |
| >15% vendor failure | 🟡 MEDIUM | Performance review |
| 31-34s timeout pattern | ⚠️ CONFIG | Adjust timeouts |

## 📊 Expected Test Matrix

- **Vendors:** 6 (10000, 20000, 30000, 40000, 50000, 64000)
- **Items:** 39 various codes
- **Locations:** 9 (BLUE, EAST, MAIN, etc.)
- **Total Tests:** 2,106 (6×39×9)
- **Expected per vendor:** 351 tests

## 🎯 File Patterns

```
Test Name: PO Post test BASE Variant-V[VENDOR]-I[ITEM]-L[LOCATION].yml
Duration: [number]s or [number]m
Pattern: dist/player.spec.js:61
```

## 📈 Healthy Baselines

- **Pass Rate:** >95%
- **Duration:** 30-45 seconds
- **Vendor consistency:** All vendors should perform similarly
- **No timeouts:** Minimal failures at 31-34 second mark

---
**Quick Start:** Run vendor analysis first - it reveals 80% of critical issues immediately.