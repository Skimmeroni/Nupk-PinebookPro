#!/bin/sh

set -eu

PRETTY_NAME=linux
MAJOR=6
MINOR=16
PATCH=1
VERSION=6.16.1

DESTDIR="$PWD/temporary-destdir"
[ -d $DESTDIR ] || mkdir -p $DESTDIR

curl --location --remote-name --skip-existing https://mirrors.edge.kernel.org/pub/linux/kernel/v$MAJOR.x/linux-$VERSION.tar.xz

xz -cd linux-$VERSION.tar.xz | tar -x
cd linux-$VERSION

mv ../pinebook-pro-config .config
make olddefconfig

make Image
make dtbs

install -Dm644 ../extlinux.conf "$DESTDIR/boot/extlinux/extlinux.conf"
cp arch/arm64/boot/Image "$DESTDIR/boot/Image"
make INSTALL_DTBS_PATH="$DESTDIR/boot/dtbs" dtbs_install

if [ $(grep -w 'CONFIG_MODULES' .config) == "CONFIG_MODULES=y" ]
then
	make modules
	make INSTALL_MOD_STRIP=1 INSTALL_MOD_PATH=$DESTDIR/usr modules_install
fi

doas chown -R root:root $DESTDIR
cd $DESTDIR
doas sh -c "tar -cf - * | gzip > ../Base-linux@$VERSION.tar.gz"
doas rm -rf $DESTDIR
