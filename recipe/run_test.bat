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
    Library\bin\jsvml.dll
    Library\bin\lcms.dll
    Library\bin\le.dll
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