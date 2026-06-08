"""CustomRobotLibrary - Robot Framework library for browser automation.

This library provides reusable Selenium automation keywords.
"""


class CustomLibrary:
    """Re-export CustomLibrary from the libraries package.
    
    This module exists so Robot Framework can import the library
    as 'Library    CustomLibrary    WITH NAME    Custom'
    from any test file location when --pythonpath . is used.
    """
    
    def __init__(self):
        from importlib import import_module
        mod = import_module('libraries.CustomLibrary')
        cls = mod.CustomLibrary
        self._delegate = cls()
    
    def __getattr__(self, name):
        return getattr(self._delegate, name)
