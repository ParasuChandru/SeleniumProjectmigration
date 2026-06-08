@echo off
REM run_tests.bat - Robot Framework Test Runner Script for Windows
REM Usage: run_tests.bat [options]

set ENVIRONMENT=%ENVIRONMENT:dev%
set BASE_URL=%BASE_URL:https://dev.example.com%
set BROWSER=%BROWSER:chrome%
set HEADLESS=%HEADLESS:true%
set TEST_DIR=tests
set OUTPUT_DIR=output

REM Parse arguments
:loop
if "%~1"=="" goto :run
if "%~1"=="login" (
    set TEST_DIR=tests\login\login_test_suite.robot
) else if "%~1"=="navigation" (
    set TEST_DIR=tests\navigation\navigation_test_suite.robot
) else if "%~1"=="forms" (
    set TEST_DIR=tests\forms\form_test_suite.robot
) else if "%~1"=="verification" (
    set TEST_DIR=tests\verification\verification_test_suite.robot
) else if "%~1"=="sit" (
    set ENVIRONMENT=sit
    set BASE_URL=https://sit.example.com
) else if "%~1"=="sit2" (
    set ENVIRONMENT=sit2
    set BASE_URL=https://sit2.example.com
) else if "%~1"=="uat" (
    set ENVIRONMENT=uat
    set BASE_URL=https://uat.example.com
) else if "%~1"=="--help" (
    echo Usage: run_tests.bat [options]
    echo Options:
    echo   login           Run login tests only
    echo   navigation      Run navigation tests only
    echo   forms           Run form tests only
    echo   verification    Run verification tests only
    echo   sit             Run against SIT environment
    echo   sit2            Run against SIT2 environment
    echo   uat             Run against UAT environment
    echo   --help          Show this help message
    goto :end
)
shift /1
goto :loop

:run
echo ============================================
echo   Robot Framework Test Runner (Windows)
echo ============================================
echo Environment:    %ENVIRONMENT%
echo Base URL:       %BASE_URL%
echo Browser:        %BROWSER%
echo Headless:       %HEADLESS%
echo Test Directory: %TEST_DIR%
echo ============================================

if not exist "%OUTPUT_DIR%\screenshots" mkdir "%OUTPUT_DIR%\screenshots"

robot ^
    --pythonpath . ^
    --variable "ENVIRONMENT:%ENVIRONMENT%" ^
    --variable "BASE_URL:%BASE_URL%" ^
    --variable "BROWSER:%BROWSER%" ^
    --variable "HEADLESS:%HEADLESS%" ^
    --outputdir "%OUTPUT_DIR%" ^
    "%TEST_DIR%"

echo ============================================
echo   Test execution complete!
echo   Results: %OUTPUT_DIR%\log.html
echo ============================================

:end
