@echo off

set FORK_ROOT_PATH=%CD%\

if exist %FORK_ROOT_PATH%phpBB\viewtopic.php goto configure
if exist %FORK_ROOT_PATH%viewtopic.php goto configure_root

SET /P phpbb_vendor=Please move the .bat to the root of your phpBB installation! 
goto end

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Configure some paths
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:configure_root
SET FORK_ROOT_PATH=%FORK_ROOT_PATH%..\

:configure
call %FORK_ROOT_PATH:~0,2%
cd %FORK_ROOT_PATH%phpBB\

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
echo =   phpBB Vendor Update                                           =
echo ===================================================================
echo.
echo     dev              Install vendors for development
echo     install          Install vendors for productive
echo     update           Update all vendors
echo     end/exit/stop    End script
echo.

:rerun
echo ===================================================================
echo Type [dev/install/update/help/exit]:
SET phpbb_vendor=
SET /P phpbb_vendor=$ 

if "%phpbb_vendor%" == "dev" goto install_dev_vendors
if "%phpbb_vendor%" == "install" goto install_vendors
if "%phpbb_vendor%" == "update" goto update_vendors
if "%phpbb_vendor%" == "help" goto help
if "%phpbb_vendor%" == "end" goto end
if "%phpbb_vendor%" == "exit" goto end
if "%phpbb_vendor%" == "stop" goto end

:install_dev_vendors
echo.
echo Install development vendors:
echo ============================
echo.
call "E:/phpBB-development/php/php.exe" ../composer.phar --dev install
echo.
echo ==================
echo Installed vendors!
echo.
goto rerun

:install_vendors
echo.
echo Install productive vendors:
echo ===========================
echo.
call "E:/phpBB-development/php/php.exe" ../composer.phar install
echo.
echo ==================
echo Installed vendors!
echo.
goto rerun

:end_purge

:update_vendors
echo.
echo Update vendors:
echo ===============
echo.
call "E:/phpBB-development/php/php.exe" ../composer.phar update
echo.
echo ================
echo Updated vendors!
echo.
goto rerun

:end
@set PATH=%ORIGINAL_PATH%
@endlocal
