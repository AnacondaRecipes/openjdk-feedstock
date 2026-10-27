#!/bin/bash -euo

if [[ $(uname) == Darwin ]]; then
  pushd Contents/Home
fi

chmod +x bin/*
[[ -d "${PREFIX}"/bin ]] || mkdir "${PREFIX}"/bin
[[ -d "${PREFIX}"/lib ]] || mkdir "${PREFIX}"/lib
[[ -d "${PREFIX}"/include ]] || mkdir "${PREFIX}"/include

mv bin/* $PREFIX/bin
mv include/* $PREFIX/include
mv lib/* $PREFIX/lib

if [ -e lib/jspawnhelper ]; then
    chmod +x lib/jspawnhelper
fi

if [ -f "release" ]; then
    mv release $PREFIX/release
fi

mkdir -p $PREFIX/conf
mv conf/* $PREFIX/conf

mkdir -p $PREFIX/jmods
mv jmods/* $PREFIX/jmods

mkdir -p $PREFIX/legal
mv legal/* $PREFIX/legal

# 5/26/2021 (PJY): The source files from https://bintray.com/jetbrains/intellij-jbr (which we use) do not have 'man' directories,
# but the source files from https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/ (used by conda-forge) do
# have the 'man' directories. Commenting out this section for now. If we switch to the 'AdoptOpenJDK' source, then we should
# uncomment this section.
#mkdir -p $PREFIX/man/man1
#mv man/man1/* $PREFIX/man/man1
#rm -rf man/man1
#mv man/* $PREFIX/man

if [[ $(uname) == Linux ]]; then
    # mv $PREFIX/lib/jli/*.so $PREFIX/lib/
    mkdir -p %PREFIX/lib/fonts
    mv $SRC_DIR/fonts/ttf/* $PREFIX/lib/fonts/
fi

# Distrust eMudhra emSign roots (CA compromise, Oct 2026) in every bundled trust store;
# the jcef runtime ships a second copy under lib/lib. C1 / ECC C3 are not in JDK cacerts.
n_cacerts=0
for cacerts in $(find "${PREFIX}/lib" -path '*/security/cacerts'); do
    for alias in "emsigneccrootcag3 [jdk]" "emsignrootcag1 [jdk]"; do
        "${PREFIX}/bin/keytool" -delete -noprompt -storepass changeit -keystore "${cacerts}" -alias "${alias}"
    done
    n_cacerts=$((n_cacerts + 1))
done
[[ ${n_cacerts} -gt 0 ]] || { echo "No cacerts found under ${PREFIX}/lib" >&2; exit 1; }

for CHANGE in "activate" "deactivate"
do
    mkdir -p "${PREFIX}/etc/conda/${CHANGE}.d"
    cp "${RECIPE_DIR}/scripts/${CHANGE}.sh" "${PREFIX}/etc/conda/${CHANGE}.d/${PKG_NAME}_${CHANGE}.sh"
#if [[ $(uname) == Darwin ]]; then
#  popd
#fi
done
