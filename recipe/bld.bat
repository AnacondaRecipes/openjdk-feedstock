XCOPY jbrsdk\bin\* "%LIBRARY_BIN%\" /s /e /y
if errorlevel 1 exit 1

XCOPY jbrsdk\include\* "%LIBRARY_INC%\" /s /e /y
if errorlevel 1 exit 1

XCOPY jbrsdk\lib\* "%LIBRARY_LIB%\" /s /e /y
if errorlevel 1 exit 1

XCOPY jbrsdk\release "%LIBRARY_PREFIX%\" /s /i /y
if errorlevel 1 exit 1

if not exist "%LIBRARY_PREFIX%\conf\" mkdir "%LIBRARY_PREFIX%\conf\"
XCOPY jbrsdk\conf\* "%LIBRARY_PREFIX%\conf\" /s /i /y
if errorlevel 1 exit 1

if not exist "%LIBRARY_PREFIX%\jmods\" mkdir "%LIBRARY_PREFIX%\jmods\"
XCOPY jbrsdk\jmods\* "%LIBRARY_PREFIX%\jmods\" /s /i /y
if errorlevel 1 exit 1

if not exist "%LIBRARY_PREFIX%\legal\" mkdir "%LIBRARY_PREFIX%\legal\"
XCOPY jbrsdk\legal\* "%LIBRARY_PREFIX%\legal\" /s /i /y
if errorlevel 1 exit 1

XCOPY jcef\bin\* "%LIBRARY_BIN%\" /s /e /y
XCOPY jcef\lib\* "%LIBRARY_LIB%\" /s /e /y
XCOPY jcef\legal\* "%LIBRARY_PREFIX%\legal\" /s /e /y

FOR %%F IN (activate deactivate) DO (
    if not exist %PREFIX%\etc\conda\%%F.d mkdir %PREFIX%\etc\conda\%%F.d
    if errorlevel 1 exit 1
    copy %RECIPE_DIR%\scripts\%%F.bat %PREFIX%\etc\conda\%%F.d\%PKG_NAME%_%%F.bat

    :: We also copy .sh scripts to be able to use them
    :: with POSIX CLI on Windows
    copy %RECIPE_DIR%\scripts\%%F-win.sh %PREFIX%\etc\conda\%%F.d\%PKG_NAME%_%%F.sh
    if errorlevel 1 exit 1
)
