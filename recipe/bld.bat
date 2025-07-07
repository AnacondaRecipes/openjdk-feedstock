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

:: Copy only selected files from jcef as to not overwrite sdk
XCOPY jcef\bin\cef_server.exe           "%LIBRARY_BIN%\" /y
XCOPY jcef\bin\chrome_elf.dll           "%LIBRARY_BIN%\" /y
XCOPY jcef\bin\d3dcompiler_47.dll       "%LIBRARY_BIN%\" /y
XCOPY jcef\bin\dxcompiler.dll           "%LIBRARY_BIN%\" /y
XCOPY jcef\bin\dxil.dll                 "%LIBRARY_BIN%\" /y
XCOPY jcef\bin\gluegen_rt.dll           "%LIBRARY_BIN%\" /y
XCOPY jcef\bin\icudtl.dat               "%LIBRARY_BIN%\" /y
XCOPY jcef\bin\jcef_helper.dll          "%LIBRARY_BIN%\" /y
XCOPY jcef\bin\jcef_helper.exe          "%LIBRARY_BIN%\" /y
XCOPY jcef\bin\jcef.dll                 "%LIBRARY_BIN%\" /y
XCOPY jcef\bin\jogl_desktop.dll         "%LIBRARY_BIN%\" /y
XCOPY jcef\bin\jogl_mobile.dll          "%LIBRARY_BIN%\" /y
XCOPY jcef\bin\libcef.dll               "%LIBRARY_BIN%\" /y
XCOPY jcef\bin\libEGL.dll               "%LIBRARY_BIN%\" /y
XCOPY jcef\bin\libGLESv2.dll            "%LIBRARY_BIN%\" /y
XCOPY jcef\bin\nativewindow_awt.dll     "%LIBRARY_BIN%\" /y
XCOPY jcef\bin\nativewindow_win32.dll   "%LIBRARY_BIN%\" /y
XCOPY jcef\bin\newt_head.dll            "%LIBRARY_BIN%\" /y
XCOPY jcef\bin\shared_mem_helper.dll    "%LIBRARY_BIN%\" /y
XCOPY jcef\bin\snapshot_blob.bin        "%LIBRARY_BIN%\" /y
XCOPY jcef\bin\v8_context_snapshot.bin  "%LIBRARY_BIN%\" /y
XCOPY jcef\bin\vk_swiftshader.dll       "%LIBRARY_BIN%\" /y
XCOPY jcef\bin\vulkan-1.dll             "%LIBRARY_BIN%\" /y

XCOPY jcef\lib\chrome_100_percent.pak   "%LIBRARY_LIB%\" /y
XCOPY jcef\lib\chrome_200_percent.pak   "%LIBRARY_LIB%\" /y
XCOPY jcef\lib\resources.pak            "%LIBRARY_LIB%\" /y
XCOPY jcef\lib\vk_swiftshader_icd.json  "%LIBRARY_LIB%\" /y

XCOPY jcef\lib\locales\* "%LIBRARY_LIB%\locales\" /s /e /y

FOR %%F IN (activate deactivate) DO (
    if not exist %PREFIX%\etc\conda\%%F.d mkdir %PREFIX%\etc\conda\%%F.d
    if errorlevel 1 exit 1
    copy %RECIPE_DIR%\scripts\%%F.bat %PREFIX%\etc\conda\%%F.d\%PKG_NAME%_%%F.bat

    :: We also copy .sh scripts to be able to use them
    :: with POSIX CLI on Windows
    copy %RECIPE_DIR%\scripts\%%F-win.sh %PREFIX%\etc\conda\%%F.d\%PKG_NAME%_%%F.sh
    if errorlevel 1 exit 1
)
