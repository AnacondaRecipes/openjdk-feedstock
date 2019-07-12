#!/bin/bash -euo

set -x

find .

if [[ ${target_platform} == osx-64 ]]; then
  pushd jdk/Contents/Home
else
  pushd jdk
fi

chmod +x bin/*
[[ -d "${PREFIX}"/bin ]] || mkdir "${PREFIX}"/bin
[[ -d "${PREFIX}"/lib ]] || mkdir "${PREFIX}"/lib
[[ -d "${PREFIX}"/include ]] || mkdir "${PREFIX}"/include

if [[ -e jre/lib/jspawnhelper ]]; then
    chmod +x jre/lib/jspawnhelper
fi

if [[ ${ARCH} == 64 ]]; then
  _libarch=amd64
else
  _libarch=i386
fi

if [[ ${target_platform} =~ linux.* ]]; then
  mv lib/${_libarch}/jli/*.so lib
  mv lib/${_libarch}/*.so lib
  rm -r lib/${_libarch}
  # libnio.so does not find this within jre/lib/amd64 subdirectory
  cp jre/lib/${_libarch}/libnet.so lib

  # include dejavu fonts to allow java to work even on minimal cloud images where these fonts are missing
  # (thanks to @chapmanb)
  pushd jre/lib/fonts
    mv ttf/* ../
    rm -rf ttf
  popd
fi

mv jre "${PREFIX}"/
if [[ -f src.zip ]]; then
  mv src.zip "${PREFIX}"/jre/
fi

mv bin/* "${PREFIX}"/bin/
mv lib/* "${PREFIX}"/lib/
mv include/* "${PREFIX}"/include/

# ensure that JAVA_HOME is set correctly
mkdir -p "${PREFIX}"/etc/conda/activate.d
mkdir -p "${PREFIX}"/etc/conda/deactivate.d
cp "${RECIPE_DIR}"/scripts/activate.sh "${PREFIX}"/etc/conda/activate.d/java_home.sh
cp "${RECIPE_DIR}"/scripts/deactivate.sh "${PREFIX}"/etc/conda/deactivate.d/java_home.sh

popd
