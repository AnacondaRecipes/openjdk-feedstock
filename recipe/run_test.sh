#!/bin/sh
set -e

if [ "${JAVA_HOME}" != "${PREFIX}" ] && [ "${JAVA_HOME}" != "${PREFIX}/Library" ]; then
  echo "ERROR: JAVA_HOME (${JAVA_HOME}) not equal to PREFIX (${PREFIX}) or ${PREFIX}/Library"
  exit 1
fi

java -version

sh ./test-jni.sh 

pushd test-nio
  javac TestFilePaths.java
  jar cfm TestFilePaths.jar manifest.mf TestFilePaths.class
  java -jar TestFilePaths.jar TestFilePaths.java
popd

echo "Checking binaries..."
for f in \
    bin/jar \
    bin/jarsigner \
    bin/java \
    bin/javac \
    bin/javadoc \
    bin/javap \
    bin/jcmd \
    bin/jconsole \
    bin/jdb \
    bin/jdeprscan \
    bin/jdeps \
    bin/jfr \
    bin/jhsdb \
    bin/jimage \
    bin/jinfo \
    bin/jlink \
    bin/jmap \
    bin/jmod \
    bin/jpackage \
    bin/jps \
    bin/jrunscript \
    bin/jshell \
    bin/jstack \
    bin/jstat \
    bin/jstatd \
    bin/jwebserver \
    bin/keytool \
    bin/rmiregistry \
    bin/serialver \
; do
    if [ ! -f "$PREFIX/$f" ]; then
        echo "MISSING binary: $f"
        exit 1
    fi
done

lib_dir="lib"
include_dir="include"

echo "Checking libraries..."
case "$(uname -s)" in
    Darwin)
        lib_ext="dylib"
        extra_libs="lib/libfreetype.$lib_ext lib/libawt_lwawt.$lib_ext lib/libosx.$lib_ext lib/libosxapp.$lib_ext lib/libosxkrb5.$lib_ext lib/libosxsecurity.$lib_ext lib/libosxui.$lib_ext"
        ;;
    Linux)
        lib_ext="so"
        extra_libs="lib/libawt_headless.$lib_ext lib/libawt_xawt.$lib_ext lib/libmlib_image.$lib_ext lib/libsctp.$lib_ext lib/libsaproc.$lib_ext"
        # libjsvml.so exists only on x86_64
        if [ "$(uname -m)" = "x86_64" ]; then
            extra_libs="$extra_libs lib/libjsvml.$lib_ext"
        fi
        ;;
esac

for f in \
    $lib_dir/libattach.$lib_ext \
    $lib_dir/libawt.$lib_ext \
    $lib_dir/libdt_socket.$lib_ext \
    $lib_dir/libextnet.$lib_ext \
    $lib_dir/libfontmanager.$lib_ext \
    $lib_dir/libinstrument.$lib_ext \
    $lib_dir/libj2gss.$lib_ext \
    $lib_dir/libj2pcsc.$lib_ext \
    $lib_dir/libj2pkcs11.$lib_ext \
    $lib_dir/libjaas.$lib_ext \
    $lib_dir/libjava.$lib_ext \
    $lib_dir/libjavajpeg.$lib_ext \
    $lib_dir/libjawt.$lib_ext \
    $lib_dir/libjdwp.$lib_ext \
    $lib_dir/libjimage.$lib_ext \
    $lib_dir/libjli.$lib_ext \
    $lib_dir/libjsig.$lib_ext \
    $lib_dir/libjsound.$lib_ext \
    $lib_dir/liblcms.$lib_ext \
    $lib_dir/lible.$lib_ext \
    $lib_dir/libmanagement.$lib_ext \
    $lib_dir/libmanagement_agent.$lib_ext \
    $lib_dir/libmanagement_ext.$lib_ext \
    $lib_dir/libnet.$lib_ext \
    $lib_dir/libnio.$lib_ext \
    $lib_dir/libprefs.$lib_ext \
    $lib_dir/librmi.$lib_ext \
    $lib_dir/libsplashscreen.$lib_ext \
    $lib_dir/libsyslookup.$lib_ext \
    $lib_dir/libverify.$lib_ext \
    $lib_dir/libzip.$lib_ext \
    $lib_dir/server/libjsig.$lib_ext \
    $lib_dir/server/libjvm.$lib_ext \
    $extra_libs \
; do
    if [ ! -f "$PREFIX/$f" ]; then
        echo "MISSING library: $f"
        exit 1
    fi
done

echo "Checking headers..."
for f in \
    $include_dir/classfile_constants.h \
    $include_dir/jawt.h \
    $include_dir/jdwpTransport.h \
    $include_dir/jni.h \
    $include_dir/jvmti.h \
    $include_dir/jvmticmlr.h \
; do
    if [ ! -f "$PREFIX/$f" ]; then
        echo "MISSING header: $f"
        exit 1
    fi
done

echo "All files present."
