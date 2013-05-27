@echo off

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Configure git
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
set git_upstream_repository=upstream
set git_upstream_branch=develop-olympus
set git_origin_repository=origin
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

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
set GIT_EXE=%ProgramFiles(x86)%\Git\bin\git.exe
if exist "%GIT_EXE%" goto help

set GIT_EXE=%ProgramFiles%\Git\bin\git.exe
if exist "%GIT_EXE%" goto help

echo Could not find your git.exe

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:help
echo.
echo ==========================
echo =   phpBB Merger         =
echo ==========================
echo git.exe:               %GIT_EXE%
echo phpBB Root:            %FORK_ROOT_PATH%
echo phpBB Repository:      %git_upstream_repository%
echo Your Repository:       %git_origin_repository%
echo.

:fetch_author
echo ===========================================================================
echo Merge branch from following remote repository (author):
SET /P git_author_repository=$ 

:: Fetch authors repository, so we have the newest commits
call "%GIT_EXE%" fetch %git_author_repository%
echo.

:fetch_author
echo ===========================================================================
echo Merge following branch from %git_author_repository%:
SET /P git_author_branch=$ 
echo.

:merge_into
echo ===========================================================================
echo Merge branch into branch [%git_upstream_branch%]:
SET /P git_merge_into_branch=$ 

if "%git_merge_into_branch%" == "" set git_merge_into_branch=%git_upstream_branch%

if "%git_merge_into_branch%" == "develop" goto merge_develop
if "%git_merge_into_branch%" == "d" goto merge_develop
if "%git_merge_into_branch%" == "develop-ascraeus" goto merge_develop_ascraeus
if "%git_merge_into_branch%" == "ascraeus" goto merge_develop_ascraeus
if "%git_merge_into_branch%" == "a" goto merge_develop_ascraeus
if "%git_merge_into_branch%" == "develop-olympus" goto merge_develop_olympus
if "%git_merge_into_branch%" == "olympus" goto merge_develop_olympus
if "%git_merge_into_branch%" == "o" goto merge_develop_olympus
echo.

echo ===========================================================================
echo Error: Can only merge into develop/develop-ascraeus/develop-olympus!
echo.

goto help

:merge_develop_ascraeus
:merge_develop
echo ===========================================================================
echo  Merging "%git_author_repository%/%git_author_branch%" into "develop" [y]:
SET /P git_confirm=$ 

if not "%git_confirm%" == "y" goto help

:: Push changes to origin
call "%GIT_EXE%" remote update %git_upstream_repository%
call "%GIT_EXE%" checkout develop
call "%GIT_EXE%" reset --hard %git_upstream_repository%/develop
call "%GIT_EXE%" merge --no-ff %git_author_repository%/%git_author_branch%
call "%GIT_EXE%" push %git_origin_repository% develop
echo.

:merge_develop2
echo ===========================================================================
echo Changes pushed to "%git_origin_repository%/develop", please check the changes, before merging into "%git_upstream_repository%/develop" [y]:
SET /P git_confirm=$ 

if not "%git_confirm%" == "y" goto merge_develop2

:: Push changes to upstream
call "%GIT_EXE%" push %git_upstream_repository% develop
echo.

echo ===========================================================================
echo Successfully merged into "%git_upstream_repository%/develop"!
echo.
goto help


:merge_develop_olympus
echo ===========================================================================
echo Merging "%git_author_repository%/%git_author_branch%" into "develop-olympus" [y]:
SET /P git_confirm=$ 

if not "%git_confirm%" == "y" goto help

:: Push changes to origin
call "%GIT_EXE%" remote update %git_upstream_repository%
call "%GIT_EXE%" checkout develop-olympus
call "%GIT_EXE%" reset --hard %git_upstream_repository%/develop-olympus
call "%GIT_EXE%" merge --no-ff %git_author_repository%/%git_author_branch%
call "%GIT_EXE%" push %git_origin_repository% develop-olympus

:: Merge Olympus into Develop
call "%GIT_EXE%" checkout develop
call "%GIT_EXE%" reset --hard %git_upstream_repository%/develop
call "%GIT_EXE%" merge --no-ff develop-olympus
call "%GIT_EXE%" push %git_origin_repository% develop
echo.

:merge_develop_olympus2
echo ===========================================================================
echo Changes pushed to "%git_origin_repository%/develop-olympus", please check the changes, before merging into "%git_upstream_repository%/develop-olympus" [y]:
SET /P git_confirm=$ 

if not "%git_confirm%" == "y" goto merge_develop_olympus2

:: Push changes to upstream
call "%GIT_EXE%" push %git_upstream_repository% develop-olympus
call "%GIT_EXE%" push %git_upstream_repository% develop
echo.

echo ===========================================================================
echo Successfully merged into "%git_upstream_repository%/develop-olympus"!
echo.
goto help


:end
