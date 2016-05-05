TERMUX_PKG_HOMEPAGE=https://www.ffmpeg.org/
TERMUX_PKG_DESCRIPTION="Tools and libraries to manipulate a wide range of multimedia formats and protocols"
TERMUX_PKG_VERSION=3.0.2
TERMUX_PKG_BUILD_REVISION=1
TERMUX_PKG_SRCURL=https://www.ffmpeg.org/releases/ffmpeg-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_FOLDERNAME=ffmpeg-$TERMUX_PKG_VERSION
# libbz2 is used by matroska decoder:
TERMUX_PKG_DEPENDS="openssl, libbz2, libx264, xvidcore, libvorbis, libfaac, libmp3lame, liblzma"
TERMUX_PKG_INCLUDE_IN_DEVPACKAGE="share/ffmpeg/examples"
TERMUX_PKG_CONFLICTS="libav"

termux_step_configure () {
	cd $TERMUX_PKG_BUILDDIR

	local _EXTRA_CONFIGURE_FLAGS=""
	if [ $TERMUX_ARCH = "arm" ]; then
		_ARCH="armeabi-v7a"
		_EXTRA_CONFIGURE_FLAGS="--enable-neon"
	elif [ $TERMUX_ARCH = "i686" ]; then
		_ARCH="x86"
		# Specify --disable-asm to prevent text relocations on i686,
		# see https://trac.ffmpeg.org/ticket/4928
		_EXTRA_CONFIGURE_FLAGS="--disable-asm"
	elif [ $TERMUX_ARCH = "aarch64" ]; then
		_ARCH=$TERMUX_ARCH
		_EXTRA_CONFIGURE_FLAGS="--enable-neon"
	else
		echo "Unsupported arch $TERMUX_ARCH"
		exit 1
	fi

	$TERMUX_PKG_SRCDIR/configure \
		--arch=${_ARCH} \
		--cross-prefix=${TERMUX_HOST_PLATFORM}- \
		--disable-avdevice \
		--disable-ffserver \
		--disable-static \
                --disable-symver \
		--enable-cross-compile \
		--enable-gpl \
		--enable-libmp3lame \
		--enable-libfaac \
		--enable-libvorbis \
		--enable-libx264 \
		--enable-libxvid \
		--enable-nonfree \
		--enable-openssl \
		--enable-shared \
		--prefix=$TERMUX_PREFIX \
		--target-os=linux \
		$_EXTRA_CONFIGURE_FLAGS
}

