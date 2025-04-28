# mygrep.ps1 - A PowerShell version of the mygrep.sh script
# Supports case-insensitive search, line numbers (-n), and inverted matching (-v)

param(
    [Parameter(Position=0)]
    [string]$pattern,
    
    [Parameter(Position=1)]
    [string]$file,
    
    [switch]$n,
    
    [switch]$v,
    
    [switch]$help
)

# Function to display help information
function Show-Help {
    Write-Host "Usage: .\mygrep.ps1 [OPTIONS] PATTERN FILE"
    Write-Host "Search for PATTERN in FILE (case-insensitive by default)"
    Write-Host ""
    Write-Host "Options:"
    Write-Host "  -n         Show line numbers for each match"
    Write-Host "  -v         Invert the match (print lines that do not match)"
    Write-Host "  -help      Display this help and exit"
    Write-Host ""
    Write-Host "Examples:"
    Write-Host "  .\mygrep.ps1 hello testfile.txt       # Search for 'hello' in testfile.txt"
    Write-Host "  .\mygrep.ps1 -n hello testfile.txt    # Show line numbers with matches"
    Write-Host "  .\mygrep.ps1 -v hello testfile.txt    # Show lines that don't match 'hello'"
    Write-Host "  .\mygrep.ps1 -v -n hello testfile.txt # Combine options"
    exit 0
}

# Show help if requested
if ($help) {
    Show-Help
}

# Check if pattern is provided
if ([string]::IsNullOrEmpty($pattern)) {
    Write-Host "Error: Missing search pattern." -ForegroundColor Red
    Write-Host "Try '.\mygrep.ps1 -help' for more information."
    exit 1
}

# Check if file is provided
if ([string]::IsNullOrEmpty($file)) {
    Write-Host "Error: Missing filename." -ForegroundColor Red
    Write-Host "Try '.\mygrep.ps1 -help' for more information."
    exit 1
}

# Check if file exists
if (-not (Test-Path $file)) {
    Write-Host "Error: File '$file' does not exist." -ForegroundColor Red
    exit 1
}

# Process the file
$lineNumber = 0
Get-Content $file | ForEach-Object {
    $lineNumber++
    $line = $_
    
    # Case-insensitive match
    $match = $line -match $pattern
    
    # Determine whether to print based on invert_match flag
    if (($v -and -not $match) -or (-not $v -and $match)) {
        if ($n) {
            Write-Host "${lineNumber}:$line"
        } else {
            Write-Host $line
        }
    }
}

exit 0