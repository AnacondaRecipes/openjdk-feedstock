Robocopy.exe /MOVE /S /E bin\ "%LIBRARY_BIN%"
Robocopy.exe /MOVE /S /E include\ "%LIBRARY_INC%"
Robocopy.exe /MOVE /S /E lib\ "%LIBRARY_LIB%"

XCOPY release %LIBRARY_PREFIX% /s /y /i
if errorlevel 1 exit 1

if not exist "%LIBRARY_PREFIX%\conf\" mkdir %LIBRARY_PREFIX\conf\
XCOPY conf\* %LIBRARY_PREFIX%\conf\ /s /i /y
if errorlevel 1 exit 1

if not exist "%LIBRARY_PREFIX%\jmods\" mkdir %LIBRARY_PREFIX\jmods\
XCOPY jmods\* %LIBRARY_PREFIX%\jmods\ /s /i /y
if errorlevel 1 exit 1

if not exist "%LIBRARY_PREFIX%\legal\" mkdir %LIBRARY_PREFIX\legal\
XCOPY legal\* %LIBRARY_PREFIX%\legal\ /s /i /y
if errorlevel 1 exit 1

REM Distrust eMudhra emSign roots (CA compromise, Oct 2026) in every bundled trust store;
REM the jcef runtime ships a second copy under lib\lib. C1 / ECC C3 are not in JDK cacerts.
set "CACERTS_FOUND=0"
for /f "delims=" %%C in ('dir /s /b "%LIBRARY_LIB%\cacerts"') do (
    "%LIBRARY_BIN%\keytool.exe" -delete -noprompt -storepass changeit -keystore "%%C" -alias "emsigneccrootcag3 [jdk]"
    if errorlevel 1 exit 1
    "%LIBRARY_BIN%\keytool.exe" -delete -noprompt -storepass changeit -keystore "%%C" -alias "emsignrootcag1 [jdk]"
    if errorlevel 1 exit 1
    set "CACERTS_FOUND=1"
)
if "%CACERTS_FOUND%"=="0" exit 1

FOR %%F IN (activate deactivate) DO (
    if not exist %PREFIX%\etc\conda\%%F.d mkdir %PREFIX%\etc\conda\%%F.d
    if errorlevel 1 exit 1
    copy %RECIPE_DIR%\scripts\%%F.bat %PREFIX%\etc\conda\%%F.d\%PKG_NAME%_%%F.bat

    :: We also copy .sh scripts to be able to use them
    :: with POSIX CLI on Windows
    copy %RECIPE_DIR%\scripts\%%F-win.sh %PREFIX%\etc\conda\%%F.d\%PKG_NAME%_%%F.sh
    if errorlevel 1 exit 1
)

