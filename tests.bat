@echo off

set FORK_ROOT_PATH=%CD%\

if exist %FORK_ROOT_PATH%phpBB\viewtopic.php goto configure
if exist %FORK_ROOT_PATH%viewtopic.php goto configure_root

SET /P phpbb_running_unit_tests=Please move the .bat to the root of your phpBB installation! 
goto end

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Configure some paths
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:configure_root
SET FORK_ROOT_PATH=%FORK_ROOT_PATH%..\

:configure
set PHPUNIT_PATH=%FORK_ROOT_PATH%\phpBB\vendor\bin\phpunit
call %FORK_ROOT_PATH:~0,2%
cd %FORK_ROOT_PATH%

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
echo ==========================
echo =   phpBB Unit Testing   =
echo ==========================
echo.
echo End script:            end
echo Run slow tests:        slow
echo Run functional tests:  functional
echo Run file tests:        LinkToFile
echo Run tests normal:      all
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
goto test_end

:all_tests
echo.
echo Running tests:
echo ==============
echo.
call "%PHPUNIT_PATH%"
goto test_end

:slow_tests
echo.
echo Running slow tests:
echo ===================
echo.
call "%PHPUNIT_PATH%" --group slow
goto test_end

:functional_file_tests
echo.
echo Running functional tests:
echo =========================
echo File: %phpbb_running_unit_tests%
echo.
call "%PHPUNIT_PATH%" -c phpunit.xml.functional %phpbb_running_unit_tests%
goto test_end

:functional_tests
echo.
echo Running functional tests:
echo =========================
echo.
call "%PHPUNIT_PATH%" -c phpunit.xml.functional
goto test_end

:test_end
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
