#!/bin/bash
set -ex

if [[ ! -d $JAVA_LD_LIBRARY_PATH ]]; then
  echo "Did you remember to activate the conda environment?"
  exit 1
fi

ls $JAVA_LD_LIBRARY_PATH

echo "DEVELOPER_DIR: $DEVELOPER_DIR"
echo "CONDA_BUILD_SYSROOT: $CONDA_BUILD_SYSROOT"

os=$(uname -s | tr '[:upper:]' '[:lower:]')
${CC}                                 \
  -v                                  \
  -Xlinker -v                         \
  -Xlinker -macosx_version_min=11.1   \
  -I${JAVA_HOME}/include              \
  -I${JAVA_HOME}/include/$os          \
  -L${JAVA_LD_LIBRARY_PATH}           \
  -Wl,-rpath,${JAVA_LD_LIBRARY_PATH}  \
  -L$JAVA_LD_LIBRARY_PATH             \
  -L$JAVA_LD_LIBRARY_PATH/server      \
  -ljvm                               \
  -o vmtest                           \
  test-jni/vmtest.c
	
./vmtest
