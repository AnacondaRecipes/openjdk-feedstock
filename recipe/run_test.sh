#!/bin/sh
set -e

# if [[ $target_platform == osx-64 ]]; then
  # echo DEBUG_libSystem.tbd_START
  # cat /Library/Developer/CommandLineTools/SDKs/MacOSX11.1.sdk/usr/lib/libSystem.tbd
  # echo DEBUG_libSystem.tbd_END
# fi

if [ "${JAVA_HOME}" != "${PREFIX}" ] && [ "${JAVA_HOME}" != "${PREFIX}/Library" ]; then
  echo "ERROR: JAVA_HOME (${JAVA_HOME}) not equal to PREFIX (${PREFIX}) or ${PREFIX}/Library"
  exit 1
fi

sh ./test-jni.sh 

pushd test-nio
  javac TestFilePaths.java
  jar cfm TestFilePaths.jar manifest.mf TestFilePaths.class
  java -jar TestFilePaths.jar TestFilePaths.java
popd
