@echo off

set FORK_ROOT_PATH=%CD%\

:: Try to find viewtopic.php
if exist %FORK_ROOT_PATH%phpBB\viewtopic.php goto configure
set ROOT_TESTS=0

:root_level_up
set FORK_ROOT_PATH=%FORK_ROOT_PATH%..\
set ROOT_TESTS=%ROOT_TESTS%+1
if %ROOT_TESTS% == "25" goto root_level_end
if not exist %FORK_ROOT_PATH%phpBB\viewtopic.php goto root_level_up

if exist %FORK_ROOT_PATH%phpBB\viewtopic.php goto configure

:root_level_end
SET /P phpbb_purge_cache=Please move the .bat to the root of your phpBB installation! 
goto end

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Configure some paths
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:configure
call %FORK_ROOT_PATH:~0,2%
cd %FORK_ROOT_PATH%

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:help
echo.
echo ===================================================================
echo =   phpBB purge cache/                                            =
echo ===================================================================
echo.
echo     data             Purge all data files
echo     sql              Purge all SQL files
echo     tpl              Purge all template files
echo     end/exit/stop    End script
echo     *                Everything else will purge all files
echo.

:rerun
echo ===================================================================
echo Type [data/tpl/sql/all/help/exit], anything else will purge cache/:
SET phpbb_purge_cache=
SET /P phpbb_purge_cache=$ 

if "%phpbb_purge_cache%" == "data" goto purge_data
if "%phpbb_purge_cache%" == "sql" goto purge_sql
if "%phpbb_purge_cache%" == "tpl" goto purge_tpl
if "%phpbb_purge_cache%" == "help" goto help
if "%phpbb_purge_cache%" == "end" goto end
if "%phpbb_purge_cache%" == "exit" goto end
if "%phpbb_purge_cache%" == "stop" goto end

:purge_all
echo.
echo Purging cache:
echo ==============
echo.
for %%A in (phpBB\cache\*.php) do (
	echo %%A
	del %%A
)
for %%A in (phpBB\cache\*.php.lock) do (
	echo %%A
	del %%A
)
goto end_purge

:purge_data
echo.
echo Purging data files:
echo ===================
echo.
for %%A in (phpBB\cache\data_*.php) do (
	echo %%A
	del %%A
)
for %%A in (phpBB\cache\data_*.php.lock) do (
	echo %%A
	del %%A
)

:purge_container_dotslash
if not exist %FORK_ROOT_PATH%phpBB\cache\container_dotslash.php goto purge_url_matcher
echo phpBB\cache\container_dotslash.php
del phpBB\cache\container_dotslash.php

:purge_url_matcher
if not exist %FORK_ROOT_PATH%phpBB\cache\url_matcher.php goto end_purge
echo phpBB\cache\url_matcher.php
del phpBB\cache\url_matcher.php

goto end_purge

:purge_sql
echo.
echo Purging SQL files:
echo ==================
echo.
for %%A in (phpBB\cache\sql_*.php) do (
	echo %%A
	del %%A
)
for %%A in (phpBB\cache\sql_*.php.lock) do (
	echo %%A
	del %%A
)
goto end_purge

:purge_tpl
echo.
echo Purging template files:
echo =======================
echo.
:: Basic template
for %%A in (phpBB\cache\tpl_*.php) do (
	echo %%A
	del %%A
)
for %%A in (phpBB\cache\tpl_*.php.lock) do (
	echo %%A
	del %%A
)

:: Custom templates
for %%A in (phpBB\cache\tpl_*.php) do (
	echo %%A
	del %%A
)
for %%A in (phpBB\cache\tpl_*.php.lock) do (
	echo %%A
	del %%A
)
goto end_purge

:end_purge
echo.
echo =================
echo Purge successful!
echo.
goto rerun

:end
