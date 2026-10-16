"""Run the settings test without unrelated game autoloads or editor plugins."""
import pathlib
import re
import shutil
import subprocess
import sys
import tempfile

source = pathlib.Path(__file__).resolve().parents[1]
with tempfile.TemporaryDirectory() as work:
    work = pathlib.Path(work)
    shutil.copytree(source, work, dirs_exist_ok=True,
                    ignore=shutil.ignore_patterns('.git', '.godot', '__pycache__'))
    project = work / 'project.godot'
    text = re.sub(r'(?ms)^\[autoload\]\n.*?(?=^\[|\Z)', '', project.read_text())
    text = re.sub(r'(?ms)^\[editor_plugins\]\n.*?(?=^\[|\Z)', '', text)
    project.write_text(text)
    engine = sys.argv[1] if len(sys.argv) > 1 else 'godot'
    subprocess.run([engine, '--headless', '--path', str(work), '--editor', '--import', '--quit'], check=True)
    subprocess.run([engine, '--headless', '--path', str(work), '--script', 'tests/settings_volume_test.gd'], check=True)
