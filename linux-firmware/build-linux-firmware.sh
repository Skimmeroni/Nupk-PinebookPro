#!/bin/sh -e

PRETTY_NAME=linux-firmware
MAJOR=
MINOR=
PATCH=
VERSION=git

if [ ! -f $0 ]; then return; fi

mkdir temporary-destdir
DESTDIR="$PWD/temporary-destdir"

git clone https://github.com/armbian/firmware.git

# As I understand it, different batches of PBs have slightly different
# chipsets, using different firmwares. These two flavours are those that
# I am aware of

install -Dm644 firmware/brcm/brcmfmac43455-sdio.bin      "$DESTDIR/usr/lib/firmware/brcm/brcmfmac43455-sdio.bin"
install -Dm644 firmware/brcm/brcmfmac43455-sdio.clm_blob "$DESTDIR/usr/lib/firmware/brcm/brcmfmac43455-sdio.clm_blob"
install -Dm644 firmware/brcm/brcmfmac43455-sdio.txt      "$DESTDIR/usr/lib/firmware/brcm/brcmfmac43455-sdio.txt"
install -Dm644 firmware/BCM4345C0.hcd                    "$DESTDIR/usr/lib/firmware/brcm/BCM4345C0.hcd"
sed 's/ccode=DE/ccode=all/' "$DESTDIR/usr/lib/firmware/brcm/brcmfmac43455-sdio.txt" > "$DESTDIR/usr/lib/firmware/brcm/brcmfmac43455-sdio.txt.new"
mv "$DESTDIR/usr/lib/firmware/brcm/brcmfmac43455-sdio.txt.new" "$DESTDIR/usr/lib/firmware/brcm/brcmfmac43455-sdio.txt"

install -Dm644 firmware/brcm/brcmfmac43456-sdio.bin      "$DESTDIR/usr/lib/firmware/brcm/brcmfmac43456-sdio.bin"
install -Dm644 firmware/brcm/brcmfmac43456-sdio.clm_blob "$DESTDIR/usr/lib/firmware/brcm/brcmfmac43456-sdio.clm_blob"
install -Dm644 firmware/brcm/brcmfmac43456-sdio.txt      "$DESTDIR/usr/lib/firmware/brcm/brcmfmac43456-sdio.txt"
install -Dm644 firmware/BCM4345C5.hcd                    "$DESTDIR/usr/lib/firmware/brcm/BCM4345C5.hcd"
sed -i 's/ccode=DE/ccode=all/' "$DESTDIR/usr/lib/firmware/brcm/brcmfmac43456-sdio.txt" > "$DESTDIR/usr/lib/firmware/brcm/brcmfmac43456-sdio.txt.new"
mv "$DESTDIR/usr/lib/firmware/brcm/brcmfmac43456-sdio.txt.new" "$DESTDIR/usr/lib/firmware/brcm/brcmfmac43456-sdio.txt"

doas chown -R root:root $DESTDIR
doas sh -c "tar -zcC $DESTDIR . | gzip > ../linux-firmware@$VERSION.tar.gz"
CALLER_UID=$(id -un)
CALLER_GID=$(id -gn)
doas chown -R $CALLER_UID:$CALLER_GID $DESTDIR
