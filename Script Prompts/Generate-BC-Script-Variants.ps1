# Generate BC Script Variants
# This script creates multiple test script variations by substituting values from data files

param(
    [Parameter(Mandatory=$true)]
    [string]$BaseScriptPath,
    
    [Parameter(Mandatory=$true)]
    [string]$ProjectFolder,
    
    [Parameter(Mandatory=$false)]
    [string]$OutputFolder = "C:\Users\AndrewWingate\andy@wingateuk.com\OneDrive\Presentations & Colabs\2025-10 SCS 2025\BC\Script Prompts\Run Me"
)

# Function to read data file and return array of values
function Get-DataValues {
    param([string]$FilePath)
    
    if (Test-Path $FilePath) {
        return Get-Content $FilePath | Where-Object { $_.Trim() -ne "" }
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
        [string]$Item,
        [string]$Location,
        [string]$NewName,
        [string]$NewDescription,
        [string]$NewTelemetryId
    )
    
    # Update header information
    $Content = $Content -replace '^name:.*$', "name: $NewName"
    $Content = $Content -replace '^description:.*$', "description: $NewDescription"
    $Content = $Content -replace '^telemetryId:.*$', "telemetryId: $NewTelemetryId"
    
    # Find and replace item value patterns
    # Pattern 1: Direct item input in line field
    $Content = $Content -replace '(value:\s*")[^"]*("\s*.*field:\s*No\.)', "`$1$Item`$2"
    
    # Pattern 2: Item input with description
    $Content = $Content -replace '(Input <value>)[^<]*(</value> into <caption>No\.</caption>)', "`$1$Item`$2"
    
    # Find and replace location value patterns
    # Pattern 1: Direct location input
    $Content = $Content -replace '(value:\s*")[^"]*("\s*.*field:\s*Location Code)', "`$1$Location`$2"
    
    # Pattern 2: Location input with description
    $Content = $Content -replace '(Input <value>)[^<]*(</value> into <caption>Location Code</caption>)', "`$1$Location`$2"
    
    return $Content
}

# Main execution
try {
    Write-Host "Starting BC Script Variant Generation..." -ForegroundColor Green
    
    # Validate base script exists
    if (-not (Test-Path $BaseScriptPath)) {
        throw "Base script not found: $BaseScriptPath"
    }
    
    # Read base script content
    $baseContent = Get-Content $BaseScriptPath -Raw
    Write-Host "Base script loaded: $BaseScriptPath" -ForegroundColor Yellow
    
    # Load data files
    $itemsFile = Join-Path $ProjectFolder "Items"
    $locationsFile = Join-Path $ProjectFolder "Locations"
    
    $items = Get-DataValues $itemsFile
    $locations = Get-DataValues $locationsFile
    
    Write-Host "Items loaded: $($items -join ', ')" -ForegroundColor Yellow
    Write-Host "Locations loaded: $($locations -join ', ')" -ForegroundColor Yellow
    
    # Create output directory if it doesn't exist
    if (-not (Test-Path $OutputFolder)) {
        New-Item -Path $OutputFolder -ItemType Directory -Force
        Write-Host "Created output directory: $OutputFolder" -ForegroundColor Yellow
    }
    
    # Get base script name without extension
    $baseScriptName = [System.IO.Path]::GetFileNameWithoutExtension($BaseScriptPath)
    
    # Generate all combinations
    $generatedCount = 0
    foreach ($item in $items) {
        foreach ($location in $locations) {
            $variantName = "$baseScriptName Variant-$item-$location"
            $outputPath = Join-Path $OutputFolder "$variantName.yml"
            
            # Generate new content
            $newContent = Update-ScriptContent -Content $baseContent -Item $item -Location $location -NewName $variantName -NewDescription "Test recording - Variant with Item $item and Location $location" -NewTelemetryId (New-TelemetryId)
            
            # Write to file
            $newContent | Out-File -FilePath $outputPath -Encoding UTF8
            
            Write-Host "Generated: $variantName.yml" -ForegroundColor Green
            $generatedCount++
        }
    }
    
    Write-Host "`nGeneration Complete!" -ForegroundColor Green
    Write-Host "Generated $generatedCount script variants in: $OutputFolder" -ForegroundColor Green
    Write-Host "Ready for testing with npx-run.ps1" -ForegroundColor Yellow
    
} catch {
    Write-Error "Error generating variants: $($_.Exception.Message)"
    exit 1
}

# Example usage:
# .\Generate-BC-Script-Variants.ps1 -BaseScriptPath ".\PO Post Prep-2\PO POST Simple.yml" -ProjectFolder ".\PO Post SCS"