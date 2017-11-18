TERMUX_PKG_HOMEPAGE=https://www.nano-editor.org/
TERMUX_PKG_DESCRIPTION="Small, free and friendly text editor"
TERMUX_PKG_VERSION=2.9.0
TERMUX_PKG_SHA256=d2d30c39caef53aba1ec1b4baff4186d4496f35d2411b0848242a5f2e27e129e
TERMUX_PKG_SRCURL=https://www.nano-editor.org/dist/v${TERMUX_PKG_VERSION:0:3}/nano-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libandroid-support, libandroid-glob, ncurses"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-libmagic
--enable-utf8
--with-wordbounds
"
TERMUX_PKG_RM_AFTER_INSTALL="bin/rnano share/man/man1/rnano.1 share/nano/man-html"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}

termux_step_post_make_install () {
	# Configure nano to use syntax highlighting:
	NANORC=$TERMUX_PREFIX/etc/nanorc
	echo include \"$TERMUX_PREFIX/share/nano/\*nanorc\" > $NANORC
}
