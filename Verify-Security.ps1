# Security Verification Script
# Run this before publishing to check for sensitive information

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "BC Page Scripting - Security Verification" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$issuesFound = 0

# Search patterns
$searches = @(
    @{
        Pattern = "venturedemos"
        Description = "Venture Demos tenant references"
    },
    @{
        Pattern = "test\.runner@"
        Description = "Test runner email addresses"
    },
    @{
        Pattern = "Sandbox-Andy"
        Description = "Personal sandbox references"
    },
    @{
        Pattern = "andy@wingateuk"
        Description = "Personal email in paths"
    },
    @{
        Pattern = "AndrewWingate"
        Description = "Personal name in paths"
    },
    @{
        Pattern = "C:\\Users\\[^Y][^O]" # Matches C:\Users\ but not C:\Users\YOUR...
        Description = "Absolute user paths (non-placeholder)"
    }
)

Write-Host "Searching for sensitive information..." -ForegroundColor Yellow
Write-Host ""

foreach ($search in $searches) {
    Write-Host "Checking for: $($search.Description)" -ForegroundColor White
    
    # Search all text files
    $results = Get-ChildItem -Path . -Include *.ps1,*.md,*.yml,*.txt -Recurse -ErrorAction SilentlyContinue | 
        Select-String -Pattern $search.Pattern -CaseSensitive:$false
    
    if ($results) {
        $issuesFound += $results.Count
        Write-Host "  ⚠️  FOUND $($results.Count) occurrence(s):" -ForegroundColor Red
        foreach ($result in $results) {
            Write-Host "      - $($result.Path):$($result.LineNumber)" -ForegroundColor Yellow
            Write-Host "        $($result.Line.Trim())" -ForegroundColor Gray
        }
        Write-Host ""
    } else {
        Write-Host "  ✅ Clean - No issues found" -ForegroundColor Green
        Write-Host ""
    }
}

Write-Host "========================================" -ForegroundColor Cyan

if ($issuesFound -eq 0) {
    Write-Host "✅ VERIFICATION PASSED" -ForegroundColor Green
    Write-Host "No sensitive information detected." -ForegroundColor Green
    Write-Host "Repository appears safe for public sharing." -ForegroundColor Green
} else {
    Write-Host "⚠️  VERIFICATION FAILED" -ForegroundColor Red
    Write-Host "Found $issuesFound potential issue(s)." -ForegroundColor Red
    Write-Host "Please review and sanitize before publishing." -ForegroundColor Red
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Additional Manual Checks:" -ForegroundColor Yellow
Write-Host "  [ ] Review SANITIZATION_SUMMARY.md" -ForegroundColor White
Write-Host "  [ ] Review SECURITY.md for completeness" -ForegroundColor White
Write-Host "  [ ] Test scripts work with relative paths" -ForegroundColor White
Write-Host "  [ ] Verify .gitignore includes sensitive patterns" -ForegroundColor White
Write-Host "  [ ] Check that README has security notice" -ForegroundColor White
Write-Host ""

# Pause for review
Write-Host "Press any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
