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

mkdir -p $PREFIX/man/man1
mv man/man1/* $PREFIX/man/man1
rm -rf man/man1
mv man/* $PREFIX/man

if [[ $(uname) == Linux ]]; then
    mv $PREFIX/lib/jli/*.so $PREFIX/lib/
    mkdir -p %PREFIX/lib/fonts
    mv $SRC_DIR/fonts/ttf/* $PREFIX/lib/fonts/
fi

for CHANGE in "activate" "deactivate"
do
    mkdir -p "${PREFIX}/etc/conda/${CHANGE}.d"
    cp "${RECIPE_DIR}/scripts/${CHANGE\.sh" "${PREFIX}/etc/conda/${CHANGE}.d/${PKG_NAME}_${CHANGE}.sh"
if [[ $(uname) == Darwin ]]; then
  popd
fi
