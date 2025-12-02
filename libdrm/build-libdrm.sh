#!/bin/sh

set -eu

PRETTY_NAME=libdrm
MAJOR=2
MINOR=4
PATCH=129
VERSION=2.4.129

DESTDIR="$PWD/temporary-destdir"
[ -d $DESTDIR ] || mkdir -p $DESTDIR

curl --location --remote-name --skip-existing https://dri.freedesktop.org/libdrm/libdrm-$VERSION.tar.xz

xz -cd libdrm-$VERSION.tar.xz | tar -x
cd libdrm-$VERSION

muon setup \
	-D prefix=/usr \
	-D libdir=/usr/lib \
	-D buildtype=release \
	-D default_library=both \
	-D udev=false \
	-D cairo-tests=disabled \
	-D tests=false \
	-D man-pages=disabled \
	-D intel=disabled \
	-D radeon=disabled \
	-D amdgpu=disabled \
	-D nouveau=disabled \
	-D vmwgfx=disabled \
	-D omap=disabled \
	-D exynos=disabled \
	-D freedreno=disabled \
	-D tegra=disabled \
	-D vc4=disabled \
	-D etnaviv=disabled \
	build

ninja -C build
muon -C build install -d "$DESTDIR"

find "$DESTDIR/usr/lib" -type f -name '*.a'   -exec strip --strip-unneeded {} \;
find "$DESTDIR/usr/lib" -type f -name '*.so*' -exec strip --strip-unneeded {} \;

doas chown -R root:root $DESTDIR
cd $DESTDIR
doas sh -c "tar -cf - * | gzip > ../Wayland-libdrm@$VERSION.tar.gz"
doas rm -rf $DESTDIR
