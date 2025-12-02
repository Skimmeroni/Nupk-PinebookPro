#!/bin/sh

set -eu

PRETTY_NAME=mesa
MAJOR=25
MINOR=2
PATCH=5
VERSION=25.2.5

DESTDIR="$PWD/temporary-destdir"
[ -d $DESTDIR ] || mkdir -p $DESTDIR

curl --location --remote-name --skip-existing https://archive.mesa3d.org/mesa-$VERSION.tar.xz

xz -cd mesa-$VERSION.tar.xz | tar -x
cd mesa-$VERSION

# Mesa is, as of now, a project too complex for muon to handle.
# To be fair, to build mesa you need Python anyway...

# default_library=both doesn't do anything

# Vulkan is disabled until Panfrost supports it on the Pinebook Pro
# (if it ever will)
meson setup \
	-D prefix=/usr \
	-D buildtype=release \
	-D default_library=both \
	-D platforms=wayland \
	-D egl-native-platform=wayland \
	-D expat=enabled \
	-D gallium-drivers=panfrost \
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
	-D video-codecs=all \
	-D mesa-clc=enabled \
	-D precomp-compiler=enabled \
	build

meson compile -C build
meson install -C build --destdir "$DESTDIR"

find $DESTDIR -name '*.a'   -type f -exec strip --strip-unneeded {} \;
find $DESTDIR -name '*.so*' -type f -exec strip --strip-unneeded {} \;

doas chown -R root:root $DESTDIR
cd $DESTDIR
doas sh -c "tar -cf - * | gzip > ../Wayland-mesa@$VERSION.tar.gz"
doas rm -rf $DESTDIR
