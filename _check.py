import sys
print("PYTHONPATH:", sys.path)
try:
    from libraries.CustomLibrary import CustomLibrary
    print("SUCCESS: libraries.CustomLibrary imported")
except Exception as e:
    print(f"FAIL: {e}")
