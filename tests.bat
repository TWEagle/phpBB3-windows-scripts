@echo off

set FORK_ROOT_PATH=%CD%\
set TEST_ROOT_PATH=%CD%\

:: Try to find viewtopic.php
if exist %FORK_ROOT_PATH%phpBB\viewtopic.php goto configure_phpunit_xml
set ROOT_TESTS=0

:root_level_up
set FORK_ROOT_PATH=%FORK_ROOT_PATH%..\
set ROOT_TESTS=%ROOT_TESTS%+1
if %ROOT_TESTS% == "25" goto root_level_end
if not exist %FORK_ROOT_PATH%phpBB\viewtopic.php goto root_level_up

if exist %FORK_ROOT_PATH%phpBB\viewtopic.php goto configure_phpunit_xml

:root_level_end
SET /P phpbb_running_unit_tests=Please move the .bat to the root of your phpBB installation! 
goto end

:configure_phpunit_xml
:: Try to find phpunit.xml.dist
if exist %TEST_ROOT_PATH%phpunit.xml.dist goto configure
set TEST_ROOT_TESTS=0

:phpunit_xml_level_up
set TEST_ROOT_PATH=%TEST_ROOT_PATH%..\
set TEST_ROOT_TESTS=%TEST_ROOT_TESTS%+1
if %TEST_ROOT_TESTS% == "25" goto root_level_end
if not exist %TEST_ROOT_PATH%phpunit.xml.dist goto root_level_up

if exist %TEST_ROOT_PATH%phpunit.xml.dist goto configure

:phpunit_xml_level_end
SET /P phpbb_running_unit_tests=Please move the .bat to the root of your phpBB installation! 
goto end

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Configure some paths
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:configure
set PHPUNIT_PATH=%FORK_ROOT_PATH%phpBB\vendor\bin\phpunit
call %TEST_ROOT_PATH:~0,2%
cd %TEST_ROOT_PATH%

:: If your PATH does already contain your php dir, uncomment the next line
:: goto help

set PHP_PATH=%FORK_ROOT_PATH%
set PHP_TESTS=0

:: Try to find php.exe
:php_level_up
set PHP_PATH=%PHP_PATH%..\
set PHP_TESTS=%PHP_TESTS%+1
if %PHP_TESTS% == "25" goto php_level_end
if not exist %PHP_PATH%php\php.exe goto php_level_up

set PHP_PATH=%PHP_PATH%php
set ORIGINAL_PATH=%PATH%

@setlocal
@set PATH=%ORIGINAL_PATH%;%PHP_PATH%
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:help
echo.
echo ===================================================================
echo =   phpBB Unit Testing                                            =
echo ===================================================================
echo.
echo     [file]           Insert file to run tests of one file only
echo     functional       Run functional test group
echo     slow             Run slow test group
echo     all              Run all tests
echo     end/exit/stop    End script
echo.

:rerun_tests
echo ===========================================================================
echo Insert file, type [slow/functional/all/help/exit] or leave empty to repeat:
SET /P phpbb_running_unit_tests=$ 

if "%phpbb_running_unit_tests%" == "slow" goto slow_tests
if "%phpbb_running_unit_tests%" == "functional" goto functional_tests
if "%phpbb_running_unit_tests%" == "" goto all_tests
if "%phpbb_running_unit_tests%" == "all" goto all_tests
if "%phpbb_running_unit_tests%" == "help" goto help
if "%phpbb_running_unit_tests%" == "end" goto end
if "%phpbb_running_unit_tests%" == "exit" goto end
if "%phpbb_running_unit_tests%" == "stop" goto end

:file_tests
if not x%phpbb_running_unit_tests:functional=% == x%phpbb_running_unit_tests% goto functional_file_tests

:normal_file_tests
echo.
echo Running tests:
echo ==============
echo File: %phpbb_running_unit_tests%
echo.
call "%PHPUNIT_PATH%" %phpbb_running_unit_tests%
goto tests_finished

:all_tests
echo.
echo Running tests:
echo ==============
echo.
call "%PHPUNIT_PATH%"
goto tests_finished

:slow_tests
echo.
echo Running slow tests:
echo ===================
echo.
call "%PHPUNIT_PATH%" --group slow
goto tests_finished

:functional_file_tests
echo.
echo Running functional tests:
echo =========================
echo File: %phpbb_running_unit_tests%
echo.
call "%PHPUNIT_PATH%" -c phpunit.xml.functional %phpbb_running_unit_tests%
goto tests_finished

:functional_tests
echo.
echo Running functional tests:
echo =========================
echo.
call "%PHPUNIT_PATH%" -c phpunit.xml.functional
goto tests_finished

:tests_finished
echo.
echo ==========================
echo Testing finished!
echo.
goto rerun_tests

:php_level_end
echo Could not find your php.exe
goto end

:end
@set PATH=%ORIGINAL_PATH%
@endlocal
