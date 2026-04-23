# -*- mode: python ; coding: utf-8 -*-
from PyInstaller.utils.hooks import collect_submodules

hiddenimports = [
    "tkinter",
    "tkinter.ttk",
    "tkinter.filedialog",
    "tkinter.messagebox",
    "_tkinter",
    "openpyxl",
]
hiddenimports += collect_submodules("tkinter")

excludes = [
    "pandas",
    "sklearn",
    "scipy",
    "joblib",
    "threadpoolctl",
    "matplotlib",
    "IPython",
    "jupyter",
    "notebook",
    "pytest",
    "sphinx",
]

a = Analysis(
    ["discriminant_analysis.py"],
    pathex=[],
    binaries=[
        ("C:\\Users\\genkameyama\\AppData\\Local\\Programs\\Python\\Python313\\DLLs\\tcl86t.dll", "."),
        ("C:\\Users\\genkameyama\\AppData\\Local\\Programs\\Python\\Python313\\DLLs\\tk86t.dll", "."),
    ],
    datas=[
        ("C:\\Users\\genkameyama\\AppData\\Local\\Programs\\Python\\Python313\\tcl\\tcl8.6", "_tcl_data"),
        ("C:\\Users\\genkameyama\\AppData\\Local\\Programs\\Python\\Python313\\tcl\\tk8.6", "_tk_data"),
    ],
    hiddenimports=hiddenimports,
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=excludes,
    noarchive=False,
    optimize=0,
)
pyz = PYZ(a.pure)

exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.datas,
    [],
    name="DiscriminantAnalysisGUI",
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    upx_exclude=[],
    runtime_tmpdir=None,
    console=False,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
)
