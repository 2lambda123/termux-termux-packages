TERMUX_PKG_HOMEPAGE=http://proot.me/
TERMUX_PKG_DESCRIPTION="Emulate chroot, bind mount and binfmt_misc for non-root users"
TERMUX_PKG_VERSION=5.1.0
TERMUX_PKG_SRCURL=https://github.com/proot-me/PRoot/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_FOLDERNAME=PRoot-${TERMUX_PKG_VERSION}
TERMUX_PKG_DEPENDS="libtalloc"

export LD=$CC

termux_step_make_install () {
	export CROSS_COMPILE=${TERMUX_HOST_PLATFORM}-

	cd $TERMUX_PKG_SRCDIR/src
	make V=1
	make install

	mkdir -p $TERMUX_PREFIX/share/man/man1
	cp $TERMUX_PKG_SRCDIR/doc/proot/man.1 $TERMUX_PREFIX/share/man/man1/proot.1
}
