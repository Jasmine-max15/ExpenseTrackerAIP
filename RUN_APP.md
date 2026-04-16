# ExpenseTracker - Quick Start Guide

## Overview
This directory contains scripts to easily start and stop the ExpenseTracker web application.

## Prerequisites
- **Java:** JDK 25 installed at `C:\Program Files\Java\jdk-25`
- **MySQL:** MySQL 8.0 service installed and configured
- **MySQL Password:** `Sumit7264#` (for root user)
- **Tomcat:** Portable Tomcat at `C:\Users\heman\tools\apache-tomcat-10.1.54`

## Quick Start

### Option 1: Using PowerShell Scripts (Recommended)

#### Start Application
```powershell
cd e:\CODES\ExpenseTrackerAIP
.\start-app.ps1
```

This will:
1. Start MySQL service
2. Start Tomcat
3. Wait for app to be ready
4. Open the app in your default browser

**URL:** http://localhost:8080/ExpenseTracker/

#### Stop Application
```powershell
.\stop-app.ps1
```

### Option 2: Manual Commands

#### Start
```powershell
# Start MySQL
net start MySQL80

# Set environment variables and start Tomcat
$env:JAVA_HOME = "C:\Program Files\Java\jdk-25"
$env:CATALINA_HOME = "C:\Users\heman\tools\apache-tomcat-10.1.54"
$env:CATALINA_BASE = "C:\Users\heman\tools\apache-tomcat-10.1.54"
& "C:\Users\heman\tools\apache-tomcat-10.1.54\bin\catalina.bat" start

# Wait 8-10 seconds, then open browser
Start-Process "http://localhost:8080/ExpenseTracker/"
```

#### Stop
```powershell
$env:CATALINA_HOME = "C:\Users\heman\tools\apache-tomcat-10.1.54"
$env:CATALINA_BASE = "C:\Users\heman\tools\apache-tomcat-10.1.54"
& "C:\Users\heman\tools\apache-tomcat-10.1.54\bin\catalina.bat" stop

# Optional: Stop MySQL
net stop MySQL80
```

## Access the Application

- **URL:** http://localhost:8080/ExpenseTracker/
- Create an account or login to access the expense tracker

## Database Information

| Property | Value |
|----------|-------|
| **Type** | MySQL 8.0 |
| **Host** | localhost:3306 |
| **Database** | expense_tracker |
| **Username** | root |
| **Password** | Sumit7264# |
| **Tables** | users, categories, expenses |

### Access Database via MySQL CLI
```powershell
mysql -u root -p"Sumit7264#" expense_tracker
```

## File Structure

```
ExpenseTrackerAIP/
├── start-app.ps1          # Script to start the application
├── stop-app.ps1           # Script to stop the application
├── RUN_APP.md             # This file
├── src/                   # Java source files (Servlets, DAOs, Models)
├── WebContent/            # JSP files, CSS, static files
├── database/
│   └── schema.sql         # MySQL database schema
└── build/                 # Compiled classes
```

## Troubleshooting

### "CATALINA_HOME not defined"
Make sure you're using the start-app.ps1 script, which sets these variables automatically.

### MySQL Connection Failed
- Verify MySQL service is running: `Get-Service MySQL80`
- Start it manually: `net start MySQL80`
- Check password is correct: Try login manually `mysql -u root -p`

### Port 8080 Already in Use
- Check if another Tomcat instance is running
- Use `stop-app.ps1` to stop it
- Or modify Tomcat port in `WebContent/WEB-INF/web.xml` (requires rebuild)

### App Shows 404
- Wait 10-15 seconds for full startup
- Check Tomcat logs: `C:\Users\heman\tools\apache-tomcat-10.1.54\logs\catalina.out`
- Try refreshing the browser

### PowerShell Execution Policy Error
If you get "cannot be loaded because running scripts is disabled":
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## Default Login Credentials

Check the MySQL database for existing users:
```powershell
mysql -u root -p"Sumit7264#" expense_tracker -e "SELECT username FROM users;"
```

Or create a new account via the registration page.

## Development & Rebuilding

If you modify Java source files, redeploy:
```powershell
cd e:\CODES\ExpenseTrackerAIP

# Stop the app
.\stop-app.ps1

# Recompile (manual if source changed)
$tomcatDir = "C:\Users\heman\tools\apache-tomcat-10.1.54"
javac --release 21 -cp "$tomcatDir\lib\*;WebContent\WEB-INF\lib\*" -d WebContent\WEB-INF\classes (Get-ChildItem src -Recurse -Filter "*.java" | Select-Object -ExpandProperty FullName)

# Restart
.\start-app.ps1
```

## Support

For issues or questions, check:
- Tomcat logs: `C:\Users\heman\tools\apache-tomcat-10.1.54\logs\`
- MySQL error log: `C:\ProgramData\MySQL\MySQL Server 8.0\Data\`
- README.md in project root
