# SeleniumProjectmigration

**Migrated from Selenium (Java/Python) → Robot Framework**

A complete Robot Framework test automation project following LocalTapiola (LT) Test Automation Guidelines and Strategy 2025-2026. This project demonstrates a full migration from Selenium-based test automation to Robot Framework, adhering to best practices including Page Object Model (POM), externalized test data in YAML, and centralized locator management.

## 📋 Table of Contents

- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Installation](#installation)
- [Configuration](#configuration)
- [Running Tests](#running-tests)
- [Test Suites](#test-suites)
- [Best Practices](#best-practices)

## Prerequisites

| Software | Version | Notes |
|----------|---------|-------|
| Python | 3.10+ | Required for Robot Framework |
| Chrome / Chromium | Latest | WebDriver driver |

### Install Required Libraries

```bash
# Install all Python dependencies
pip install -r requirements.txt

# Install this project in editable mode (required so CustomLibrary is findable)
pip install -e .
```

## Project Structure

```
SeleniumProjectmigration/
├── README.md                      # This file
├── requirements.txt               # Python dependencies
├── pyproject.toml                 # Project configuration (includes setuptools)
├── .gitignore                     # Git ignore rules
├── run_tests.sh                   # Shell script to run tests (Linux/Mac)
├── run_tests.bat                  # Batch script to run tests (Windows)
├── robot.cfg                      # Auto-sets pythonpath for robot
├── CustomLibrary.py               # Root-level wrapper for robot imports
│
├── libraries/                     # Custom Python library
│   ├── __init__.py
│   └── CustomLibrary.py           # Custom Robot Framework keywords (PEP 8)
│
├── resources/                     # Robot Framework resource files (Page Objects)
│   ├── SharedSettings.resource    # Suite setup/teardown, common utilities
│   ├── LoginPage.resource         # Login page object keywords
│   ├── HomePage.resource          # Home page object keywords
│   ├── NavigationPage.resource    # Navigation keywords
│   ├── FormPage.resource          # Form interaction keywords
│   └── BasePage.resource          # Base page utilities
│
├── testdata/                      # YAML test data files
│   ├── users.yaml                 # Test user credentials
│   ├── locators.yaml              # All element locators (XPATH/CSS)
│   ├── config.yaml                # Environment & execution config
│   └── scenarios.yaml             # Test scenario definitions
│
├── tests/                         # Robot Framework test cases
│   ├── __init__.robot             # Top-level suite
│   ├── main_suite_runner.robot    # Main suite entry point
│   ├── login/
│   │   ├── __init__.robot         # Suite setup/teardown (defines Open/Close Browser)
│   │   └── login_test_suite.robot
│   ├── navigation/
│   │   ├── __init__.robot
│   │   └── navigation_test_suite.robot
│   ├── forms/
│   │   ├── __init__.robot
│   │   └── form_test_suite.robot
│   └── verification/
│       ├── __init__.robot
│       └── verification_test_suite.robot
```

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/ParasuChandru/SeleniumProjectmigration.git
cd SeleniumProjectmigration
```

### 2. Install Dependencies

```bash
# Install Python packages
pip install -r requirements.txt

# Install this project in editable mode (REQUIRED - makes CustomLibrary findable)
pip install -e .
```

### 3. Verify Installation

```bash
robot --version
pip show selenium-project-migration
```

## Configuration

### Environment Configuration

Edit `testdata/config.yaml` to set environment-specific values.

### Browser Configuration

```bash
# Headed Chrome (for debugging)
robot --variable HEADLESS:false tests/

# Firefox
robot --variable BROWSER:firefox tests/
```

## Running Tests

### IMPORTANT: Install the project first!

Run `pip install -e .` once. This installs the `libraries` package into your Python environment so Robot Framework can find `CustomLibrary` from any directory.

```bash
pip install -e .
```

### Run All Tests

```bash
# Run the entire test suite
robot tests/

# Run with verbose output
robot --verbose tests/

# Run with custom output directory
robot --outputdir results tests/
```

### Run Specific Test Suites

```bash
# Run only login tests
robot tests/login/login_test_suite.robot

# Run only navigation tests
robot tests/navigation/navigation_test_suite.robot

# Run only form tests
robot tests/forms/form_test_suite.robot

# Run only verification tests
robot tests/verification/verification_test_suite.robot
```

### Run with Tags (Filtering)

```bash
# Run only smoke tests
robot --tag smoke tests/

# Run only negative test cases
robot --tag negative tests/

# Run security tests
robot --tag security tests/

# Run only regression tests
robot --tag regression tests/

# Run specific test case
robot --test "Login With Valid Admin Credentials" tests/
```

### Using the Run Scripts

**Linux / Mac:**

```bash
chmod +x run_tests.sh
./run_tests.sh                    # Run all tests
./run_tests.sh login              # Run login tests only
./run_tests.sh sit                # Run against SIT environment
./run_tests.sh --tag smoke        # Run only smoke tests
```

**Windows:**

```batch
run_tests.bat                    # Run all tests
run_tests.bat login              # Run login tests only
run_tests.bat sit                # Run against SIT environment
run_tests.bat --tag smoke        # Run only smoke tests
```

## Test Suites

### 1. Login Test Suite (`tests/login/`)

Tests for authentication functionality:

| Test Case | Tags | Description |
|-----------|------|-------------|
| Login With Valid Admin Credentials | login, smoke, admin, regression | Admin user login |
| Login With Valid Regular User Credentials | login, smoke, user, regression | Regular user login |
| Login With Valid Premium User Credentials | login, premium, user, regression | Premium user login |
| Login With Valid Limited User Credentials | login, limited, user, regression | Limited user login |
| Login With Wrong Password | login, negative, validation | Wrong password scenario |
| Login With Nonexistent User | login, negative, validation | Nonexistent user scenario |
| Login With Empty Username | login, negative, validation, empty-field | Empty username |
| Login With Empty Password | login, negative, validation, empty-field | Empty password |
| Login With Locked Account | login, negative, locked-account | Locked account |
| Login With Expired Account | login, negative, expired-account | Expired account |
| Login With SQL Injection Username | login, security, sql-injection, negative | SQL injection attempt |
| Login With XSS Payload Username | login, security, xss, negative | XSS attempt |
| Login With Very Long Username | login, negative, edge-case | Long username |

### 2. Navigation Test Suite (`tests/navigation/`)

Tests for application navigation:

| Test Case | Tags | Description |
|-----------|------|-------------|
| Navigate To Home Page | navigation, home, regression | Home page navigation |
| Navigate To Settings Page | navigation, settings | Settings navigation |
| Navigate To Profile Page | navigation, profile | Profile navigation |
| Navigate To Dashboard | navigation, dashboard, regression | Dashboard navigation |
| Navigate To Reports Page | navigation, reports | Reports navigation |

### 3. Form Test Suite (`tests/forms/`)

Tests for form interactions:

| Test Case | Tags | Description |
|-----------|------|-------------|
| Fill Text Field Correctly | form, text-input, validation | Text input |
| Fill Email Field With Valid Email | form, email, validation | Valid email |
| Fill Email Field With Invalid Email | form, email, validation, negative | Invalid email |
| Fill Textarea Field | form, textarea, validation | Textarea input |
| Select Dropdown By Text | form, dropdown, validation | Dropdown select by text |
| Select Dropdown By Value | form, dropdown, validation | Dropdown select by value |
| Select Dropdown By Index | form, dropdown, validation | Dropdown select by index |
| Check And Uncheck Checkbox | form, checkbox, validation | Checkbox toggle |
| Select Radio Button | form, radio, validation | Radio button select |
| Submit Form With Valid Data | form, submit, positive, regression | Valid form submission |
| Submit Form With Empty Required Fields | form, submit, validation, negative | Empty required fields |
| Clear And Retype In Field | form, text-input, clear | Clear and retype |
| Upload File To Form | form, file-upload, validation | File upload |
| Press Enter In Input Field | form, keyboard, validation | Keyboard input |

### 4. Verification Test Suite (`tests/verification/`)

Tests for UI verification and validation:

| Test Case | Tags | Description |
|-----------|------|-------------|
| Verify Login Page Elements Present | verification, login, ui, regression | Login page elements |
| Verify Home Page Loaded Correctly | verification, home, ui, regression | Home page elements |
| Verify Dashboard Contains Expected Elements | verification, dashboard, ui | Dashboard elements |
| Verify Page Title Format | verification, title, ui | Page title |
| Verify Navigation Menu Items Present | verification, navigation, ui | Navigation menu |

## Best Practices

### Following LT Test Automation Guidelines

| Guideline | Implementation |
|-----------|---------------|
| **Page Object Model (POM)** | All page interactions in `.resource` files |
| **No hardcoded values** | All locators in `testdata/locators.yaml` |
| **No sleeps** | Dynamic waits used throughout |
| **Test independence** | Each test is independent |
| **Descriptive names** | Title Case naming conventions |
| **Test data separation** | Test data in YAML files |
| **Documentation** | Every suite, keyword, and test documented |

### Locator Strategy

All locators stored in `testdata/locators.yaml`:

```yaml
login_button:
  selector: "id=login-btn"
  type: "css"

login_button_alt:
  selector: "//button[contains(@type, 'submit') or contains(text(), 'Login')]"
  type: "xpath"
```

## License

This project is for internal testing purposes.
