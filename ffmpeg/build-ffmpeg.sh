#!/bin/sh

set -eu

PRETTY_NAME=ffmpeg
MAJOR=7
MINOR=1
PATCH=1
VERSION=7.1.1

DESTDIR="$PWD/temporary-destdir"
[ -d $DESTDIR ] || mkdir -p $DESTDIR

curl --location --remote-name --skip-existing https://dev.gentoo.org/~chewi/distfiles/ffmpeg-rpi-$VERSION.patch
curl --location --remote-name --skip-existing https://ffmpeg.org/releases/ffmpeg-$VERSION.tar.xz

xz -cd ffmpeg-$VERSION.tar.xz | tar -x
cd ffmpeg-$VERSION

# See the way Gentoo handles this
patch -p1 < ../ffmpeg-rpi-$VERSION.patch

./configure \
	--prefix=/usr \
	--disable-debug \
	--disable-epoxy \
	--disable-libwebp \
	--disable-libxcb \
	--disable-libxml2 \
	--disable-lzma \
	--disable-network \
	--disable-openssl \
	--disable-bzlib \
	--disable-xlib \
	--disable-zlib \
	--disable-sdl2 \
	--enable-shared \
	--enable-static \
	--enable-stripping \
	--enable-optimizations \
	--enable-alsa \
	--enable-gpl \
	--enable-libass \
	--enable-libdrm \
	--enable-libmp3lame \
	--enable-libopus \
	--enable-libvpx \
	--enable-libvorbis \
	--enable-libxvid \
	--enable-libx264 \
	--enable-libx265 \
	--enable-libudev \
	--enable-sand \
	--enable-v4l2-request \
	--enable-nonfree

make
make DESTDIR=$DESTDIR install

rm -rf "$DESTDIR/usr/share/ffmpeg/examples"

doas chown -R root:root $DESTDIR
cd $DESTDIR
doas sh -c "tar -cf - * | gzip > ../Media-ffmpeg@$VERSION.tar.gz"
doas rm -rf $DESTDIR
