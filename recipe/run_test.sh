#!/bin/sh
set -e

if [[ $target_platform == osx-64 ]]; then
  CONDA_BUILD_SYSROOT="/opt/MacOSX11.1.sdk"
  DEVELOPER_DIR="/opt/MacOSX11.1.sdk:$DEVELOPER_DIR"
fi

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
