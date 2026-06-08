import sys
sys.path.insert(0, '.')
try:
    from libraries.CustomLibrary import CustomLibrary
    print("SUCCESS: CustomLibrary imported OK")
except Exception as e:
    print(f"FAIL: {type(e).__name__}: {e}")
