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
echo.

echo ===========================================================================
echo Fetching branches from "%git_author_repository%"
echo.
call "%GIT_EXE%" fetch %git_author_repository%
if %ERRORLEVEL% GEQ 1 echo.
if %ERRORLEVEL% GEQ 1 echo Could not find author remote!
if %ERRORLEVEL% GEQ 1 echo.
if %ERRORLEVEL% GEQ 1 goto fetch_author
echo.

:fetch_author_branch
echo ===========================================================================
echo Merge following branch from %git_author_repository%:
SET /P git_author_branch=$ 
echo.

echo ===========================================================================
echo HEAD of "%git_author_branch%" is
echo.
call "%GIT_EXE%" ls-remote --exit-code %git_author_repository% %git_author_branch%
if %ERRORLEVEL% GEQ 1 echo Could not find remote branch!
if %ERRORLEVEL% GEQ 1 echo.
if %ERRORLEVEL% GEQ 1 goto fetch_author_branch
echo.

:merge_into
echo ===========================================================================
echo Merge branch into branch [%git_upstream_branch%]:
SET git_merge_into_branch=
SET /P git_merge_into_branch=$ 
echo.

if "%git_merge_into_branch%" == "" set git_merge_into_branch=%git_upstream_branch%

if "%git_merge_into_branch%" == "develop" goto merge_develop
if "%git_merge_into_branch%" == "d" goto merge_develop
if "%git_merge_into_branch%" == "develop-ascraeus" goto merge_develop_ascraeus
if "%git_merge_into_branch%" == "ascraeus" goto merge_develop_ascraeus
if "%git_merge_into_branch%" == "a" goto merge_develop_ascraeus
if "%git_merge_into_branch%" == "develop-olympus" goto merge_develop_olympus
if "%git_merge_into_branch%" == "olympus" goto merge_develop_olympus
if "%git_merge_into_branch%" == "o" goto merge_develop_olympus

echo ===========================================================================
echo Error: Can only merge into develop/develop-ascraeus/develop-olympus!
echo.

goto help

:merge_develop_ascraeus
:merge_develop
echo ===========================================================================
echo  Merging "%git_author_repository%/%git_author_branch%" into "develop" [y]:
SET git_confirm=
SET /P git_confirm=$ 

if not "%git_confirm%" == "y" goto help

:: Merge branch to local
echo ===========================================================================
echo Updating your branches
echo.
call "%GIT_EXE%" remote update %git_upstream_repository%
echo.
echo ===========================================================================
echo Checking out branch "develop"
echo.
call "%GIT_EXE%" checkout develop
echo.
echo ===========================================================================
echo Reseting head for "develop"
echo.
call "%GIT_EXE%" reset --hard %git_upstream_repository%/develop
echo.
echo ===========================================================================
echo Merging "%git_author_repository%/%git_author_branch%" into "develop"
echo.
call "%GIT_EXE%" merge --no-ff %git_author_repository%/%git_author_branch%
echo.

:merge_develop2
echo ===========================================================================
echo Please check the changes, before pushing changes to "%git_origin_repository%/develop [y]:
SET git_confirm=
SET /P git_confirm=$ 

if not "%git_confirm%" == "y" goto help

:: Push changes to origin
echo ===========================================================================
echo Pushing to "%git_origin_repository%/develop"
echo.
call "%GIT_EXE%" push %git_origin_repository% develop
echo.

:merge_develop3
echo ===========================================================================
echo Changes pushed to "%git_origin_repository%/develop", please check the changes, before merging into "%git_upstream_repository%/develop" [y]:
SET git_confirm=
SET /P git_confirm=$ 

if not "%git_confirm%" == "y" goto merge_develop2

:: Push changes to upstream
echo ===========================================================================
echo Pushing to "%git_upstream_repository%/develop"
echo.
call "%GIT_EXE%" push %git_upstream_repository% develop
echo.

echo ===========================================================================
echo Successfully merged into "%git_upstream_repository%/develop"!
echo.
goto help


:merge_develop_olympus
echo ===========================================================================
echo Merging "%git_author_repository%/%git_author_branch%" into "develop-olympus" [y]:
SET git_confirm=
SET /P git_confirm=$ 
echo.

if not "%git_confirm%" == "y" goto help

:: Push changes to origin
echo ===========================================================================
echo Updating your branches
echo.
call "%GIT_EXE%" remote update %git_upstream_repository%
echo.
echo ===========================================================================
echo Checking out branch "develop-olympus"
echo.
call "%GIT_EXE%" checkout develop-olympus
echo.
echo ===========================================================================
echo Reseting head for "develop-olympus"
echo.
call "%GIT_EXE%" reset --hard %git_upstream_repository%/develop-olympus
echo.
echo ===========================================================================
echo Merging "%git_author_repository%/%git_author_branch%" into "develop-olympus"
echo.
call "%GIT_EXE%" merge --no-ff %git_author_repository%/%git_author_branch%
echo.
echo ===========================================================================
echo Pushing to "%git_origin_repository%/develop-olympus"
echo.
call "%GIT_EXE%" push %git_origin_repository% develop-olympus
echo.

:: Merge Olympus into Develop
echo.
echo ===========================================================================
echo Checking out branch "develop"
echo.
call "%GIT_EXE%" checkout develop
echo.
echo ===========================================================================
echo Reseting head for "develop"
echo.
call "%GIT_EXE%" reset --hard %git_upstream_repository%/develop
echo.
echo ===========================================================================
echo Merging "develop-olympus" into "develop"
echo.
call "%GIT_EXE%" merge --no-ff develop-olympus
echo.
echo ===========================================================================
echo Pushing to "%git_origin_repository%/develop"
echo.
call "%GIT_EXE%" push %git_origin_repository% develop
echo.

:merge_develop_olympus2
echo ===========================================================================
echo Changes pushed to "%git_origin_repository%/develop-olympus", please check the changes, before merging into "%git_upstream_repository%/develop-olympus" [y]:
SET git_confirm=
SET /P git_confirm=$ 

if not "%git_confirm%" == "y" goto merge_develop_olympus2

:: Push changes to upstream
echo ===========================================================================
echo Pushing to "%git_upstream_repository%/develop-olympus"
echo.
call "%GIT_EXE%" push %git_upstream_repository% develop-olympus
echo.
echo ===========================================================================
echo Pushing to "%git_upstream_repository%/develop"
echo.
call "%GIT_EXE%" push %git_upstream_repository% develop
echo.

echo ===========================================================================
echo Successfully merged into "%git_upstream_repository%/develop-olympus"!
echo.
goto help


:end
