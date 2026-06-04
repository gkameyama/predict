import os
import sys
from pathlib import Path


def _set_env_if_exists(name: str, value: Path) -> None:
    if value.exists():
        os.environ[name] = str(value)


def configure_tk_environment() -> None:
    base_prefix = Path(sys.base_prefix)

    if getattr(sys, "frozen", False):
        bundle_dir = Path(getattr(sys, "_MEIPASS", Path(sys.executable).resolve().parent))
        _set_env_if_exists("TCL_LIBRARY", bundle_dir / "_tcl_data")
        _set_env_if_exists("TK_LIBRARY", bundle_dir / "_tk_data")
    else:
        _set_env_if_exists("TCL_LIBRARY", base_prefix / "tcl" / "tcl8.6")
        _set_env_if_exists("TK_LIBRARY", base_prefix / "tcl" / "tk8.6")

    dll_dir = base_prefix / "DLLs"
    if dll_dir.exists():
        os.environ["PATH"] = str(dll_dir) + os.pathsep + os.environ.get("PATH", "")
        add_dll_directory = getattr(os, "add_dll_directory", None)
        if add_dll_directory is not None:
            add_dll_directory(str(dll_dir))
