@echo off
rem ============================================================
rem  Whiteout - Survival Camp : local launcher
rem  Double-click this file. Close this window to stop the server.
rem ============================================================
cd /d "%~dp0"
set PORT=8123

rem -- find a python launcher -----------------------------------
rem  Use "--version" rather than "where": on this machine python is
rem  reachable through an execution alias that "where" cannot see.
set PY=
py --version >nul 2>&1 && set PY=py
if "%PY%"=="" ( python --version >nul 2>&1 && set PY=python )
if "%PY%"=="" ( python3 --version >nul 2>&1 && set PY=python3 )

if "%PY%"=="" (
  echo [!] Python not found.
  echo     Install Python, or serve this folder with any static server, e.g.:
  echo       npx serve -l %PORT%
  echo.
  pause
  exit /b 1
)

echo.
echo   Whiteout - Survival Camp
echo   http://localhost:%PORT%/index.html
echo.
echo   Keep this window open while playing.
echo   Press Ctrl+C or close the window to stop.
echo.

rem -- open the browser once the server is up -------------------
start "" /b cmd /c "timeout /t 2 >nul & start "" http://localhost:%PORT%/index.html"

%PY% -m http.server %PORT%
