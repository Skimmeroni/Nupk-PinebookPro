#!/bin/sh -e

PRETTY_NAME=mesa
MAJOR=25
MINOR=2
PATCH=5
VERSION=25.2.5

if [ ! -f $0 ]; then return; fi

mkdir temporary-builddir
DESTDIR="$PWD/temporary-builddir"

curl --location --remote-name --skip-existing https://archive.mesa3d.org/mesa-$VERSION.tar.xz

xz -cd mesa-$VERSION.tar.xz | tar -x
cd mesa-$VERSION

patch -p1 < ../bypass-failing-check-for-muon.patch
sed '/rust_std=2021/d' meson.build > meson.build.new
mv meson.build.new meson.build

# TODO: precomp-compiler?
# TODO: rust?

muon setup \
	-D prefix=/usr \
	-D buildtype=release \
	-D default_library=both \
	-D platforms=wayland \
	-D egl-native-platform=wayland \
	-D expat=enabled \
	-D gallium-drivers=panfrost \
	-D gallium-va=enabled \
	-D vulkan-drivers='' \
	-D gles1=enabled \
	-D gles2=enabled \
	-D opengl=true \
	-D glx=disabled \
	-D egl=enabled \
	-D glvnd=enabled \
	-D llvm=enabled \
	-D lmsensors=disabled \
	-D build-tests=false \
	-D enable-glcpp-tests=false \
	-D html-docs=disabled \
	-D tools='' \
	-D zstd=disabled \
	-D zlib=enabled \
	-D video-codecs=all_free \
	-D mesa-clc=enabled \
	-D precomp-compiler=enabled \
	build

ninja -C build
muon -C build install -d "$DESTDIR"

doas chown -R root:root $DESTDIR
doas sh -c "tar -zcC $DESTDIR . | gzip > ../mesa@$VERSION.tar.gz"
CALLER_UID=$(id -un)
CALLER_GID=$(id -gn)
doas chown -R $CALLER_UID:$CALLER_GID $DESTDIR
