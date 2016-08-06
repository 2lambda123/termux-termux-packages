TERMUX_PKG_VERSION=0.5
TERMUX_PKG_HOMEPAGE=https://github.com/radare/ired
TERMUX_PKG_SRCURL=https://github.com/radare/ired/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_FOLDERNAME=ired-${TERMUX_PKG_VERSION}
TERMUX_PKG_DESCRIPTION="Minimalist hexadecimal editor"

termux_step_make () {
	cd ../src
	make
	make install PREFIX=${TERMUX_PREFIX}
}
