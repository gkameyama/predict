@echo off
setlocal

cd /d "%~dp0"

set "APP_NAME=DiscriminantAnalysisCSVOnly"
set "PYTHON_EXE="
set "UPX_DIR=C:\upx"
set "PYINSTALLER_CONFIG_DIR=%CD%\.pyinstaller"

if exist ".venv\Scripts\python.exe" set "PYTHON_EXE=.venv\Scripts\python.exe"
if not defined PYTHON_EXE if exist "venv\Scripts\python.exe" set "PYTHON_EXE=venv\Scripts\python.exe"
if not defined PYTHON_EXE set "PYTHON_EXE=python"

echo [INFO] Using Python: %PYTHON_EXE%

for %%D in (build dist .pyinstaller __pycache__) do (
    if exist "%%D" (
        echo [INFO] Removing %%D
        rmdir /s /q "%%D"
    )
)

echo [INFO] Installing build dependencies
call "%PYTHON_EXE%" -m pip install --disable-pip-version-check pyinstaller numpy
if errorlevel 1 goto :error

set "UPX_OPTION="
if exist "%UPX_DIR%\upx.exe" (
    echo [INFO] UPX detected: %UPX_DIR%
    set "UPX_OPTION=--upx-dir %UPX_DIR%"
) else (
    echo [WARN] UPX not found at %UPX_DIR%. Build will continue without UPX compression.
)

echo [INFO] Building exe
call "%PYTHON_EXE%" -m PyInstaller ^
  --noconfirm ^
  --clean ^
  %UPX_OPTION% ^
  "%APP_NAME%.spec"
if errorlevel 1 goto :error

echo [INFO] Build completed
echo [INFO] Output: dist\%APP_NAME%.exe
goto :end

:error
echo [ERROR] Build failed.
exit /b 1

:end
endlocal
