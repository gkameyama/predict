@echo off
setlocal

cd /d "%~dp0"

set "PYTHON_EXE="
if exist ".venv\Scripts\python.exe" set "PYTHON_EXE=.venv\Scripts\python.exe"
if not defined PYTHON_EXE if exist "venv\Scripts\python.exe" set "PYTHON_EXE=venv\Scripts\python.exe"
if not defined PYTHON_EXE set "PYTHON_EXE=python"

echo [INFO] Using Python: %PYTHON_EXE%
call "%PYTHON_EXE%" "%CD%\discriminant_analysis.py" --gui
if errorlevel 1 goto :error

goto :end

:error
echo [ERROR] GUI launch failed.
pause
exit /b 1

:end
endlocal
