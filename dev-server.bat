@echo off
setlocal
REM Servicepage - Local dev server (Windows)
REM Usage: dev-server.bat [port] [--lan]
REM   port    default: 8000
REM   --lan   listen on all interfaces so phones and other devices on your network can open it
REM           (prints the addresses to open); without it the server stays on 127.0.0.1 only
REM
REM This project is a single static HTML page (no build step, no
REM server-side config), so there's no DEV_MODE/production split to
REM toggle - this script just serves the repo root over HTTP so
REM index.html can be opened without hand-configuring a static server
REM each time.

set "DIR=%~dp0"
set "PORT=8000"
set "HOST=127.0.0.1"

:args
if "%~1"=="" goto run
if /I "%~1"=="--lan" (
    set "HOST=0.0.0.0"
    shift
    goto args
)
echo %~1| findstr /r "^[0-9][0-9]*$" >nul
if errorlevel 1 (
    echo Unknown option: %~1
    echo Usage: dev-server.bat [port] [--lan]
    exit /b 1
)
set "PORT=%~1"
shift
goto args

:run
echo Serving %DIR% at http://127.0.0.1:%PORT%
if "%HOST%"=="0.0.0.0" (
    echo On your local network ^(--lan^), open one of these on the other device:
    for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /c:"IPv4"') do (
        for /f "tokens=* delims= " %%b in ("%%a") do echo     http://%%b:%PORT%
    )
    echo   ^(usually the 192.168.x.x one; allow PHP or Python through the firewall if asked^)
)

where php >nul 2>&1
if %errorlevel%==0 (
    php -S %HOST%:%PORT% -t "%DIR%."
    goto :eof
)

where python >nul 2>&1
if %errorlevel%==0 (
    python -m http.server %PORT% --directory "%DIR%." --bind %HOST%
    goto :eof
)

echo Neither php nor python found on PATH - install one to run a local server.
exit /b 1
