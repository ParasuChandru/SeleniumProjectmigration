"""
CustomLibrary.py - Custom Robot Framework Library for Selenium Automation

This library provides reusable keywords for common browser automation tasks.
Follows PEP 8 style guide for Python code.
"""

import os
import time
from datetime import datetime
from pathlib import Path

from robot.api import logger
from selenium import webdriver
from selenium.webdriver.chrome.options import Options as ChromeOptions
from selenium.webdriver.firefox.options import Options as FirefoxOptions
from selenium.webdriver.support.ui import WebDriverWait, Select
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.action_chains import ActionChains
from selenium.common.exceptions import (
    TimeoutException,
    NoSuchElementException,
    ElementNotInteractableException,
    StaleElementReferenceException,
    WebDriverException,
)


class CustomLibrary:
    """Custom Robot Framework library with reusable Selenium automation keywords.

    This library provides core browser interaction keywords used across all test suites.
    Keywords follow Robot Framework naming conventions (Title Case for user keywords).

    Example usage in Robot Framework:
        Library    CustomLibrary    WITH NAME    Custom

    Keywords include:
        - Browser management (Open Browser, Close Browser, Go To)
        - Element interaction (Click Element, Type Text, Select Dropdown, etc.)
        - Wait conditions (explicit waits for various conditions)
        - Verification (Verify Element Visible, Contains Text, etc.)
        - Screenshot and logging utilities
    """

    # ------------------------------------------------------------------
    # Initialization
    # ------------------------------------------------------------------

    def __init__(self):
        """Initialize the CustomLibrary."""
        self._driver = None
        self._browser = "chrome"
        self._headless = True
        self._viewport_width = 1920
        self._viewport_height = 1080
        self._implicit_wait = 10
        self._explicit_wait = 15
        self._load_dir = None

    @property
    def driver(self):
        """Get or create the WebDriver instance."""
        if self._driver is None:
            self._create_driver()
        return self._driver

    def _create_driver(self):
        """Create a new WebDriver instance based on configuration."""
        if self._browser in ("chrome", "chromium"):
            options = ChromeOptions()
            if self._headless:
                options.add_argument("--headless=new")
            options.add_argument("--no-sandbox")
            options.add_argument("--disable-dev-shm-usage")
            options.add_argument("--disable-gpu")
            options.add_argument(
                f"--window-size={self._viewport_width},"
                f"{self._viewport_height}"
            )
            options.add_argument("--disable-extensions")
            if self._load_dir:
                prefs = {"download.default_directory": self._load_dir}
                options.add_experimental_option("prefs", prefs)
            try:
                self._driver = webdriver.Chrome(options=options)
            except WebDriverException:
                self._driver = webdriver.Chrome()
        elif self._browser == "firefox":
            options = FirefoxOptions()
            if self._headless:
                options.add_argument("--headless")
            options.add_argument(
                f"--width={self._viewport_width}"
            )
            options.add_argument(
                f"--height={self._viewport_height}"
            )
            self._driver = webdriver.Firefox(options=options)
        elif self._browser == "safari":
            self._driver = webdriver.Safari()
        else:
            raise WebDriverException(
                f"Unsupported browser: {self._browser}"
            )
        self._driver.implicitly_wait(self._implicit_wait)
        self._driver.set_page_load_timeout(self._explicit_wait)
        logger.info(
            f"WebDriver created for browser: {self._browser}"
        )

    def _resolve_locator(self, selector, locator_type="xpath"):
        """Resolve a locator string to Selenium By type and value.

        Handles multiple locator formats:
        - css:selector -> CSS selector
        - xpath://...  -> XPath expression
        - id=...       -> Element ID
        - name=...     -> Element name attribute
        - class=...    -> CSS class name
        - text=...     -> Link text
        - partial:...  -> Partial link text

        Args:
            selector: The locator string.
            locator_type: Default type if no prefix is detected.

        Returns:
            tuple: (By type constant, locator value)
        """
        if selector is None:
            raise ValueError("Locator selector cannot be None")
        selector = str(selector).strip()
        if selector.startswith("css:"):
            return (By.CSS_SELECTOR, selector[4:])
        elif selector.startswith("xpath:"):
            return (By.XPATH, selector[6:])
        elif selector.startswith("id:"):
            return (By.ID, selector[3:])
        elif selector.startswith("name:"):
            return (By.NAME, selector[5:])
        elif selector.startswith("class:"):
            return (By.CSS_SELECTOR, f".{selector[6:]}")
        elif selector.startswith("text:"):
            return (By.LINK_TEXT, selector[5:])
        elif selector.startswith("partial:"):
            return (By.PARTIAL_LINK_TEXT, selector[8:])
        elif selector.startswith("tag:"):
            return (By.TAG_NAME, selector[4:])
        elif selector.startswith("//") or selector.startswith(".//"):
            return (By.XPATH, selector)
        elif selector.startswith("#"):
            return (By.ID, selector[1:])
        elif selector.startswith("."):
            return (By.CSS_SELECTOR, selector)
        else:
            return (locator_type, selector)

    def _get_element(self, selector, locator_type="xpath", timeout=None):
        """Get a single web element by its locator.

        Args:
            selector: The locator value.
            locator_type: Default locator type.
            timeout: Override timeout for this lookup.

        Returns:
            WebElement
        """
        by, value = self._resolve_locator(selector, locator_type)
        wait = WebDriverWait(self.driver, timeout or self._explicit_wait)
        return wait.until(EC.presence_of_element_located((by, value)))

    def _get_elements(self, selector, locator_type="xpath", timeout=None):
        """Get multiple web elements matching a locator.

        Args:
            selector: The locator value.
            locator_type: Default locator type.
            timeout: Override timeout.

        Returns:
            list[WebElement]
        """
        by, value = self._resolve_locator(selector, locator_type)
        wait = WebDriverWait(self.driver, timeout or self._explicit_wait)
        return wait.until(
            EC.presence_of_all_elements_located((by, value))
        )

    def _wait_clickable(self, element, selector):
        """Ensure element is clickable before interaction.

        Args:
            element: The Selenium WebElement.
            selector: The original locator for logging.
        """
        WebDriverWait(self.driver, 5).until(
            EC.element_to_be_clickable((By.XPATH, ".//*"))
        )

    # ------------------------------------------------------------------
    # Browser Management Keywords
    # ------------------------------------------------------------------

    def open_browser(self, url, browser="chrome", headless=True,
                     viewport_width=1920, viewport_height=1080,
                     load_dir=None):
        """Open a new browser window and navigate to the specified URL.

        This keyword initializes the WebDriver if not already created and
        navigates to the given URL. If a browser is already open, it will
        be closed first.

        Args:
            url: The URL to navigate to.
            browser: Browser to use (chrome, firefox, safari). Default: chrome.
            headless: Whether to run in headless mode. Default: True.
            viewport_width: Browser window width in pixels. Default: 1920.
            viewport_height: Browser window height in pixels. Default: 1080.
            load_dir: Download directory for file downloads.

        Example:
            | Open Browser | https://example.com | chrome | headless=True |
        """
        if self._driver is not None:
            self.close_browser()
        self._browser = browser
        self._headless = headless
        self._viewport_width = viewport_width
        self._viewport_height = viewport_height
        self._load_dir = load_dir
        self.driver.get(url)
        self.driver.maximize_window()
        logger.info(
            f"Browser opened: {url} [{browser}, "
            f"headless={headless}]"
        )

    def close_browser(self):
        """Close the current browser window and quit the WebDriver."""
        if self._driver is not None:
            try:
                self._driver.quit()
            except WebDriverException:
                pass
            finally:
                self._driver = None
            logger.info("Browser closed")

    def reload_page(self):
        """Reload the current page."""
        current_url = self.driver.current_url
        self.driver.get(current_url)
        logger.info("Page reloaded")

    def get_current_url(self):
        """Get the current page URL.

        Returns:
            str: The current page URL.
        """
        return self.driver.current_url

    def get_page_title(self):
        """Get the current page title.

        Returns:
            str: The current page title.
        """
        return self.driver.title

    def go_to(self, url):
        """Navigate to a URL in the current browser session.

        Args:
            url: The URL to navigate to.
        """
        self.driver.get(url)
        logger.info(f"Navigated to: {url}")

    def go_back(self):
        """Navigate back in browser history."""
        self.driver.back()
        logger.info("Navigated back")

    def go_forward(self):
        """Navigate forward in browser history."""
        self.driver.forward()
        logger.info("Navigated forward")

    def maximize_window(self):
        """Maximize the browser window."""
        self.driver.maximize_window()
        logger.info("Window maximized")

    # ------------------------------------------------------------------
    # Wait Keywords
    # ------------------------------------------------------------------

    def wait_until_page_contains(self, text, timeout=None):
        """Wait until the page contains the specified text.

        Args:
            text: The text to wait for on the page.
            timeout: Maximum wait time in seconds. Default: explicit_wait.
        """
        by, value = self._resolve_locator(f"text:{text}", "xpath")
        wait = WebDriverWait(
            self.driver, timeout or self._explicit_wait
        )
        wait.until(EC.presence_of_element_located((by, value)))
        logger.debug(f"Page contains text: '{text}'")

    def wait_until_page_does_not_contain(self, text, timeout=None):
        """Wait until the page no longer contains the specified text.

        Args:
            text: The text to wait for disappearing.
            timeout: Maximum wait time in seconds.
        """
        by, value = self._resolve_locator(f"text:{text}", "xpath")
        wait = WebDriverWait(
            self.driver, timeout or self._explicit_wait
        )
        wait.until(EC.invisibility_of_element_located((by, value)))
        logger.debug(f"Page no longer contains text: '{text}'")

    def wait_until_element_is_visible(self, selector, locator_type="xpath",
                                       timeout=None):
        """Wait until a specific element is visible on the page.

        Args:
            selector: The locator for the element.
            locator_type: Locator type (xpath, css, id, etc.).
            timeout: Maximum wait time in seconds.
        """
        self._get_element(selector, locator_type, timeout)
        logger.debug(f"Element visible: {selector}")

    def wait_until_element_is_not_visible(self, selector, locator_type="xpath",
                                           timeout=None):
        """Wait until a specific element is no longer visible.

        Args:
            selector: The locator for the element.
            locator_type: Locator type.
            timeout: Maximum wait time in seconds.
        """
        by, value = self._resolve_locator(selector, locator_type)
        wait = WebDriverWait(
            self.driver, timeout or self._explicit_wait
        )
        wait.until(EC.invisibility_of_element_located((by, value)))
        logger.debug(f"Element not visible: {selector}")

    def wait_until_element_is_clickable(self, selector, locator_type="xpath",
                                         timeout=None):
        """Wait until an element is clickable.

        Args:
            selector: The locator for the element.
            locator_type: Locator type.
            timeout: Maximum wait time in seconds.
        """
        by, value = self._resolve_locator(selector, locator_type)
        wait = WebDriverWait(
            self.driver, timeout or self._explicit_wait
        )
        wait.until(EC.element_to_be_clickable((by, value)))
        logger.debug(f"Element clickable: {selector}")

    def wait_until_url_contains(self, text, timeout=None):
        """Wait until the page URL contains the specified text.

        Args:
            text: The text to look for in the URL.
            timeout: Maximum wait time in seconds.
        """
        wait = WebDriverWait(
            self.driver, timeout or self._explicit_wait
        )

        def _url_contains(driver):
            return text in driver.current_url

        wait.until(_url_contains)
        logger.debug(f"URL contains: '{text}'")

    # ------------------------------------------------------------------
    # Element Interaction Keywords
    # ------------------------------------------------------------------

    def click_element(self, selector, locator_type="xpath", click_count=1):
        """Click on an element.

        Args:
            selector: The locator for the element.
            locator_type: Locator type. Default: xpath.
            click_count: Number of clicks (1=single, 2=double). Default: 1.
        """
        element = self._get_element(selector, locator_type)
        self._wait_clickable(element, selector)
        if click_count == 2:
            ActionChains(self.driver).double_click(element).perform()
            logger.debug(f"Double clicked: {selector}")
        else:
            element.click()
            logger.debug(f"Clicked: {selector}")

    def click_element_if_visible(self, selector, locator_type="xpath"):
        """Click on an element only if it is visible.

        Args:
            selector: The locator for the element.
            locator_type: Locator type. Default: xpath.

        Returns:
            bool: True if clicked, False if element was not visible.
        """
        try:
            self.wait_until_element_is_visible(selector, locator_type, timeout=3)
            self.click_element(selector, locator_type)
            return True
        except TimeoutException:
            logger.debug(f"Element not visible, skipping click: {selector}")
            return False

    def double_click_element(self, selector, locator_type="xpath"):
        """Double-click on an element.

        Args:
            selector: The locator for the element.
            locator_type: Locator type. Default: xpath.
        """
        self.click_element(selector, locator_type, click_count=2)

    def type_text(self, selector, text, locator_type="xpath", clear_first=True):
        """Type text into an input field.

        Args:
            selector: The locator for the input element.
            text: The text to type.
            locator_type: Locator type. Default: xpath.
            clear_first: Whether to clear existing text first. Default: True.
        """
        element = self._get_element(selector, locator_type)
        self._wait_clickable(element, selector)
        if clear_first:
            element.clear()
        element.send_keys(text)
        logger.debug(f"Typed '{text}' into: {selector}")

    def clear_field(self, selector, locator_type="xpath"):
        """Clear the text in an input field.

        Args:
            selector: The locator for the input element.
            locator_type: Locator type. Default: xpath.
        """
        element = self._get_element(selector, locator_type)
        element.clear()
        logger.debug(f"Cleared field: {selector}")

    def press_key(self, selector, key, locator_type="xpath"):
        """Press a key or key combination on an element.

        Args:
            selector: The locator for the element (or 'body' for global).
            key: Key to press (e.g. ENTER, TAB, ESC).
            locator_type: Locator type. Default: xpath.
        """
        if selector.lower() == "body":
            element = self.driver
        else:
            element = self._get_element(selector, locator_type)
        key_map = {
            "ENTER": Keys.RETURN,
            "RETURN": Keys.RETURN,
            "TAB": Keys.TAB,
            "ESCAPE": Keys.ESCAPE,
            "ESC": Keys.ESCAPE,
            "DELETE": Keys.DELETE,
            "BACKSPACE": Keys.BACKSPACE,
            "ARROW_UP": Keys.ARROW_UP,
            "ARROW_DOWN": Keys.ARROW_DOWN,
            "ARROW_LEFT": Keys.ARROW_LEFT,
            "ARROW_RIGHT": Keys.ARROW_RIGHT,
        }
        actual_key = key_map.get(key.upper(), Keys(key.upper()))
        element.send_keys(actual_key)
        logger.debug(f"Pressed key '{key}' on: {selector}")

    def select_dropdown_by_text(self, selector, text, locator_type="xpath"):
        """Select an option from a dropdown by its visible text.

        Args:
            selector: The locator for the <select> element.
            text: The visible text of the option to select.
            locator_type: Locator type. Default: xpath.
        """
        element = self._get_element(selector, locator_type)
        dropdown = Select(element)
        dropdown.select_by_visible_text(text)
        logger.debug(f"Selected dropdown option '{text}': {selector}")

    def select_dropdown_by_value(self, selector, value, locator_type="xpath"):
        """Select an option from a dropdown by its value attribute.

        Args:
            selector: The locator for the <select> element.
            value: The value attribute of the option.
            locator_type: Locator type. Default: xpath.
        """
        element = self._get_element(selector, locator_type)
        dropdown = Select(element)
        dropdown.select_by_value(value)
        logger.debug(f"Selected dropdown value '{value}': {selector}")

    def select_dropdown_by_index(self, selector, index, locator_type="xpath"):
        """Select an option from a dropdown by its index (0-based).

        Args:
            selector: The locator for the <select> element.
            index: The 0-based index of the option.
            locator_type: Locator type. Default: xpath.
        """
        element = self._get_element(selector, locator_type)
        dropdown = Select(element)
        dropdown.select_by_index(int(index))
        logger.debug(f"Selected dropdown index {index}: {selector}")

    def get_dropdown_options(self, selector, locator_type="xpath"):
        """Get all visible options from a dropdown.

        Args:
            selector: The locator for the <select> element.
            locator_type: Locator type. Default: xpath.

        Returns:
            list[str]: List of option text values.
        """
        element = self._get_element(selector, locator_type)
        dropdown = Select(element)
        return [opt.text for opt in dropdown.options]

    def get_dropdown_selected_option(self, selector, locator_type="xpath"):
        """Get the currently selected option from a dropdown.

        Args:
            selector: The locator for the <select> element.
            locator_type: Locator type. Default: xpath.

        Returns:
            str: The visible text of the selected option.
        """
        element = self._get_element(selector, locator_type)
        dropdown = Select(element)
        return dropdown.first_selected_option.text

    def check_checkbox(self, selector, locator_type="xpath"):
        """Check a checkbox element.

        Args:
            selector: The locator for the checkbox element.
            locator_type: Locator type. Default: xpath.
        """
        element = self._get_element(selector, locator_type)
        self._wait_clickable(element, selector)
        if not element.is_selected():
            element.click()
        logger.debug(f"Checked checkbox: {selector}")

    def uncheck_checkbox(self, selector, locator_type="xpath"):
        """Uncheck a checkbox element.

        Args:
            selector: The locator for the checkbox element.
            locator_type: Locator type. Default: xpath.
        """
        element = self._get_element(selector, locator_type)
        self._wait_clickable(element, selector)
        if element.is_selected():
            element.click()
        logger.debug(f"Unchecked checkbox: {selector}")

    def is_checkbox_checked(self, selector, locator_type="xpath"):
        """Check if a checkbox is currently checked.

        Args:
            selector: The locator for the checkbox element.
            locator_type: Locator type. Default: xpath.

        Returns:
            bool: True if checked, False otherwise.
        """
        element = self._get_element(selector, locator_type)
        return element.is_selected()

    def radio_button_select(self, selector, locator_type="xpath"):
        """Select a radio button.

        Args:
            selector: The locator for the radio button element.
            locator_type: Locator type. Default: xpath.
        """
        element = self._get_element(selector, locator_type)
        self._wait_clickable(element, selector)
        if not element.is_selected():
            element.click()
        logger.debug(f"Selected radio button: {selector}")

    def upload_file(self, selector, file_path, locator_type="xpath"):
        """Upload a file to a file input element.

        Args:
            selector: The locator for the file input element.
            file_path: Absolute or relative path to the file.
            locator_type: Locator type. Default: xpath.
        """
        element = self._get_element(selector, locator_type)
        abs_path = os.path.abspath(file_path)
        element.send_keys(abs_path)
        logger.debug(f"Uploaded file '{abs_path}' to: {selector}")

    def hover_over(self, selector, locator_type="xpath"):
        """Hover the mouse over an element.

        Args:
            selector: The locator for the element.
            locator_type: Locator type. Default: xpath.
        """
        element = self._get_element(selector, locator_type)
        ActionChains(self.driver).move_to_element(element).perform()
        logger.debug(f"Hovered over: {selector}")

    def drag_and_drop(self, source_selector, target_selector,
                       source_type="xpath", target_type="xpath"):
        """Drag and drop one element onto another.

        Args:
            source_selector: Locator for the source element.
            target_selector: Locator for the target element.
            source_type: Locator type for source. Default: xpath.
            target_type: Locator type for target. Default: xpath.
        """
        source = self._get_element(source_selector, source_type)
        target = self._get_element(target_selector, target_type)
        ActionChains(self.driver).drag_and_drop(source, target).perform()
        logger.debug(
            f"Dragged {source_selector} onto {target_selector}"
        )

    def scroll_to_element(self, selector, locator_type="xpath"):
        """Scroll the page until the element is in view.

        Args:
            selector: The locator for the element.
            locator_type: Locator type. Default: xpath.
        """
        element = self._get_element(selector, locator_type)
        self.driver.execute_script(
            "arguments[0].scrollIntoView("
            "{behavior: 'smooth', block: 'center'});"
            , element
        )
        logger.debug(f"Scrolled to: {selector}")

    def scroll_to_top(self):
        """Scroll the page to the top."""
        self.driver.execute_script("window.scrollTo(0, 0);")
        logger.debug("Scrolled to top")

    def scroll_to_bottom(self):
        """Scroll the page to the bottom."""
        self.driver.execute_script(
            "window.scrollTo(0, document.body.scrollHeight);"
        )
        logger.debug("Scrolled to bottom")

    def switch_to_window(self, window_index):
        """Switch to a browser window by its index.

        Args:
            window_index: Index of the window handle (0-based).
        """
        handles = self.driver.window_handles
        idx = int(window_index)
        if 0 <= idx < len(handles):
            self.driver.switch_to.window(handles[idx])
            logger.debug(f"Switched to window index {idx}")
        else:
            raise IndexError(
                f"Window index {idx} out of range. "
                f"Available: {len(handles)}"
            )

    def switch_to_window_by_handle(self, handle):
        """Switch to a browser window by its handle string.

        Args:
            handle: The window handle string.
        """
        self.driver.switch_to.window(handle)
        logger.debug(f"Switched to window handle: {handle}")

    def switch_to_default_content(self):
        """Switch to the main document content."""
        self.driver.switch_to.default_content()
        logger.debug("Switched to default content")

    def switch_to_frame(self, selector, locator_type="xpath"):
        """Switch to a frame or iframe element.

        Args:
            selector: The locator for the frame element.
            locator_type: Locator type. Default: xpath.
        """
        element = self._get_element(selector, locator_type)
        self.driver.switch_to.frame(element)
        logger.debug(f"Switched to frame: {selector}")

    def execute_javascript(self, javascript_code):
        """Execute JavaScript in the browser.

        Args:
            javascript_code: The JavaScript code to execute.

        Returns:
            The result of the JavaScript execution.
        """
        return self.driver.execute_script(javascript_code)

    def scroll_element_into_view(self, selector, locator_type="xpath"):
        """Scroll a specific element into the visible area.

        Args:
            selector: The locator for the element.
            locator_type: Locator type. Default: xpath.
        """
        element = self._get_element(selector, locator_type)
        self.driver.execute_script(
            "arguments[0].scrollIntoView({block: 'center'});", element
        )
        logger.debug(f"Scrolled element into view: {selector}")

    # ------------------------------------------------------------------
    # Read / Get Keywords
    # ------------------------------------------------------------------

    def get_element_text(self, selector, locator_type="xpath"):
        """Get the visible text content of an element.

        Args:
            selector: The locator for the element.
            locator_type: Locator type. Default: xpath.

        Returns:
            str: The visible text of the element.
        """
        element = self._get_element(selector, locator_type)
        return element.text

    def get_element_attribute(self, selector, attribute, locator_type="xpath"):
        """Get the value of an attribute of an element.

        Args:
            selector: The locator for the element.
            attribute: The attribute name (e.g. href, value, class).
            locator_type: Locator type. Default: xpath.

        Returns:
            str: The attribute value.
        """
        element = self._get_element(selector, locator_type)
        return element.get_attribute(attribute)

    def get_element_value(self, selector, locator_type="xpath"):
        """Get the value of an input element.

        Args:
            selector: The locator for the input element.
            locator_type: Locator type. Default: xpath.

        Returns:
            str: The value of the input element.
        """
        element = self._get_element(selector, locator_type)
        return element.get_attribute("value")

    def get_all_elements_text(self, selector, locator_type="xpath"):
        """Get the text of all matching elements.

        Args:
            selector: The locator for the elements.
            locator_type: Locator type. Default: xpath.

        Returns:
            list[str]: List of text contents.
        """
        elements = self._get_elements(selector, locator_type)
        return [el.text for el in elements]

    def get_number_of_elements(self, selector, locator_type="xpath"):
        """Get the count of elements matching a locator.

        Args:
            selector: The locator for the elements.
            locator_type: Locator type. Default: xpath.

        Returns:
            int: Number of matching elements.
        """
        elements = self._get_elements(selector, locator_type)
        return len(elements)

    def get_window_title(self):
        """Get the current window/tab title.

        Returns:
            str: The window title.
        """
        return self.driver.title

    def get_all_window_titles(self):
        """Get titles of all open browser windows/tabs.

        Returns:
            list[str]: List of window titles.
        """
        saved = self.driver.current_window_handle
        titles = []
        for handle in self.driver.window_handles:
            self.driver.switch_to.window(handle)
            titles.append(self.driver.title)
        self.driver.switch_to.window(saved)
        return titles

    def get_all_window_handles(self):
        """Get all browser window handle identifiers.

        Returns:
            list[str]: List of window handles.
        """
        return self.driver.window_handles

    def get_cookie(self, name):
        """Get a browser cookie by name.

        Args:
            name: The cookie name.

        Returns:
            dict: The cookie dictionary.
        """
        return self.driver.get_cookie(name)

    def get_all_cookies(self):
        """Get all browser cookies.

        Returns:
            list[dict]: List of all cookies.
        """
        return self.driver.get_cookies()

    # ------------------------------------------------------------------
    # Verification / Assertion Keywords
    # ------------------------------------------------------------------

    def verify_page_contains(self, text):
        """Verify that the current page contains the specified text.

        FAILS the test if the text is not found.

        Args:
            text: The text to verify on the page.
        """
        self.wait_until_page_contains(text)
        logger.info(f"Verified page contains: '{text}'")

    def verify_page_does_not_contain(self, text):
        """Verify that the current page does NOT contain the specified text.

        FAILS the test if the text is found.

        Args:
            text: The text to verify is absent from the page.
        """
        try:
            self.wait_until_page_contains(text, timeout=3)
            raise AssertionError(
                f"Page should NOT contain '{text}' but it does"
            )
        except TimeoutException:
            logger.info(f"Verified page does not contain: '{text}'")

    def verify_element_is_visible(self, selector, locator_type="xpath"):
        """Verify that an element is visible on the page.

        FAILS if the element is not visible.

        Args:
            selector: The locator for the element.
            locator_type: Locator type. Default: xpath.
        """
        self.wait_until_element_is_visible(selector, locator_type)
        logger.info(f"Verified element is visible: {selector}")

    def verify_element_is_not_visible(self, selector, locator_type="xpath"):
        """Verify that an element is NOT visible on the page.

        Args:
            selector: The locator for the element.
            locator_type: Locator type. Default: xpath.
        """
        try:
            self.wait_until_element_is_visible(
                selector, locator_type, timeout=3
            )
            raise AssertionError(
                f"Element should NOT be visible: {selector}"
            )
        except TimeoutException:
            logger.info(
                f"Verified element is not visible: {selector}"
            )

    def verify_element_contains_text(self, selector, expected_text,
                                      locator_type="xpath"):
        """Verify that an element contains the expected text.

        FAILS if the text is not found.

        Args:
            selector: The locator for the element.
            expected_text: The expected text content.
            locator_type: Locator type. Default: xpath.
        """
        element = self._get_element(selector, locator_type)
        actual_text = element.text
        if expected_text.lower() not in actual_text.lower():
            raise AssertionError(
                f"Expected element to contain '{expected_text}', "
                f"but got '{actual_text}'"
            )
        logger.info(
            f"Verified element contains text "
            f"'{expected_text}': {selector}"
        )

    def verify_page_title(self, expected_title):
        """Verify that the page title matches the expected value.

        FAILS if the title does not match.

        Args:
            expected_title: The expected page title
                            (case-insensitive partial match).
        """
        actual = self.get_page_title()
        if expected_title.lower() not in actual.lower():
            raise AssertionError(
                f"Expected page title to contain '{expected_title}', "
                f"but got '{actual}'"
            )
        logger.info(
            f"Verified page title contains '{expected_title}'"
        )

    def verify_url_contains(self, expected_url_part):
        """Verify that the current URL contains the expected substring.

        Args:
            expected_url_part: The expected substring in the URL.
        """
        current = self.get_current_url()
        if expected_url_part not in current:
            raise AssertionError(
                f"Expected URL to contain '{expected_url_part}', "
                f"but got '{current}'"
            )
        logger.info(
            f"Verified URL contains '{expected_url_part}'"
        )

    def verify_checkbox_is_checked(self, selector, locator_type="xpath"):
        """Verify that a checkbox is checked.

        Args:
            selector: The locator for the checkbox.
            locator_type: Locator type. Default: xpath.
        """
        checked = self.is_checkbox_checked(selector, locator_type)
        if not checked:
            raise AssertionError(
                f"Checkbox should be checked: {selector}"
            )
        logger.info(f"Verified checkbox is checked: {selector}")

    def verify_element_attribute(self, selector, attribute,
                                  expected_value, locator_type="xpath"):
        """Verify that an element attribute has the expected value.

        Args:
            selector: The locator for the element.
            attribute: The attribute name.
            expected_value: The expected attribute value.
            locator_type: Locator type. Default: xpath.
        """
        actual = self.get_element_attribute(
            selector, attribute, locator_type
        )
        if str(actual) != str(expected_value):
            raise AssertionError(
                f"Expected attribute '{attribute}' to be "
                f"'{expected_value}', but got '{actual}'"
            )
        logger.info(
            f"Verified attribute '{attribute}' = '{expected_value}': "
            f"{selector}"
        )

    def verify_dropdown_selected_option(self, selector, expected_text,
                                         locator_type="xpath"):
        """Verify that a dropdown has the expected option selected.

        Args:
            selector: The locator for the select element.
            expected_text: The expected selected option text.
            locator_type: Locator type. Default: xpath.
        """
        actual = self.get_dropdown_selected_option(
            selector, locator_type
        )
        if expected_text.lower() not in actual.lower():
            raise AssertionError(
                f"Expected dropdown to show '{expected_text}', "
                f"but got '{actual}'"
            )
        logger.info(
            f"Verified dropdown selected option "
            f"'{expected_text}': {selector}"
        )

    def verify_element_count(self, selector, expected_count,
                              locator_type="xpath"):
        """Verify that the number of matching elements equals expected count.

        Args:
            selector: The locator for the elements.
            expected_count: The expected number of elements.
            locator_type: Locator type. Default: xpath.
        """
        actual = self.get_number_of_elements(selector, locator_type)
        if actual != expected_count:
            raise AssertionError(
                f"Expected {expected_count} elements, "
                f"but found {actual}"
            )
        logger.info(
            f"Verified element count = {expected_count}: {selector}"
        )

    def verify_text_is_not_present(self, text):
        """Verify that text is NOT present on the page.

        Args:
            text: The text to verify is absent.
        """
        try:
            self.wait_until_page_contains(text, timeout=2)
            raise AssertionError(
                f"Text '{text}' should not be on the page"
            )
        except TimeoutException:
            logger.info(f"Verified text is absent: '{text}'")

    # ------------------------------------------------------------------
    # Utility Keywords
    # ------------------------------------------------------------------

    def take_screenshot(self, filename=None):
        """Take a screenshot of the current browser window.

        Args:
            filename: Custom filename (without extension).

        Returns:
            str: The full path to the saved screenshot.
        """
        if filename is None:
            timestamp = datetime.now().strftime(
                "%Y%m%d_%H%M%S"
            )
            filename = f"screenshot_{timestamp}"
        output_dir = "output/screenshots"
        Path(output_dir).mkdir(parents=True, exist_ok=True)
        self.driver.save_screenshot(
            f"{output_dir}/{filename}.png"
        )
        logger.info(f"Screenshot saved: {filename}.png")
        return f"{output_dir}/{filename}.png"

    def take_screenshot_on_failure(self):
        """Take a screenshot if the current test has failed."""
        try:
            self.take_screenshot()
        except Exception as exc:
            logger.warn(
                f"Could not take screenshot on failure: {exc}"
            )

    def log(self, message, level="INFO"):
        """Log a message with the specified level.

        Args:
            message: The message to log.
            level: Logging level (DEBUG, INFO, WARN, ERROR).
        """
        log_func = getattr(logger, level.lower(), logger.info)
        log_func(message)

    def set_implicit_wait(self, seconds):
        """Set the implicit wait timeout for element searches.

        Args:
            seconds: The timeout in seconds.
        """
        self._implicit_wait = int(seconds)
        if self._driver is not None:
            self._driver.implicitly_wait(self._implicit_wait)
        logger.info(
            f"Implicit wait set to {seconds} seconds"
        )

    def set_explicit_wait(self, seconds):
        """Set the explicit wait timeout for wait keywords.

        Args:
            seconds: The timeout in seconds.
        """
        self._explicit_wait = int(seconds)
        logger.info(
            f"Explicit wait set to {seconds} seconds"
        )

    def get_screen_elements_count(self, tag_name):
        """Count how many elements of a given tag exist on the page.

        Args:
            tag_name: HTML tag name (e.g. 'a', 'div', 'input').

        Returns:
            int: Number of elements of that tag type.
        """
        elements = self._get_elements(
            f"tag:{tag_name}", "css"
        )
        return len(elements)

    def capture_screenshot_and_log(self, description):
        """Take a screenshot and log the description.

        Args:
            description: Description of what the screenshot captures.

        Returns:
            str: Path to the screenshot file.
        """
        path = self.take_screenshot()
        self.log(
            f"Screenshot captured: "
            f"{description} -> {path}"
        )
        return path
