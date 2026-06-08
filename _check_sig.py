from SeleniumLibrary import SeleniumLibrary
import inspect

lib_inst = SeleniumLibrary()
kw_names = lib_inst.get_keyword_names()

# Find open browser related
open_kw = [k for k in kw_names if 'open' in k.lower()]
print("Open keywords:", open_kw)

# Get arguments for each
for kw in open_kw:
    args = lib_inst.get_keyword_arguments(kw)
    print(f"  {kw}: {args}")

# Also check: does SeleniumLibrary support headless via browser options?
# In SeleniumLibrary 6.x, headless is set via browser_options or via browser=chrome+options
print("\n--- Checking browser options ---")
# List all keywords containing 'browser'
browser_kw = [k for k in kw_names if 'browser' in k.lower()]
print("Browser keywords:", browser_kw[:20])
