@echo off

set FORK_ROOT_PATH=%CD%\

if exist %FORK_ROOT_PATH%phpBB\viewtopic.php goto configure
if exist %FORK_ROOT_PATH%viewtopic.php goto configure_root

SET /P phpbb_purge_cache=Please move the .bat to the root of your phpBB installation! 
goto end

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Configure some paths
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:configure_root
SET FORK_ROOT_PATH=%FORK_ROOT_PATH%..\

:configure
call %FORK_ROOT_PATH:~0,2%
cd %FORK_ROOT_PATH%

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:help
echo.
echo ==========================
echo =   phpBB purge cache/   =
echo ==========================
echo.
echo End script:            end/exit/stop
echo Purge cache:           *
echo.

:rerun
echo ===========================================================================
echo Type [help/exit], anything else will purge cache/:
SET phpbb_purge_cache=
SET /P phpbb_purge_cache=$ 

if "%phpbb_purge_cache%" == "help" goto help
if "%phpbb_purge_cache%" == "end" goto end
if "%phpbb_purge_cache%" == "exit" goto end
if "%phpbb_purge_cache%" == "stop" goto end

:purge
echo.
echo Purging cache:
echo ==============
echo.
echo %FORK_ROOT_PATH%phpBB\cache\*.php
echo %FORK_ROOT_PATH%phpBB\cache\*.php.lock
echo.
for %%A in (phpBB\cache\*.php) do (
	echo %%A
	del %%A
)
for %%A in (phpBB\cache\*.php.lock) do (
	echo %%A
	del %%A
)
echo.
echo Purge successful!
echo =================
echo.
goto rerun

:end
