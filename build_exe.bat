@echo off
setlocal

cd /d "%~dp0"

set "APP_NAME=DiscriminantAnalysisGUI"
set "SCRIPT_NAME=discriminant_analysis.py"
set "PYTHON_EXE="
set "PY_BASE="
set "UPX_DIR=C:\upx"
set "PYINSTALLER_CONFIG_DIR=%CD%\.pyinstaller"
set "TK_OPTIONS="

if exist ".venv\Scripts\python.exe" set "PYTHON_EXE=.venv\Scripts\python.exe"
if not defined PYTHON_EXE if exist "venv\Scripts\python.exe" set "PYTHON_EXE=venv\Scripts\python.exe"
if not defined PYTHON_EXE set "PYTHON_EXE=python"

echo [INFO] Using Python: %PYTHON_EXE%

for /f "delims=" %%I in ('%PYTHON_EXE% -c "import sys; print(sys.base_prefix)"') do set "PY_BASE=%%I"
if not defined PY_BASE (
    echo [ERROR] Python base directory could not be detected.
    exit /b 1
)

if exist "%PY_BASE%\tcl\tcl8.6" set "TK_OPTIONS=%TK_OPTIONS% --add-data %PY_BASE%\tcl\tcl8.6;_tcl_data"
if exist "%PY_BASE%\tcl\tk8.6" set "TK_OPTIONS=%TK_OPTIONS% --add-data %PY_BASE%\tcl\tk8.6;_tk_data"
if exist "%PY_BASE%\DLLs\tcl86t.dll" set "TK_OPTIONS=%TK_OPTIONS% --add-binary %PY_BASE%\DLLs\tcl86t.dll;."
if exist "%PY_BASE%\DLLs\tk86t.dll" set "TK_OPTIONS=%TK_OPTIONS% --add-binary %PY_BASE%\DLLs\tk86t.dll;."

for %%D in (build dist .pyinstaller __pycache__) do (
    if exist "%%D" (
        echo [INFO] Removing %%D
        rmdir /s /q "%%D"
    )
)

echo [INFO] Installing build dependencies
call "%PYTHON_EXE%" -m pip install --disable-pip-version-check pyinstaller numpy openpyxl
if errorlevel 1 goto :error

set "UPX_OPTION="
if exist "%UPX_DIR%\upx.exe" (
    echo [INFO] UPX detected: %UPX_DIR%
    set "UPX_OPTION=--upx-dir %UPX_DIR%"
) else (
    echo [WARN] UPX not found at %UPX_DIR%. Build will continue without UPX compression.
)

echo [INFO] Building exe
set "SPEC_FILE=%APP_NAME%.spec"
if not exist "%SPEC_FILE%" (
    echo [ERROR] Spec file not found: %SPEC_FILE%
    exit /b 1
)

call "%PYTHON_EXE%" -m PyInstaller ^
  --noconfirm ^
  --clean ^
  %UPX_OPTION% ^
  "%SPEC_FILE%"
if errorlevel 1 goto :error

echo [INFO] Build completed
echo [INFO] Output: dist\%APP_NAME%.exe
goto :end

:error
echo [ERROR] Build failed.
exit /b 1

:end
endlocal
