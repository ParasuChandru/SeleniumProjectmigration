"""Test importing libraries/CustomLibrary.py the way Robot Framework does."""
import sys
sys.path.insert(0, '.')

# This is how Robot Framework imports: it does `import libraries.CustomLibrary`
# and looks for a class named CustomLibrary inside
try:
    import importlib
    mod = importlib.import_module('libraries.CustomLibrary')
    cls = getattr(mod, 'CustomLibrary')
    instance = cls()
    print(f"SUCCESS: imported {mod}, class {cls}, instance {instance}")
except Exception as e:
    print(f"FAIL: {type(e).__name__}: {e}")

# Also check: Robot Framework with a .py path does `from <module> import <class>`
# where module = filename without .py, class = same name
try:
    import importlib
    mod = importlib.import_module('libraries.CustomLibrary')
    # Robot looks for a class whose name matches the filename
    class_name = 'CustomLibrary'
    cls = getattr(mod, class_name)
    print(f"SUCCESS: class {cls} found in module")
except Exception as e:
    print(f"FAIL: {type(e).__name__}: {e}")
