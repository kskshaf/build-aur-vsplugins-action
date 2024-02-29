#!/bin/bash
set -m
export HOME=$PWD

export OWN_PREFIX="$HOME/myenc"
export MYLDPH="$OWN_PREFIX/lib"
export MYPKGPH="$MYLDPH/pkgconfig"
export VSPLGPH="$MYLDPH/vapoursynth"

export cpu=skylake
export NATIVE="-march=$cpu -mtune=$cpu"

export CUDA_PATH=/opt/cuda
export NVCC_PREPEND_FLAGS='-ccbin /opt/cuda/bin'
export PATH="$PATH:/opt/cuda/bin:/opt/cuda/nsight_compute:/opt/cuda/nsight_systems/bin"

export PATH="$OWN_PREFIX/bin:$PATH"
sudo mkdir -p $VSPLGPH
cd $HOME

git clone https://github.com/SAPikachu/flash3kyuu_deband --depth 1
cd flash3kyuu_deband
PYTHON3=$OWN_PREFIX/bin/python3.11 PKG_CONFIG_PATH=$MYPKGPH CFLAGS=$NATIVE CXXFLAGS=$NATIVE ./waf configure
set -euo pipefail
sed -i "s/m='rU'/m='r'/" .waf3-2.0.10-195b3fea150563357014bcceb6844e0e/waflib/Context.py
sed -i "s/m='rU'/m='r'/" .waf3-2.0.10-195b3fea150563357014bcceb6844e0e/waflib/ConfigSet.py
PYTHON3=$OWN_PREFIX/bin/python3.11 PKG_CONFIG_PATH=$MYPKGPH CFLAGS=$NATIVE CXXFLAGS=$NATIVE ./waf configure
PYTHON3=$OWN_PREFIX/bin/python3.11 PKG_CONFIG_PATH=$MYPKGPH CFLAGS=$NATIVE CXXFLAGS=$NATIVE ./waf build
sudo install -m 755 build/libf3kdb.so $VSPLGPH
cd ..
