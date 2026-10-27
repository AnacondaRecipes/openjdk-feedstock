IF NOT "%JAVA_HOME%" == "%PREFIX%\Library" exit 1

%JAVA_HOME%/bin/java -version

pushd test-nio
  java -version
  javac TestFilePaths.java
  jar cfm TestFilePaths.jar manifest.mf TestFilePaths.class
  java -jar TestFilePaths.jar TestFilePaths.java
  IF ERRORLEVEL 1 exit 1
popd

@echo off
echo Checking binaries...
for %%f in (
    Library\bin\jar.exe
    Library\bin\jarsigner.exe
    Library\bin\java.exe
    Library\bin\javac.exe
    Library\bin\javadoc.exe
    Library\bin\javap.exe
    Library\bin\javaw.exe
    Library\bin\jcmd.exe
    Library\bin\jconsole.exe
    Library\bin\jdb.exe
    Library\bin\jdeprscan.exe
    Library\bin\jdeps.exe
    Library\bin\jfr.exe
    Library\bin\jhsdb.exe
    Library\bin\jimage.exe
    Library\bin\jinfo.exe
    Library\bin\jlink.exe
    Library\bin\jmap.exe
    Library\bin\jmod.exe
    Library\bin\jpackage.exe
    Library\bin\jps.exe
    Library\bin\jrunscript.exe
    Library\bin\jshell.exe
    Library\bin\jstack.exe
    Library\bin\jstat.exe
    Library\bin\jstatd.exe
    Library\bin\jwebserver.exe
    Library\bin\keytool.exe
    Library\bin\rmiregistry.exe
    Library\bin\serialver.exe
) do (
    if not exist "%PREFIX%\%%f" (
        echo MISSING binary: %%f
        exit /b 1
    )
)

echo Checking libraries...
for %%f in (
    Library\bin\attach.dll
    Library\bin\awt.dll
    Library\bin\dt_socket.dll
    Library\bin\extnet.dll
    Library\bin\fontmanager.dll
    Library\bin\freetype.dll
    Library\bin\instrument.dll
    Library\bin\j2gss.dll
    Library\bin\j2pcsc.dll
    Library\bin\j2pkcs11.dll
    Library\bin\jaas.dll
    Library\bin\java.dll
    Library\bin\javajpeg.dll
    Library\bin\jawt.dll
    Library\bin\jdwp.dll
    Library\bin\jimage.dll
    Library\bin\jli.dll
    Library\bin\jpackage.dll
    Library\bin\jsound.dll
    Library\bin\lcms.dll
    Library\bin\management.dll
    Library\bin\management_agent.dll
    Library\bin\management_ext.dll
    Library\bin\mlib_image.dll
    Library\bin\net.dll
    Library\bin\nio.dll
    Library\bin\prefs.dll
    Library\bin\rmi.dll
    Library\bin\saproc.dll
    Library\bin\splashscreen.dll
    Library\bin\sspi_bridge.dll
    Library\bin\sunmscapi.dll
    Library\bin\syslookup.dll
    Library\bin\verify.dll
    Library\bin\zip.dll
    Library\bin\server\jvm.dll
) do (
    if not exist "%PREFIX%\%%f" (
        echo MISSING library: %%f
        exit /b 1
    )
)

:: jsvml.dll (Intel SVML) only ships in x64 builds, not win-arm64
if /i "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
    if not exist "%PREFIX%\Library\bin\jsvml.dll" (
        echo MISSING library: Library\bin\jsvml.dll
        exit /b 1
    )
)

echo Checking headers...
for %%f in (
    Library\include\classfile_constants.h
    Library\include\jawt.h
    Library\include\jdwpTransport.h
    Library\include\jni.h
    Library\include\jvmti.h
    Library\include\jvmticmlr.h
) do (
    if not exist "%PREFIX%\%%f" (
        echo MISSING header: %%f
        exit /b 1
    )
)

echo All files present.

echo Checking trust stores...
if not exist "%PREFIX%\Library\lib\security\cacerts" (
    echo MISSING trust store: Library\lib\security\cacerts
    exit /b 1
)
REM No storepass + EOF on stdin = null password, as the default trust manager loads it; English for stable parsing.
for /f "delims=" %%C in ('dir /s /b "%PREFIX%\Library\lib\cacerts"') do (
    "%PREFIX%\Library\bin\keytool.exe" -J-Duser.language=en -J-Duser.country=US -list -v -keystore "%%C" <nul > "%TEMP%\cacerts-listing.txt"
    if errorlevel 1 exit /b 1
    findstr /b /c:"Owner: CN=emSign ECC Root CA - G3," /c:"Owner: CN=emSign ECC Root CA - C3," /c:"Owner: CN=emSign Root CA - G1," /c:"Owner: CN=emSign Root CA - C1," "%TEMP%\cacerts-listing.txt" && (
        echo Distrusted emSign root still present in %%C
        exit /b 1
    )
    findstr /b /c:"Owner: CN=ISRG Root X1," "%TEMP%\cacerts-listing.txt" >nul || (
        echo Trust anchors not readable without a password in %%C
        exit /b 1
    )
)
REM 8395142 (CA Enhancements) blocks the compromised eMudhra intermediates; this is
REM EM DV TLS CA - G3B cross-signed by AAA Certificate Services.
findstr /l /x /c:"45A883F349AEDFD5F3A649B5498FFB121712BA8B448F3F2A91DBC5A766FCDDBE" "%PREFIX%\Library\lib\security\blocked.certs" >nul || exit /b 1
echo Trust stores OK.
