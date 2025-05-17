#!/bin/bash
set -euo pipefail

export HOME=$PWD
mkdir -p $HOME/myenc
export OWN_PREFIX="$HOME/myenc"
export MYLDPH="$OWN_PREFIX/lib"
export MYICPH="$OWN_PREFIX/include"
export MYPKGPH="$MYLDPH/pkgconfig"
export VSPLGPH="$MYLDPH/vapoursynth"
export VSFUNCPH="$MYLDPH/python3.12/site-packages"
export cpu=native
export NATIVE="-march=$cpu -mtune=$cpu"

export CUDA_PATH=/opt/cuda
export NVCC_PREPEND_FLAGS='-ccbin /opt/cuda/bin'
export PATH="$PATH:/opt/cuda/bin:/opt/cuda/nsight_compute:/opt/cuda/nsight_systems/bin"

echo -e "\e[42m Pacman Install \e[0m"
pacman --noconfirm --needed -S nasm cuda cuda-tools clang compiler-rt llvm llvm-libs rust onetbb meson wget cmake yasm imagemagick openexr libtiff libheif libmfx libxml2 imath qt6-base qt6-websockets qt6-5compat p7zip amf-headers \
boost bzip2 brotli harfbuzz libpng frei0r-plugins freetype2 ladspa libjxl libass


#echo -e "\e[42m Install yay \e[0m"
#useradd -m -s /usr/bin/bash yay-build
#chmod +w /etc/sudoers
#echo "yay-build  ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
#chmod -w /etc/sudoers
#su - yay-build -c "git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin && makepkg -s"
#pacman --noconfirm -U /home/yay-build/yay-bin/yay-bin-12.3.5-1-x86_64.pkg.tar.zst

#su - yay-build -c "yay --noconfirm -S clang15 compiler-rt15 llvm15 llvm15-libs"
## pacman pkgs:
##  boost
##  bzip2
##  brotli
##  harfbuzz
##  libpng
##  frei0r
##  freetype2
##  ladspa
##  libjxl
##  libass
##  llvm15, llvm15-libs, clang15, compiler-rt15

## NOTICE: remember to replace 'prefix=/usr' to 'prefix=$OWN_PREFIX', in .pc files.

# echo -e "\e[42m Install llvm15 pkg \e[0m"
# wget -q https://github.com/kskshaf/build-aur-llvm15/releases/download/new/llvm15-15.0.7-1-x86_64.pkg.tar.zst
# wget -q https://github.com/kskshaf/build-aur-llvm15/releases/download/new/llvm15-libs-15.0.7-1-x86_64.pkg.tar.zst
# wget -q https://github.com/kskshaf/build-aur-llvm15/releases/download/new/clang15-15.0.7-2-x86_64.pkg.tar.zst
# wget -q https://github.com/kskshaf/build-aur-llvm15/releases/download/new/compiler-rt15-15.0.7-1-x86_64.pkg.tar.zst

# pacman --noconfirm -U llvm15-15.0.7-1-x86_64.pkg.tar.zst llvm15-libs-15.0.7-1-x86_64.pkg.tar.zst clang15-15.0.7-2-x86_64.pkg.tar.zst compiler-rt15-15.0.7-1-x86_64.pkg.tar.zst

# echo -e "\e[42m Build custom python \e[0m"
# wget -q https://www.python.org/ftp/python/3.12.10/Python-3.12.10.tar.xz
# tar xf Python-3.12.10.tar.xz
# cd Python-3.12.10
# CFLAGS=$NATIVE CXXFLAGS=$NATIVE ./configure --enable-optimizations --prefix=$OWN_PREFIX &> $OWN_PREFIX/python312_10_conf.log # --with-lto
# make -j$(nproc) &> $OWN_PREFIX/python312_10_make.log
# make altinstall &> $OWN_PREFIX/python312_10_install.log
# make clean -j$(nproc)
# cd ..
export PATH="$OWN_PREFIX/bin:$PATH"

# # build zimg
# echo -e "\e[42m Build zimg \e[0m"
# git clone https://github.com/sekrit-twc/zimg.git --depth 1 --recurse-submodules --shallow-submodules
# cd zimg
# #git checkout 71431815950664f1e11b9ee4e5d4ba23d6d997f1
# PKG_CONFIG_PATH=$MYPKGPH PREFIX=$OWN_PREFIX CFLAGS=$NATIVE CXXFLAGS=$NATIVE ./autogen.sh
# PKG_CONFIG_PATH=$MYPKGPH PREFIX=$OWN_PREFIX CFLAGS=$NATIVE CXXFLAGS=$NATIVE ./configure --prefix=$OWN_PREFIX
# make -j$(nproc)
# make install -j$(nproc)
# make clean -j$(nproc)
# cd ..
#
# # build vapoursynth
# echo -e "\e[42m Build vapoursynth \e[0m"
# PYTHONUSERBASE=$OWN_PREFIX $OWN_PREFIX/bin/python3.12 -m pip install -U pip
# PYTHONUSERBASE=$OWN_PREFIX $OWN_PREFIX/bin/pip3.12 install -U cython setuptools wheel pypng zstandard fonttools
# git clone --recursive https://github.com/vapoursynth/vapoursynth.git
# cd vapoursynth
# git checkout 40608b5552b035a8599e0a5fe57272287f9cf640   # R71
# PKG_CONFIG_PATH=$MYPKGPH PREFIX=$OWN_PREFIX CFLAGS=$NATIVE CXXFLAGS=$NATIVE ./autogen.sh
# PKG_CONFIG_PATH=$MYPKGPH PREFIX=$OWN_PREFIX CFLAGS=$NATIVE CXXFLAGS=$NATIVE ./configure --prefix=$OWN_PREFIX
# make -j$(nproc)
# make install -j$(nproc)
# PYTHONUSERBASE=$OWN_PREFIX $OWN_PREFIX/bin/python3.12 setup.py sdist -d sdist
# mkdir -p empty && pushd empty
# PYTHONUSERBASE=$OWN_PREFIX PKG_CONFIG_PATH=$MYPKGPH LDFLAGS=-L$OWN_PREFIX/lib $OWN_PREFIX/bin/pip3.12 install vapoursynth --no-index --find-links ../sdist
# popd
# make clean -j$(nproc)
# cd ..
#
# # # build akarin
# # echo -e "\e[42m Build akarin \e[0m"
# # git clone --recursive https://github.com/AkarinVS/vapoursynth-plugin.git --depth 1 akarin-plugin
# # cd akarin-plugin
# # sed -i 's/true/false/' meson_options.txt
# # #CFLAGS=$NATIVE CXXFLAGS=$NATIVE LLVM_CONFIG=$OWN_PREFIX/lib/llvm15/bin/llvm-config CC=$OWN_PREFIX/lib/llvm15/bin/clang-15 CXX=$OWN_PREFIX/lib/llvm15/bin/clang++ PKG_CONFIG_PATH=$MYPKGPH meson setup --prefix=$OWN_PREFIX build .
# # CFLAGS=$NATIVE CXXFLAGS=$NATIVE LLVM_CONFIG=/usr/lib/llvm15/bin/llvm-config CC=/usr/lib/llvm15/bin/clang-15 CXX=/usr/lib/llvm15/bin/clang++ PKG_CONFIG_PATH=$MYPKGPH meson setup --prefix=$OWN_PREFIX build .
# # ninja -C build
# # mkdir -p $VSPLGPH
# # install ./build/libakarin.so $VSPLGPH/
# # ninja -C build clean
# # cd ..
#
# # build dav1d
# echo -e "\e[42m Build dav1d \e[0m"
# git clone https://code.videolan.org/videolan/dav1d.git --branch 1.5.1 --depth 1
# pushd dav1d
# mkdir build && cd build
# meson setup --prefix=$OWN_PREFIX -Denable_tools=false -Denable_tests=false --default-library=static --buildtype release . ..
# ninja
# ninja install
# ninja clean
# popd
#
# # install nv-codec-headers
# echo -e "\e[42m Install nv-codec-headers \e[0m"
# git clone --recursive https://github.com/FFmpeg/nv-codec-headers --depth 1
# cd nv-codec-headers
# tmp=$(echo $OWN_PREFIX | sed 's#\/#\\\/#g')
# sed -i 's#/usr/local#'"${tmp}"'#g' Makefile
# make install -j$(nproc)
# cd ..
#
# # build libvpx
# echo -e "\e[42m Build libvpx \e[0m"
# git clone --recursive https://github.com/webmproject/libvpx.git --branch v1.15.1 --depth 1
# mkdir libvpx/builds && pushd libvpx/builds
# PKG_CONFIG_PATH=$MYPKGPH ../configure --prefix=$OWN_PREFIX --as=nasm --enable-vp9-highbitdepth --disable-docs --disable-tools --disable-examples --disable-webm-io --disable-vp8-encoder --disable-vp9-encoder
# make -j$(nproc)
# make install -j$(nproc)
# make clean
# popd
#
# # build libxml2
# echo -e "\e[42m Build libxml2 \e[0m"
# git clone https://gitlab.gnome.org/GNOME/libxml2.git --branch v2.14.2 --depth 1
# cd libxml2
# PKG_CONFIG_PATH=$OWN_PREFIX/lib/pkgconfig ./autogen.sh
# CFLAGS='-O2 -fno-semantic-interposition' PKG_CONFIG_PATH=$OWN_PREFIX/lib/pkgconfig ./configure --prefix=$OWN_PREFIX
# make -j$(nproc)
# make install -j$(nproc)
# cp $OWN_PREFIX/lib/pkgconfig/libxml-2.0.pc $OWN_PREFIX/lib/pkgconfig/libxml2.pc
# cp $OWN_PREFIX/lib/pkgconfig/libxml-2.0.pc $OWN_PREFIX/lib/pkgconfig/libxml2s.pc
# make clean
# cd ..
#
# # # build ffmpeg for lsmashsource
# # echo -e "\e[42m Build ffmpeg for lsmashsource \e[0m"
# # git clone --recursive https://github.com/HomeOfAviSynthPlusEvolution/FFmpeg --branch custom-patches-for-lsmashsource --depth 1
# # pushd FFmpeg
# # PKG_CONFIG_PATH=$OWN_PREFIX/lib/pkgconfig ./configure --prefix=$OWN_PREFIX --enable-gpl --enable-version3 --disable-debug --disable-hwaccels --disable-encoders --disable-avisynth --disable-doc --disable-network --disable-programs --disable-muxers --enable-avcodec --enable-avformat --enable-swresample --enable-swscale --enable-libdav1d --enable-libvpx --enable-libxml2
# # make -j$(nproc)
# # make install -j$(nproc)
# # make clean
# # popd
#
# # build obuparse
# echo -e "\e[42m Build obuparse \e[0m"
# git clone --recursive https://github.com/dwbuiten/obuparse --depth 1
# pushd obuparse
# # gcc -O2 -c obuparse.c
# # ar r libobuparse.a obuparse.o
# # install obuparse.h $MYICPH
# # install libobuparse.a $MYLDPH
# # rm -rf *.a *.o
# PREFIX=$OWN_PREFIX make -j$(nproc) && make install -j$(nproc)
# popd
#
# # build l-smash static-libs
# echo -e "\e[42m Build l-smash static-libs \e[0m"
# git clone --recursive https://github.com/kskshaf/l-smash --depth 1
# pushd l-smash
# mv configure configure.old
# sed 's/-Wl,--version-script,liblsmash.ver//g' configure.old >configure
# chmod +x configure
# ./configure --prefix=$OWN_PREFIX --extra-cflags="-I$MYICPH -fPIC"  --extra-ldflags=-L$MYLDPH
# make static-lib -j$(nproc)
# make install-lib -j$(nproc)
# make clean
# popd
#
# # # build xxHash
# # echo -e "\e[42m Build xxHash \e[0m"
# # git clone --recursive https://github.com/Cyan4973/xxHash --branch v0.8.2 --depth 1
# # pushd xxHash
# # cmake -S ./cmake_unofficial -B build -GNinja -DCMAKE_PREFIX_PATH=$OWN_PREFIX -DCMAKE_BUILD_TYPE=Release -DXXHASH_BUILD_XXHSUM=OFF -DBUILD_SHARED_LIBS=OFF
# # cmake --build build
# # cmake --install build --prefix $OWN_PREFIX
# # ninja -C build clean
# # popd
#
# # build avisynth
# echo -e "\e[42m Build AviSynth \e[0m"
# git clone --recursive https://github.com/AviSynth/AviSynthPlus --branch 3.7 --depth 1
# pushd AviSynthPlus
# cmake -S . -B build -GNinja -DCMAKE_PREFIX_PATH=$OWN_PREFIX -DCMAKE_BUILD_TYPE=Release -DENABLE_PLUGINS=OFF -DENABLE_INTEL_SIMD=OFF
# cmake --build build
# cmake --install build --prefix $OWN_PREFIX
# ninja -C build clean
# popd
#
# # build l-smash-works
# echo -e "\e[42m Build L-SMASH-Works \e[0m"
# git clone --recursive https://github.com/HomeOfAviSynthPlusEvolution/L-SMASH-Works --depth 1
# pushd L-SMASH-Works
# cd FFmpeg
# PKG_CONFIG_PATH=$OWN_PREFIX/lib/pkgconfig ./configure --prefix=$OWN_PREFIX --enable-gpl --enable-version3 --disable-debug --disable-hwaccels --disable-encoders --disable-avisynth --disable-doc --disable-network --disable-programs --disable-muxers --enable-avcodec --enable-avformat --enable-swresample --enable-swscale --enable-libdav1d --enable-libvpx --enable-libxml2
# make -j$(nproc)
# make install -j$(nproc)
# make clean
# #cd ../VapourSynth
# #PKG_CONFIG_PATH=$MYPKGPH CFLAGS="-I$OWN_PREFIX/include" CXXFLAGS="-I$OWN_PREFIX/include" LDFLAGS="-Wl,-Bsymbolic" meson setup --prefix=$OWN_PREFIX build .
# cd ..
# PKG_CONFIG_PATH=$MYPKGPH CFLAGS="-I$OWN_PREFIX/include" CXXFLAGS="-I$OWN_PREFIX/include" LDFLAGS="-Wl,-Bsymbolic" cmake -S . -G Ninja -B build_vs -DENABLE_VULKAN=OFF -DBUILD_AVS_PLUGIN=OFF
# cmake --build build_vs --config Release -j$(nproc)
# cmake --install build_vs --prefix $OWN_PREFIX
# # uninstall FFmpeg
# cd FFmpeg
# make uninstall -j$(nproc)
# popd
#
# # build l-smash exec
# # muxer remuxer boxdumper timelineeditor
# echo -e "\e[42m Build l-smash exec \e[0m"
# pushd l-smash
# make all -j$(nproc)
# make install -j$(nproc)
# make clean
# popd
#
# # build libvpx for ffmpeg-ffms2
# echo -e "\e[42m Build libvpx for ffmpeg \e[0m"
# pushd libvpx/builds
# PKG_CONFIG_PATH=$MYPKGPH ../configure --prefix=$OWN_PREFIX \
#     --disable-docs \
#     --disable-examples \
#     --disable-avx512 \
#     --disable-unit-tests \
#     --enable-pic \
#     --enable-postproc \
#     --enable-runtime-cpu-detect \
#     --enable-shared \
#     --enable-vp8 \
#     --enable-vp9 \
#     --enable-vp9-highbitdepth \
#     --enable-vp9-temporal-denoising
# make -j$(nproc)
# make install -j$(nproc)
# make clean
# popd

# # build ffmpeg 6.1.2 static libs for ffms2
# echo -e "\e[42m Build ffmpeg 6.1.2 \e[0m"
# #pacman --noconfirm -S amf-headers frei0r ladspa libass
# git clone https://git.ffmpeg.org/ffmpeg.git --branch n6.1.2 --depth 1
# pushd ffmpeg
# PKG_CONFIG_PATH=$MYPKGPH ./configure --prefix=$OWN_PREFIX \
#   --disable-doc \
#   --disable-network \
#   --disable-debug \
#   --disable-avx512 \
#   --disable-avx512icl \
#   --disable-shared \
#   --disable-programs \
#   --enable-static \
#   --enable-avcodec \
#   --enable-avformat \
#   --enable-avdevice \
#   --enable-avfilter \
#   --enable-swresample \
#   --enable-swscale\
#   --enable-gpl \
#   --enable-libdav1d \
#   --enable-libvpx \
#   --enable-libxml2 \
#   --enable-lzma \
#   --enable-nvdec \
#   --enable-version3
# make -j$(nproc)
# make install -j$(nproc)
# make clean
# popd

# # build ffms2
# echo -e "\e[42m Build ffms2 \e[0m"
# git clone --recursive https://github.com/FFMS/ffms2.git
# cd ffms2
# git checkout 25cef14386fcaaa58ee547065deee8f6e82c56a2
# PKG_CONFIG_PATH=$MYPKGPH LDFLAGS="-Wl,-Bsymbolic" CFLAGS="$NATIVE -I$MYICPH" CXXFLAGS="$NATIVE -I$MYICPH" ./autogen.sh --prefix=$OWN_PREFIX
# PKG_CONFIG_PATH=$MYPKGPH LDFLAGS="-Wl,-Bsymbolic" CFLAGS="$NATIVE -I$MYICPH" CXXFLAGS="$NATIVE -I$MYICPH" ./configure --prefix=$OWN_PREFIX
# make V=1 CXXFLAGS='-Werror -Wno-error=deprecated-declarations' -j$(nproc) -k
# make install
# make clean
# cd ..
#
# # uninstall ffmpeg build
# pushd ffmpeg
# make uninstall
# popd
#
# # build tcanny (don't use -march=native for build)
# echo -e "\e[42m Build tcanny \e[0m"
# git clone --recursive https://github.com/HomeOfVapourSynthEvolution/VapourSynth-TCanny.git --depth 1
# cd VapourSynth-TCanny
# CC=clang CXX=clang++ PKG_CONFIG_PATH=$MYPKGPH meson setup --prefix=$OWN_PREFIX build .
# ninja -C build
# ninja -C build install
# ninja -C build clean
# cd ..
#
# # build vs-dfttest2
# echo -e "\e[42m Build dfttest2 \e[0m"
# git clone --recursive https://github.com/AmusementClub/vs-dfttest2.git --depth 1
# cd vs-dfttest2
# CFLAGS=$NATIVE CXXFLAGS=$NATIVE PKG_CONFIG_PATH=$MYPKGPH cmake -S . -B build -GNinja -DVS_INCLUDE_DIR="$MYICPH/vapoursynth" -DENABLE_CUDA=ON -DUSE_NVRTC_STATIC=ON -DENABLE_CPU=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_COMPILER=g++-14 -DCMAKE_CXX_FLAGS="-Wall -ffast-math"
# cmake --build build --config Release --verbose
# cmake --install build --prefix $OWN_PREFIX
# ninja -C build clean
# mv dfttest2.py $VSFUNCPH
# cd ..
#
# # build boxblur
# echo -e "\e[42m Build boxblur \e[0m"
# git clone --recursive https://github.com/AmusementClub/vs-boxblur.git --depth 1
# cd vs-boxblur
# PKG_CONFIG_PATH=$MYPKGPH cmake -S . -B build -DCMAKE_INSTALL_PATH=$OWN_PREFIX -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS_RELEASE="-ffast-math -Wall $NATIVE"
# cmake --build build
# cmake --install build --prefix $OWN_PREFIX
# cd ..
#
# # build vsrawsource
# echo -e "\e[42m Build vsrawsource \e[0m"
# git clone --recursive https://github.com/AmusementClub/vsrawsource.git --depth 1
# cd vsrawsource
# PKG_CONFIG_PATH=$MYPKGPH meson setup --prefix=$OWN_PREFIX build .
# ninja -C build
# ninja -C build install
# ninja -C build clean
# cd ..

# build subtext
echo -e "\e[42m Build subtext \e[0m"
rm -rf subtext
git clone --recursive https://github.com/vapoursynth/subtext.git --depth 1
cd subtext
PKG_CONFIG_PATH=$MYPKGPH LDFLAGS="-Wl,-Bsymbolic" CFLAGS="$NATIVE -I$MYICPH" CXXFLAGS="$NATIVE -I$MYICPH" meson setup --prefix=$OWN_PREFIX build .
ninja -C build
ninja -C build install
ninja -C build clean
cd ..

# build bm3dcuda
echo -e "\e[42m Build bm3dcuda \e[0m"
git clone --recursive https://github.com/WolframRhodium/VapourSynth-BM3DCUDA --depth 1
cd VapourSynth-BM3DCUDA
PKG_CONFIG_PATH=$MYPKGPH cmake -S . -B build -GNinja -DUSE_NVRTC_STATIC=ON -DCMAKE_BUILD_TYPE=Release -DVAPOURSYNTH_INCLUDE_DIRECTORY="$MYICPH/vapoursynth" -DCMAKE_CXX_FLAGS="-Wall -ffast-math $NATIVE" -DCMAKE_CUDA_FLAGS="--threads 0 --use_fast_math --resource-usage -Wno-deprecated-gpu-targets" -DCMAKE_CUDA_ARCHITECTURES="50;61-real;70-virtual;75-real;86-real;89-real;90-real;100-real;120-real"
cmake --build build --verbose
cmake --install build --prefix $OWN_PREFIX
mv $OWN_PREFIX/lib/libbm3d* $VSPLGPH
cd ..

# build fmtc
echo -e "\e[42m Build fmtc \e[0m"
git clone https://gitlab.com/EleonoreMizo/fmtconv.git --depth 1
pushd fmtconv/build/unix
PKG_CONFIG_PATH=$MYPKGPH CFLAGS=$NATIVE CXXFLAGS=$NATIVE ./autogen.sh
PKG_CONFIG_PATH=$MYPKGPH CFLAGS=$NATIVE CXXFLAGS=$NATIVE ./configure --prefix=$OWN_PREFIX
make -j$(nproc)
make install
mv $OWN_PREFIX/lib/libfmtconv* $VSPLGPH
popd

# build bm3d
echo -e "\e[42m Build bm3d \e[0m"
git clone --recursive https://github.com/HomeOfVapourSynthEvolution/VapourSynth-BM3D --depth 1
cd VapourSynth-BM3D
PKG_CONFIG_PATH=$MYPKGPH CFLAGS=$NATIVE CXXFLAGS=$NATIVE meson setup --prefix=$OWN_PREFIX build .
ninja -C build
ninja -C build install
cd ..

# build dctfilter
echo -e "\e[42m Build dctfilter \e[0m"
git clone --recursive https://github.com/AmusementClub/VapourSynth-DCTFilter --depth 1
cd VapourSynth-DCTFilter
PKG_CONFIG_PATH=$MYPKGPH CFLAGS=$NATIVE CXXFLAGS=$NATIVE meson setup --prefix=$OWN_PREFIX build .
ninja -C build
ninja -C build install
cd ..

# build fft3dfilter
echo -e "\e[42m Build fft3dfilter \e[0m"
git clone --recursive https://github.com/AmusementClub/VapourSynth-FFT3DFilter --depth 1
cd VapourSynth-FFT3DFilter
PKG_CONFIG_PATH=$MYPKGPH CFLAGS=$NATIVE CXXFLAGS=$NATIVE meson setup --prefix=$OWN_PREFIX build .
ninja -C build
ninja -C build install
cd ..

# build descale & collect descale functions
# git clone https://github.com/AmusementClub/descale.git # error: core dump
echo -e "\e[42m Build descale \e[0m"
git clone https://github.com/Irrational-Encoding-Wizardry/descale --depth 1
cd descale
PKG_CONFIG_PATH=$MYPKGPH CFLAGS=$NATIVE CXXFLAGS=$NATIVE meson setup --prefix=$OWN_PREFIX build .
ninja -C build
ninja -C build install
mv descale.py $VSFUNCPH
cd ..

# build knlm
echo -e "\e[42m Build knlm \e[0m"
git clone --recursive https://github.com/pinterf/KNLMeansCL.git --depth 1
# please read readme_build.txt at first
cd KNLMeansCL
CC=clang CXX=clang++ PKG_CONFIG_PATH=$MYPKGPH meson setup --prefix=$OWN_PREFIX build .
ninja -C build
ninja -C build install
cd ..

# build knlm-cuda
echo -e "\e[42m Build knlm-cuda \e[0m"
git clone --recursive https://github.com/AmusementClub/vs-nlm-cuda --depth 1
cd vs-nlm-cuda
PKG_CONFIG_PATH=$MYPKGPH cmake -S . -B build -G Ninja -D VS_INCLUDE_DIR="$MYICPH/vapoursynth" -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS="-Wall -ffast-math" -DCMAKE_CUDA_FLAGS="--threads 0 --use_fast_math --resource-usage -Wno-deprecated-gpu-targets" -DCMAKE_CUDA_ARCHITECTURES="50;61-real;70-virtual;75-real;86-real;89-real;90-real;100-real;120-real"
cmake --build build --config Release --verbose
cmake --install build --prefix $OWN_PREFIX
cd ..

# build mvtools
echo -e "\e[42m Build mvtools \e[0m"
git clone --recursive https://github.com/dubhater/vapoursynth-mvtools --depth 1
cd vapoursynth-mvtools
PKG_CONFIG_PATH=$MYPKGPH CFLAGS=$NATIVE CXXFLAGS=$NATIVE meson setup --prefix=$OWN_PREFIX build .
ninja -C build
ninja -C build install
mv $OWN_PREFIX/lib/libmvtools* $VSPLGPH
cd ..

# build vsremovegrain
echo -e "\e[42m Build vsremovegrain \e[0m"
git clone --recursive https://github.com/vapoursynth/vs-removegrain --depth 1
cd vs-removegrain
PKG_CONFIG_PATH=$MYPKGPH CFLAGS=$NATIVE CXXFLAGS=$NATIVE meson setup --prefix=$OWN_PREFIX build .
ninja -C build
ninja -C build install
cd ..

# build Bilateral
echo -e "\e[42m Build Bilateral \e[0m"
git clone --recursive https://github.com/HomeOfVapourSynthEvolution/VapourSynth-Bilateral --depth 1
cd VapourSynth-Bilateral
PKG_CONFIG_PATH=$MYPKGPH ./configure --install="$VSPLGPH" --extra-cxxflags="$NATIVE"
make -j$(nproc)
make install
cd ..

# build BilateralGPU
echo -e "\e[42m Build BilateralGPU \e[0m"
git clone --recursive https://github.com/WolframRhodium/VapourSynth-BilateralGPU --depth 1
cd VapourSynth-BilateralGPU
PKG_CONFIG_PATH=$MYPKGPH cmake -S . -B build -G Ninja -LA -DCMAKE_BUILD_TYPE=Release -DUSE_NVRTC_STATIC=ON -DVAPOURSYNTH_INCLUDE_DIRECTORY="$MYICPH/vapoursynth" -DCMAKE_CXX_FLAGS="-Wall -ffast-math -march=$cpu" -DCMAKE_CUDA_FLAGS="--threads 0 --use_fast_math --resource-usage -Wno-deprecated-gpu-targets" -DCMAKE_CUDA_ARCHITECTURES="50;61-real;70-virtual;75-real;86-real;89-real;90-real;100-real;120-real"
cmake --build build --verbose
cmake --install build --prefix $OWN_PREFIX
mv $OWN_PREFIX/lib/libbilateralgpu* $VSPLGPH
cd ..

# build cas
echo -e "\e[42m Build CAS \e[0m"
git clone --recursive https://github.com/HomeOfVapourSynthEvolution/VapourSynth-CAS.git --depth 1 vs-cas
cd vs-cas
PKG_CONFIG_PATH=$MYPKGPH CFLAGS=$NATIVE CXXFLAGS=$NATIVE meson setup --prefix=$OWN_PREFIX build .
ninja -C build
ninja -C build install
cd ..

# build edgefixer
echo -e "\e[42m Build edgefixer \e[0m"
git clone --recursive https://github.com/sekrit-twc/EdgeFixer --depth 1
pushd EdgeFixer/EdgeFixer
gcc -O3 -ffast-math -Wall $NATIVE -I. -I"$MYICPH/vapoursynth" -shared -o libedgefixer.so edgefixer.c vsplugin.c -lm
install libedgefixer.so $VSPLGPH
popd

# build ctmf
echo -e "\e[42m Build ctmf \e[0m"
git clone --recursive https://github.com/HomeOfVapourSynthEvolution/VapourSynth-CTMF --depth 1
cd VapourSynth-CTMF
PKG_CONFIG_PATH=$MYPKGPH CFLAGS=$NATIVE CXXFLAGS=$NATIVE meson setup --prefix=$OWN_PREFIX build .
ninja -C build
ninja -C build install
cd ..

# build adaptivegrain
echo -e "\e[42m Build adaptivegrain \e[0m"
git clone https://github.com/kageru/adaptivegrain --depth 1
cd adaptivegrain
RUSTFLAGS="-C target-cpu=$cpu --emit asm" cargo build --release --target=x86_64-pc-linux-gnu --locked
install target/x86_64-pc-linux-gnu/release/libadaptivegrain_rs.so $VSPLGPH
cd ..

# build vs-tivtc
echo -e "\e[42m Build vs-tivtc \e[0m"
git clone --recursive https://github.com/dubhater/vapoursynth-tivtc --depth 1
cd vapoursynth-tivtc
PKG_CONFIG_PATH=$MYPKGPH CFLAGS=$NATIVE CXXFLAGS=$NATIVE meson setup --prefix=$OWN_PREFIX build .
ninja -C build
install build/libtivtc.so $VSPLGPH
cd ..

# build vivtc
echo -e "\e[42m Build vivtc \e[0m"
git clone --recursive https://github.com/vapoursynth/vivtc --depth 1
cd vivtc
CC=clang CXX=clang++ PKG_CONFIG_PATH=$MYPKGPH CFLAGS=$NATIVE CXXFLAGS=$NATIVE meson setup --prefix=$OWN_PREFIX build .
ninja -C build
install build/libvivtc.so $VSPLGPH
cd ..

# build eedi2
echo -e "\e[42m Build EEDI2 \e[0m"
git clone --recursive https://github.com/HomeOfVapourSynthEvolution/VapourSynth-EEDI2 --depth 1
cd VapourSynth-EEDI2
PKG_CONFIG_PATH=$MYPKGPH CFLAGS=$NATIVE CXXFLAGS=$NATIVE meson setup --prefix=$OWN_PREFIX build .
ninja -C build
install build/libeedi2.so $VSPLGPH
cd ..

# download eedi2cuda (https://github.com/fu-loser-ck/VapourSynth-EEDI2CUDA)
echo -e "\e[42m Download eedi2cuda \e[0m"
wget https://github.com/fu-loser-ck/VapourSynth-EEDI2CUDA/releases/download/240124/libEEDI2CUDA.7z
7z x libEEDI2CUDA.7z
install libEEDI2CUDA.so $VSPLGPH

# build eedi3
echo -e "\e[42m Build eedi3 \e[0m"
git clone --recursive https://github.com/HomeOfVapourSynthEvolution/VapourSynth-EEDI3 --depth 1
cd VapourSynth-EEDI3
PKG_CONFIG_PATH=$MYPKGPH CFLAGS=$NATIVE CXXFLAGS=$NATIVE meson setup --prefix=$OWN_PREFIX build .
ninja -C build
install build/libeedi3m.so $VSPLGPH
cd ..

# build sangnom
echo -e "\e[42m Build sangnom \e[0m"
git clone --recursive https://github.com/dubhater/vapoursynth-sangnom --depth 1
cd vapoursynth-sangnom
PKG_CONFIG_PATH=$MYPKGPH CFLAGS=$NATIVE CXXFLAGS=$NATIVE meson setup --prefix=$OWN_PREFIX build .
ninja -C build
install build/libsangnom.so $VSPLGPH
cd ..

# build vs-miscfilters-obsolete
echo -e "\e[42m Build vs-miscfilters-obsolete \e[0m"
git clone --recursive https://github.com/vapoursynth/vs-miscfilters-obsolete --depth 1
cd vs-miscfilters-obsolete
PKG_CONFIG_PATH=$MYPKGPH CFLAGS=$NATIVE CXXFLAGS=$NATIVE meson setup --prefix=$OWN_PREFIX build .
ninja -C build
ninja -C build install
cd ..

# build ttempsmooth
echo -e "\e[42m Build ttempsmooth \e[0m"
git clone --recursive https://github.com/HomeOfVapourSynthEvolution/VapourSynth-TTempSmooth --depth 1
cd VapourSynth-TTempSmooth
PKG_CONFIG_PATH=$MYPKGPH CFLAGS=$NATIVE CXXFLAGS=$NATIVE meson setup --prefix=$OWN_PREFIX build .
ninja -C build
ninja -C build install
cd ..

# build bwdif
echo -e "\e[42m Build bwdif \e[0m"
git clone --recursive https://github.com/HomeOfVapourSynthEvolution/VapourSynth-Bwdif --depth 1
cd VapourSynth-Bwdif
PKG_CONFIG_PATH=$MYPKGPH CFLAGS=$NATIVE CXXFLAGS=$NATIVE meson setup --prefix=$OWN_PREFIX build .
ninja -C build
ninja -C build install
cd ..

# build yadifmod
echo -e "\e[42m Build yadifmod \e[0m"
git clone --recursive https://github.com/HomeOfVapourSynthEvolution/VapourSynth-Yadifmod --depth 1
cd VapourSynth-Yadifmod
PKG_CONFIG_PATH=$MYPKGPH CFLAGS=$NATIVE CXXFLAGS=$NATIVE meson setup --prefix=$OWN_PREFIX build .
ninja -C build
ninja -C build install
cd ..

# build deblock
echo -e "\e[42m Build deblock \e[0m"
git clone --recursive https://github.com/HomeOfVapourSynthEvolution/VapourSynth-Deblock --depth 1
cd VapourSynth-Deblock
PKG_CONFIG_PATH=$MYPKGPH CFLAGS=$NATIVE CXXFLAGS=$NATIVE meson setup --prefix=$OWN_PREFIX build .
ninja -C build
ninja -C build install
cd ..

# build addgrain
echo -e "\e[42m Build AddGrain \e[0m"
git clone --recursive https://github.com/HomeOfVapourSynthEvolution/VapourSynth-AddGrain --depth 1
cd VapourSynth-AddGrain
CC=clang CXX=clang++ PKG_CONFIG_PATH=$MYPKGPH CFLAGS=$NATIVE CXXFLAGS=$NATIVE meson setup --prefix=$OWN_PREFIX build .
ninja -C build
ninja -C build install
cd ..

# build neo_fft3d
echo -e "\e[42m Build neo_fft3d \e[0m"
cp $MYICPH/avisynth/*.h $MYICPH
cp -r $MYICPH/avisynth/avs $MYICPH
git clone --recursive https://github.com/HomeOfAviSynthPlusEvolution/neo_FFT3D --depth 1
cd neo_FFT3D
PKG_CONFIG_PATH=$MYPKGPH CFLAGS=$NATIVE CXXFLAGS=$NATIVE cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build --verbose
install build/libneo-fft3d.so $VSPLGPH
cd ..

# build wwxd
echo -e "\e[42m Build wwxd \e[0m"
git clone --recursive https://github.com/dubhater/vapoursynth-wwxd --depth 1
cd vapoursynth-wwxd
gcc -O3 -ffast-math -Wall -march=$cpu -I. -I"$MYICPH/vapoursynth" -fPIC -Wall -Wextra -Wno-unused-parameter -shared -o libwwxd.so src/wwxd.c src/detection.c -lm
install libwwxd.so $VSPLGPH
cd ..

# build awarpsharp2
echo -e "\e[42m Build awarpsharp2 \e[0m"
git clone --recursive https://github.com/dubhater/vapoursynth-awarpsharp2 --depth 1
cd vapoursynth-awarpsharp2
PKG_CONFIG_PATH=$MYPKGPH CFLAGS=$NATIVE CXXFLAGS=$NATIVE meson setup --prefix=$OWN_PREFIX build .
ninja -C build
install build/libawarpsharp2.so $VSPLGPH
cd ..

# build fluxsmooth
echo -e "\e[42m Build fluxsmooth \e[0m"
git clone --recursive https://github.com/dubhater/vapoursynth-fluxsmooth --depth 1
cd vapoursynth-fluxsmooth
PKG_CONFIG_PATH=$MYPKGPH CFLAGS=$NATIVE CXXFLAGS=$NATIVE ./autogen.sh
PKG_CONFIG_PATH=$MYPKGPH CFLAGS=$NATIVE CXXFLAGS=$NATIVE ./configure --prefix=$OWN_PREFIX
make -j$(nproc)
install .libs/libfluxsmooth.* $VSPLGPH
cd ..

# build neo_f3kdb
echo -e "\e[42m Build neo_f3kdb \e[0m"
git clone --recursive https://github.com/HomeOfAviSynthPlusEvolution/neo_f3kdb.git --depth 1
cd neo_f3kdb
PKG_CONFIG_PATH=$MYPKGPH CFLAGS=$NATIVE CXXFLAGS=$NATIVE cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build --config Release --verbose -j $(nproc)
install build/libneo-f3kdb.so $VSPLGPH
cd ..

# build nnedi3
echo -e "\e[42m Build nnedi3 \e[0m"
git clone --recursive https://github.com/dubhater/vapoursynth-nnedi3 --depth 1
cd vapoursynth-nnedi3
PKG_CONFIG_PATH=$MYPKGPH CFLAGS=$NATIVE CXXFLAGS=$NATIVE ./autogen.sh
PKG_CONFIG_PATH=$MYPKGPH CFLAGS=$NATIVE CXXFLAGS=$NATIVE ./configure --prefix=$OWN_PREFIX
make -j$(nproc)
install .libs/libnnedi3* $VSPLGPH
install src/nnedi3_weights.bin $VSPLGPH
cd ..

# build znedi3
echo -e "\e[42m Build znedi3 \e[0m"
git clone --recursive https://github.com/sekrit-twc/znedi3 --depth 1
cd znedi3
CFLAGS=$NATIVE CXXFLAGS=$NATIVE make X86=1 -j$(nproc)
install vsznedi3.so $VSPLGPH
cd ..

# build nnedi3cl
echo -e "\e[42m Build nnedi3cl \e[0m"
git clone --recursive https://github.com/HomeOfVapourSynthEvolution/VapourSynth-NNEDI3CL --depth 1
cd VapourSynth-NNEDI3CL
PKG_CONFIG_PATH=$MYPKGPH CFLAGS=$NATIVE CXXFLAGS=$NATIVE meson setup --prefix=$OWN_PREFIX build .
ninja -C build
ninja -C build install
cd ..

# build rgfs
echo -e "\e[42m Build rgfs \e[0m"
git clone --recursive https://github.com/IFeelBloated/RGSF --depth 1
cd RGSF
g++ -Wall -shared -o librgsf.so *.cpp -O3 -march=$cpu
install librgsf.so $VSPLGPH
cd ..

# install assrender
echo -e "\e[42m Install assrender \e[0m"
wget https://github.com/kskshaf/assrender/releases/download/custom/assrender_linux-x64_100f77d.zip
7z x assrender_linux-x64_100f77d.zip
install libassrender.so $VSPLGPH
cd ..

# build vs-imwri
echo -e "\e[42m Build vs-imwri \e[0m"
git clone --recursive https://github.com/vapoursynth/vs-imwri --depth 1
cd vs-imwri
PKG_CONFIG_PATH=$MYPKGPH CFLAGS=$NATIVE CXXFLAGS=$NATIVE meson setup --prefix=$OWN_PREFIX build .
ninja -C build
install build/libimwri.so $VSPLGPH
cd ..

# build vfrtocrf
echo -e "\e[42m Build vfrtocrf \e[0m"
git clone --recursive https://github.com/Irrational-Encoding-Wizardry/Vapoursynth-VFRToCFR --depth 1
cd Vapoursynth-VFRToCFR
PKG_CONFIG_PATH=$MYPKGPH CFLAGS=$NATIVE CXXFLAGS=$NATIVE meson setup --prefix=$OWN_PREFIX build .
ninja -C build
ninja -C build install
cd ..

# build vs-compareplane
echo -e "\e[42m Build vs-compareplane \e[0m"
git clone --recursive https://github.com/AmusementClub/vs-compareplane --depth 1
cd vs-compareplane
PKG_CONFIG_PATH=$MYPKGPH CXX=clang++ CFLAGS=$NATIVE CXXFLAGS=$NATIVE meson setup --prefix=$OWN_PREFIX build .
ninja -C build
ninja -C build install
cd ..

# build vs-hqdn3d
echo -e "\e[42m Build vs-hqdn3d \e[0m"
git clone https://github.com/Hinterwaeldlers/vapoursynth-hqdn3d --depth 1
cd vapoursynth-hqdn3d
PKG_CONFIG_PATH=$MYPKGPH CFLAGS=$NATIVE CXXFLAGS=$NATIVE ./autogen.sh
PKG_CONFIG_PATH=$MYPKGPH CFLAGS=$NATIVE CXXFLAGS=$NATIVE ./configure
make -j$(nproc)
install .libs/libhqdn3d* $VSPLGPH
cd ..


# build f3kdb
# echo -e "\e[42m Build f3kdb \e[0m"
# /build_f3kdb.sh

# build x264_mod
echo -e "\e[42m Build x264_mod \e[0m"
git clone https://github.com/jpsdr/x264 --branch t_mod_New --depth 1
cd x264
./configure --prefix=$OWN_PREFIX --extra-cflags="$NATIVE -mno-avx512f" --disable-interlaced --disable-opencl --enable-lto --enable-strip --disable-avs --disable-swscale --disable-lavf --disable-ffms --disable-avi-output --disable-gpac --disable-lsmash --disable-audio --disable-qtaac --disable-faac --disable-mp3 --disable-lavc
make -j$(nproc)
install -m 775 ./x264 $OWN_PREFIX/bin
cd ..

# build x265-mod
#echo -e "\e[42m Build x265-mod \e[0m"
#git clone https://github.com/kskshaf/x265_mod.git --branch stable
#cd x265_mod/build
#mkdir -p 10b
# build x265 10b
#cd 10b
#cmake -GNinja ../../source -DHIGH_BIT_DEPTH=ON -DENABLE_SHARED=OFF -DUSE_LTO=ON -DTARGET_CPU=$cpu -DCMAKE_CXX_FLAGS="-fprofile-generate=profd -fprofile-update=atomic"
#ninja
#chmod +x x265
#./x265 -V
#ninja clean
#cmake -GNinja ../../source -DHIGH_BIT_DEPTH=ON -DENABLE_SHARED=OFF -DUSE_LTO=ON -DTARGET_CPU=$cpu -DCMAKE_CXX_FLAGS="-fprofile-use=profd"
#ninja
#strip -s x265
#install -m 775 ./x265 $OWN_PREFIX/bin
#ninja clean
#cd $HOME

# build vs-edit
echo -e "\e[42m Build vs-edit \e[0m"
git clone https://github.com/YomikoR/VapourSynth-Editor --branch r19-mod-6.3 --depth 1
cd VapourSynth-Editor/pro
PKG_CONFIG_PATH=$MYPKGPH CFLAGS="$NATIVE -I$MYICPH" CXXFLAGS="$NATIVE -I$MYICPH" qmake6 -norecursive pro.pro CONFIG+=release
PKG_CONFIG_PATH=$MYPKGPH CFLAGS="$NATIVE -I$MYICPH" CXXFLAGS="$NATIVE -I$MYICPH" make -j$(nproc)
mv ../build/release-64bit-gcc $OWN_PREFIX/bin/vsedit
make clean

cd $HOME

# Collect functions
echo -e "\e[42m Collect functions \e[0m"
git clone https://github.com/dubhater/vapoursynth-adjust
mv vapoursynth-adjust/*.py $VSFUNCPH

git clone https://github.com/HomeOfVapourSynthEvolution/nnedi3_resample
mv nnedi3_resample/*.py $VSFUNCPH

git clone https://github.com/fdar0536/VapourSynth-Contra-Sharpen-mod csmod
mv csmod/*.py $VSFUNCPH

git clone https://github.com/xyx98/my-vapoursynth-script xyx98-vsfunc
mv xyx98-vsfunc/*.py $VSFUNCPH

git clone https://github.com/Mr-Z-2697/z-vsPyScripts
mv z-vsPyScripts/zvs.py $VSFUNCPH

git clone https://gist.github.com/8676fd350d4b5b223ab9.git
mv 8676fd350d4b5b223ab9/*.py $VSFUNCPH

git clone https://github.com/Irrational-Encoding-Wizardry/kagefunc
mv kagefunc/kagefunc.py $VSFUNCPH

git clone https://github.com/Irrational-Encoding-Wizardry/fvsfunc
mv fvsfunc/*.py $VSFUNCPH

git clone https://github.com/HomeOfVapourSynthEvolution/vsTAAmbk
mv vsTAAmbk/*.py $VSFUNCPH

git clone https://github.com/OpusGang/adptvgrnMod
mv adptvgrnMod/*.py $VSFUNCPH

git clone https://github.com/OpusGang/rekt
mv rekt/src/rekt $VSFUNCPH

git clone https://github.com/DJATOM/VapourSynth-atomchtools
mv VapourSynth-atomchtools/*.py $VSFUNCPH

git clone https://github.com/HomeOfVapourSynthEvolution/havsfunc
cd havsfunc
git checkout 7f0a9a7a37b60a05b9f408024d203e511e544a61
mv *.py $VSFUNCPH
cd ..

git clone https://github.com/WolframRhodium/muvsfunc
mv muvsfunc/*.py $VSFUNCPH

git clone https://github.com/SAPikachu/igstools
mv igstools/igstools $VSFUNCPH

git clone https://github.com/HomeOfVapourSynthEvolution/mvsfunc
mv mvsfunc/mvsfunc $VSFUNCPH

git clone https://github.com/Irrational-Encoding-Wizardry/vsutil
mv vsutil/vsutil $VSFUNCPH

git clone https://github.com/Infiziert90/getnative
mv getnative/getnative $VSFUNCPH

# Pack
tar -czvf build.tar.gz $OWN_PREFIX
