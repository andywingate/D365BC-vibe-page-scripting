# Generate BC Script Variants - Enhanced Multi-Variable Version
# This script creates test script variations by substituting vendor, item, and location values

param(
    [Parameter(Mandatory=$true)]
    [string]$BaseScriptPath,
    
    [Parameter(Mandatory=$true)]
    [string]$ProjectFolder,
    
    [Parameter(Mandatory=$false)]
    [string]$OutputFolder = "PS Variants",
    
    [Parameter(Mandatory=$false)]
    [string]$VendorFilter = $null,
    
    [Parameter(Mandatory=$false)]
    [string]$ItemFilter = $null,
    
    [Parameter(Mandatory=$false)]
    [string]$LocationFilter = $null,
    
    [Parameter(Mandatory=$false)]
    [int]$BatchSize = 10,
    
    [Parameter(Mandatory=$false)]
    [int]$MaxCombinations = 2500,
    
    [Parameter(Mandatory=$false)]
    [switch]$WhatIf
)

# Function to read data file and return array of values
function Get-DataValues {
    param(
        [string]$FilePath,
        [string]$Filter = $null
    )
    
    if (Test-Path $FilePath) {
        $values = Get-Content $FilePath | Where-Object { $_.Trim() -ne "" }
        
        if ($Filter) {
            $values = $values | Where-Object { $_ -like "*$Filter*" }
        }
        
        return $values
    } else {
        Write-Warning "Data file not found: $FilePath"
        return @()
    }
}

# Function to generate unique telemetry ID
function New-TelemetryId {
    return [System.Guid]::NewGuid().ToString()
}

# Function to substitute values in script content
function Update-ScriptContent {
    param(
        [string]$Content,
        [string]$Vendor,
        [string]$Item,
        [string]$Location,
        [string]$NewName,
        [string]$NewDescription,
        [string]$NewTelemetryId
    )
    
    # Update header information - use multiline mode
    $Content = $Content -replace '(?m)^name:.*$', "name: $NewName"
    $Content = $Content -replace '(?m)^description:.*$', "description: $NewDescription"
    $Content = $Content -replace '(?m)^telemetryId:.*$', "telemetryId: $NewTelemetryId"
    
    # Replace vendor values - target the exact patterns from the YAML
    # Pattern 1: value: "1000" (quoted vendor number with isFilterAsYouType)
    $Content = $Content -replace 'value: "1000"', "value: `"$Vendor`""
    # Pattern 2: <value>1000</value> in descriptions
    $Content = $Content -replace '<value>1000</value>', "<value>$Vendor</value>"
    
    # Replace location values - target the exact patterns
    # Pattern 1: value: MAIN (uppercase location)
    $Content = $Content -replace 'value: MAIN', "value: $Location"
    # Pattern 2: <value>MAIN</value> in descriptions  
    $Content = $Content -replace '<value>MAIN</value>', "<value>$Location</value>"
    
    # Replace item values - handle the multi-step pattern in new base script
    # Pattern 1: value: 1964-S (with isFilterAsYouType)
    $Content = $Content -replace 'value: 1964-S', "value: $Item"
    # Pattern 2: <value>1964-S</value> in descriptions
    $Content = $Content -replace '<value>1964-S</value>', "<value>$Item</value>"
    
    return $Content
}

# Function to estimate script generation time
function Get-EstimatedTime {
    param([int]$Count)
    
    $secondsPerScript = 0.1  # Estimated time per script generation
    $totalSeconds = $Count * $secondsPerScript
    
    if ($totalSeconds -lt 60) {
        return "$([math]::Round($totalSeconds, 1)) seconds"
    } elseif ($totalSeconds -lt 3600) {
        return "$([math]::Round($totalSeconds / 60, 1)) minutes"
    } else {
        return "$([math]::Round($totalSeconds / 3600, 1)) hours"
    }
}

# Main execution
try {
    Write-Host "=== BC Script Variant Generator - Enhanced Version ===" -ForegroundColor Green
    Write-Host "Starting generation process..." -ForegroundColor Yellow
    
    # Validate base script exists
    if (-not (Test-Path $BaseScriptPath)) {
        throw "Base script not found: $BaseScriptPath"
    }
    
    # Read base script content
    $baseContent = Get-Content $BaseScriptPath -Raw
    Write-Host "✓ Base script loaded: $(Split-Path $BaseScriptPath -Leaf)" -ForegroundColor Green
    
    # Load data files
    $vendorsFile = Join-Path $ProjectFolder "var-vendors"
    $itemsFile = Join-Path $ProjectFolder "var-items"
    $locationsFile = Join-Path $ProjectFolder "var-locations"
    
    $vendors = Get-DataValues $vendorsFile $VendorFilter
    $items = Get-DataValues $itemsFile $ItemFilter
    $locations = Get-DataValues $locationsFile $LocationFilter
    
    Write-Host "✓ Data loaded:" -ForegroundColor Green
    Write-Host "  Vendors: $($vendors.Count) ($(($vendors | Select-Object -First 3) -join ', ')...)" -ForegroundColor Cyan
    Write-Host "  Items: $($items.Count) ($(($items | Select-Object -First 3) -join ', ')...)" -ForegroundColor Cyan
    Write-Host "  Locations: $($locations.Count) ($(($locations | Select-Object -First 3) -join ', ')...)" -ForegroundColor Cyan
    
    # Calculate total combinations
    $totalCombinations = $vendors.Count * $items.Count * $locations.Count
    Write-Host "✓ Total possible combinations: $totalCombinations" -ForegroundColor Yellow
    
    # Apply batch size limit
    $actualGenerationCount = [math]::Min($totalCombinations, $BatchSize)
    Write-Host "✓ Will generate: $actualGenerationCount scripts (BatchSize: $BatchSize)" -ForegroundColor Yellow
    
    # Check if we exceed the maximum limit
    if ($totalCombinations -gt $MaxCombinations) {
        Write-Warning "Total combinations ($totalCombinations) exceeds safety limit ($MaxCombinations)"
        Write-Host "Consider using filters or increase -MaxCombinations parameter" -ForegroundColor Red
        return
    }
    
    # Estimate time
    $estimatedTime = Get-EstimatedTime $actualGenerationCount
    Write-Host "✓ Estimated generation time: $estimatedTime" -ForegroundColor Yellow
    
    if ($WhatIf) {
        Write-Host "=== WHAT-IF MODE - No files will be created ===" -ForegroundColor Magenta
        Write-Host "Would generate $actualGenerationCount script files out of $totalCombinations possible" -ForegroundColor Magenta
        return
    }
    
    # Create output directory if it doesn't exist (relative to project folder)
    $fullOutputPath = Join-Path $ProjectFolder $OutputFolder
    if (-not (Test-Path $fullOutputPath)) {
        New-Item -Path $fullOutputPath -ItemType Directory -Force
        Write-Host "✓ Created output directory: $fullOutputPath" -ForegroundColor Green
    }
    
    # Get base script name without extension
    $baseScriptName = [System.IO.Path]::GetFileNameWithoutExtension($BaseScriptPath)
    
    # Progress tracking
    $generatedCount = 0
    $progressCounter = 0
    $startTime = Get-Date
    
    Write-Host "`nGenerating variants..." -ForegroundColor Yellow
    
    # Generate all combinations (up to batch size limit)
    foreach ($vendor in $vendors) {
        foreach ($item in $items) {
            foreach ($location in $locations) {
                $progressCounter++
                
                # Stop if we've reached the batch size limit
                if ($generatedCount -ge $BatchSize) {
                    Write-Host "✓ Reached batch size limit ($BatchSize). Stopping generation." -ForegroundColor Yellow
                    break
                }
                
                # Show progress every 10 scripts for small batches, 50 for large
                $progressInterval = if ($BatchSize -le 50) { 10 } else { 50 }
                if ($progressCounter % $progressInterval -eq 0 -or $progressCounter -eq $actualGenerationCount) {
                    $percent = [math]::Round(($generatedCount / $actualGenerationCount) * 100, 1)
                    Write-Host "Progress: $generatedCount/$actualGenerationCount ($percent%)" -ForegroundColor Cyan
                }
                
                $variantName = "$baseScriptName Variant-V$vendor-I$item-L$location"
                $outputPath = Join-Path $fullOutputPath "$variantName.yml"
                
                # Generate new content
                $newContent = Update-ScriptContent -Content $baseContent -Vendor $vendor -Item $item -Location $location -NewName $variantName -NewDescription "Test recording - Variant with Vendor $vendor, Item $item, Location $location" -NewTelemetryId (New-TelemetryId)
                
                # Write to file
                $newContent | Out-File -FilePath $outputPath -Encoding UTF8
                $generatedCount++
            }
            if ($generatedCount -ge $BatchSize) { break }
        }
        if ($generatedCount -ge $BatchSize) { break }
    }
    
    $totalTime = (Get-Date) - $startTime
    
    Write-Host "`n=== Generation Complete! ===" -ForegroundColor Green
    Write-Host "✓ Generated: $generatedCount script variants" -ForegroundColor Green
    Write-Host "✓ Output location: $fullOutputPath" -ForegroundColor Green
    Write-Host "✓ Total time: $([math]::Round($totalTime.TotalSeconds, 1)) seconds" -ForegroundColor Green
    Write-Host "✓ Average rate: $([math]::Round($generatedCount / $totalTime.TotalSeconds, 1)) scripts/second" -ForegroundColor Green
    Write-Host "`nReady for testing with npx-run.ps1" -ForegroundColor Yellow
    
} catch {
    Write-Error "Error generating variants: $($_.Exception.Message)"
    Write-Error $_.ScriptStackTrace
    exit 1
}

<#
.SYNOPSIS
Generate BC Script Variants with multiple variables

.DESCRIPTION
Creates YAML script variations by substituting vendor, item, and location values from data files.
Supports filtering and safety limits for large-scale generation.

.EXAMPLE
# Generate a small test batch (10 scripts)
.\Generate-BC-Script-Variants-Enhanced.ps1 -BaseScriptPath ".\PO POST Simple.yml" -ProjectFolder "."

.EXAMPLE
# Generate 50 scripts for testing
.\Generate-BC-Script-Variants-Enhanced.ps1 -BaseScriptPath ".\PO POST Simple.yml" -ProjectFolder "." -BatchSize 50

.EXAMPLE
# Generate with filters (smaller dataset)
.\Generate-BC-Script-Variants-Enhanced.ps1 -BaseScriptPath ".\PO POST Simple.yml" -ProjectFolder "." -VendorFilter "1000" -ItemFilter "S" -BatchSize 25

.EXAMPLE
# Preview without generating
.\Generate-BC-Script-Variants-Enhanced.ps1 -BaseScriptPath ".\PO POST Simple.yml" -ProjectFolder "." -WhatIf

.EXAMPLE
# Generate all combinations (remove batch size limit)
.\Generate-BC-Script-Variants-Enhanced.ps1 -BaseScriptPath ".\PO POST Simple.yml" -ProjectFolder "." -BatchSize 9999
#>