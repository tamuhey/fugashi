#!/bin/bash
set -e

PY_VERSIONS=$1

# Install MeCab
# Technically setup.py takes care of this, but running `make install` makes it
# easier.
cd /github/workspace
git clone git@github.com:taku910/mecab.git
cd mecab/mecab

# This is magic to keep some autoconf script from re-running itself
for ff in aclocal.m4 config.h.in configure Makefile.in src/Makefile.in; do
  touch $ff
  sleep 1
done

# This is a normal install. utf8-only isn't strictly required, but it prevents
# potential confusion.
./configure --enable-utf8-only
make 
make install

# Compile wheels
arrPY_VERSIONS=(${PY_VERSIONS// / })
for PY_VER in "${arrPY_VERSIONS[@]}"; do
    # Check if requirements were passed
    /opt/python/${PY_VER}/bin/pip wheel /github/workspace/ -w /github/workspace/wheelhouse/ || { echo "Building wheels failed."; exit 1; }
done

# Bundle external shared libraries into the wheels
for whl in /github/workspace/wheelhouse/*.whl; do
    auditwheel repair "$whl" --plat manylinux1_x86_64 -w /github/workspace/wheelhouse/
done

echo "Succesfully built wheels:"
ls /github/workspace/wheelhouse
