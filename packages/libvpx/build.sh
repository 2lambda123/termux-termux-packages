TERMUX_PKG_HOMEPAGE=https://www.webmproject.org
TERMUX_PKG_DESCRIPTION="VP8 & VP9 Codec SDK"
TERMUX_PKG_VERSION=1.6.0
TERMUX_PKG_BUILD_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/webmproject/libvpx/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_FOLDERNAME=libvpx-${TERMUX_PKG_VERSION}

termux_step_configure () {
	# Force fresh install of header files:
	rm -Rf $TERMUX_PREFIX/include/vpx

	if [ $TERMUX_ARCH = "arm" ]; then
		_CONFIGURE_TARGET="--target=armv7-android-gcc"
	elif [ $TERMUX_ARCH = "i686" ]; then
		export AS=yasm
		export LD=$CC
		_CONFIGURE_TARGET="--target=x86-android-gcc"
	elif [ $TERMUX_ARCH = "aarch64" ]; then
		_CONFIGURE_TARGET="--force-target=arm64-v8a-android-gcc"
	elif [ $TERMUX_ARCH = "x86_64" ]; then
		export AS=yasm
		export LD=$CC
		_CONFIGURE_TARGET="--target=x86_64-android-gcc"
	else
		echo "Unsupported arch: $TERMUX_ARCH"
		exit 1
	fi

	# For --disable-realtime-only, see
	# https://bugs.chromium.org/p/webm/issues/detail?id=800
	# "The issue is that on android we soft enable realtime only.
	#  [..] You can enable non-realtime by setting --disable-realtime-only"
	# Discovered in https://github.com/termux/termux-packages/issues/554
	$TERMUX_PKG_SRCDIR/configure \
		--sdk-path=$NDK \
		$_CONFIGURE_TARGET \
		--prefix=$TERMUX_PREFIX \
		--disable-examples \
		--disable-realtime-only \
		--enable-vp8 \
		--enable-shared \
		--enable-small
}
