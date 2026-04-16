<#
.SYNOPSIS
    Stop the ExpenseTracker application
.DESCRIPTION
    This script gracefully stops the Tomcat server and MySQL service.
.EXAMPLE
    .\stop-app.ps1
#>

# Configuration
$TOMCAT_DIR = "C:\Users\heman\tools\apache-tomcat-10.1.54"
$MYSQL_SERVICE = "MySQL80"

# Colors for console output
function Write-Success { Write-Host $args -ForegroundColor Green }
function Write-Info { Write-Host $args -ForegroundColor Cyan }
function Write-Error-Custom { Write-Host $args -ForegroundColor Red }

Write-Host "==========================================" -ForegroundColor Yellow
Write-Host "  ExpenseTracker - Application Shutdown" -ForegroundColor Yellow
Write-Host "==========================================" -ForegroundColor Yellow
Write-Host ""

# Step 1: Stop Tomcat
Write-Info "Step 1: Stopping Tomcat..."
try {
    $env:CATALINA_HOME = $TOMCAT_DIR
    $env:CATALINA_BASE = $TOMCAT_DIR
    & "$TOMCAT_DIR\bin\catalina.bat" stop 2>&1 | Out-Null
    Start-Sleep -Seconds 3
    Write-Success "[OK] Tomcat stopped"
}
catch {
    Write-Error-Custom "[X] Error stopping Tomcat: $_"
}

Write-Host ""

# Step 2: Stop MySQL Service (optional)
Write-Info "Step 2: MySQL Service Status"
try {
    $service = Get-Service $MYSQL_SERVICE -ErrorAction SilentlyContinue
    if ($null -eq $service) {
        Write-Info "[!] MySQL service not found"
    }
    elseif ($service.Status -eq 'Stopped') {
        Write-Info "[OK] MySQL service is already stopped"
    }
    else {
        $response = Read-Host "Do you want to stop MySQL service? (y/n)"
        if ($response -eq 'y' -or $response -eq 'Y') {
            Stop-Service -Name $MYSQL_SERVICE -ErrorAction Stop
            Start-Sleep -Seconds 2
            Write-Success "[OK] MySQL service stopped"
        }
        else {
            Write-Info "[OK] MySQL service left running"
        }
    }
}
catch {
    Write-Error-Custom "[X] Error managing MySQL service: $_"
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Green
Write-Success "[OK] Application stopped successfully"
Write-Host "==========================================" -ForegroundColor Green
Write-Host ""
