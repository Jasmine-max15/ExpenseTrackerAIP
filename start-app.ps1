<#
.SYNOPSIS
    Start the ExpenseTracker application with MySQL and Tomcat
.DESCRIPTION
    This script automates the startup process for the ExpenseTracker web application.
    It starts MySQL service, sets up environment variables, starts Tomcat, and opens the app in a browser.
.EXAMPLE
    .\start-app.ps1
#>

# Configuration
$TOMCAT_DIR = "C:\Users\heman\tools\apache-tomcat-10.1.54"
$JAVA_HOME = "C:\Program Files\Java\jdk-25"
$APP_URL = "http://localhost:8080/ExpenseTracker/"
$MYSQL_SERVICE = "MySQL80"

# Colors for console output
function Write-Success { Write-Host $args -ForegroundColor Green }
function Write-Info { Write-Host $args -ForegroundColor Cyan }
function Write-Error-Custom { Write-Host $args -ForegroundColor Red }

Write-Host "==========================================" -ForegroundColor Yellow
Write-Host "  ExpenseTracker - Application Startup" -ForegroundColor Yellow
Write-Host "==========================================" -ForegroundColor Yellow
Write-Host ""

# Check if running as admin (optional but recommended for services)
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")
if (-not $isAdmin) {
    Write-Info "[!] Not running as Administrator. May need admin rights to start MySQL service."
}

# Step 1: Start MySQL Service
Write-Info "Step 1: Starting MySQL Service..."
try {
    $service = Get-Service $MYSQL_SERVICE -ErrorAction SilentlyContinue
    if ($null -eq $service) {
        Write-Error-Custom "[X] MySQL service '$MYSQL_SERVICE' not found"
        exit 1
    }
    
    if ($service.Status -eq 'Running') {
        Write-Success "[OK] MySQL service is already running"
    }
    else {
        Start-Service -Name $MYSQL_SERVICE -ErrorAction Stop
        Start-Sleep -Seconds 3
        Write-Success "[OK] MySQL service started"
    }
}
catch {
    Write-Error-Custom "[X] Failed to start MySQL service: $_"
    Write-Info "  Try running this script as Administrator"
    exit 1
}

Write-Host ""

# Step 2: Verify Tomcat and Java paths
Write-Info "Step 2: Verifying prerequisites..."
if (-not (Test-Path "$TOMCAT_DIR\bin\catalina.bat")) {
    Write-Error-Custom "[X] Tomcat not found at: $TOMCAT_DIR"
    exit 1
}
Write-Success "[OK] Tomcat found"

if (-not (Test-Path "$JAVA_HOME\bin\java.exe")) {
    Write-Error-Custom "[X] Java not found at: $JAVA_HOME"
    exit 1
}
Write-Success "[OK] Java found"

Write-Host ""

# Step 3: Set environment variables
Write-Info "Step 3: Configuring environment..."
$env:JAVA_HOME = $JAVA_HOME
$env:CATALINA_HOME = $TOMCAT_DIR
$env:CATALINA_BASE = $TOMCAT_DIR
Write-Success "[OK] Environment variables configured"

Write-Host ""

# Step 4: Start Tomcat
Write-Info "Step 4: Starting Tomcat..."
try {
    & "$TOMCAT_DIR\bin\catalina.bat" start 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) {
        throw "Catalina exit code: $LASTEXITCODE"
    }
    Write-Success "[OK] Tomcat startup command sent"
    Write-Info "  Waiting for Tomcat to fully initialize..."
    
    # Wait for Tomcat to be ready
    $maxAttempts = 15
    $attempt = 0
    $ready = $false
    
    while ($attempt -lt $maxAttempts -and -not $ready) {
        Start-Sleep -Seconds 2
        $attempt++
        try {
            $response = Invoke-WebRequest -Uri $APP_URL -UseBasicParsing -TimeoutSec 5 -ErrorAction SilentlyContinue
            if ($response.StatusCode -eq 200) {
                $ready = $true
            }
        }
        catch {
            # Still waiting
        }
        Write-Host "  [$attempt/$maxAttempts] Checking app availability..." -ForegroundColor Gray
    }
    
    if ($ready) {
        Write-Success "[OK] Tomcat is ready and app is responding"
    }
    else {
        Write-Error-Custom "[X] Tomcat did not respond in time"
        exit 1
    }
}
catch {
    Write-Error-Custom "[X] Failed to start Tomcat: $_"
    exit 1
}

Write-Host ""

# Step 5: Display success message
Write-Host "==========================================" -ForegroundColor Green
Write-Success "[OK] Application is running!"
Write-Host "==========================================" -ForegroundColor Green
Write-Host ""
Write-Info "App URL: $APP_URL"
Write-Info "MySQL: localhost:3306"
Write-Info "MySQL User: root"
Write-Host ""
Write-Info "Opening application in browser..."
Write-Host ""

# Step 6: Open in browser
try {
    Start-Process $APP_URL
    Write-Success "[OK] Browser opened"
}
catch {
    Write-Info "[!] Could not auto-open browser. Please visit: $APP_URL"
}

Write-Host ""
Write-Info "To stop the application, run: .\stop-app.ps1"
Write-Host ""
