TERMUX_PKG_HOMEPAGE=http://www.seehuhn.de/pages/moon-buggy
TERMUX_PKG_DESCRIPTION="Simple game where you drive a car across the moon's surface"
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_VERSION=1.0.51
# Main site down 2017-01-06.
# TERMUX_PKG_SRCURL=http://m.seehuhn.de/programs/moon-buggy-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SRCURL=ftp://ftp.netbsd.org/pub/pkgsrc/distfiles/moon-buggy-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--sharedstatedir=$TERMUX_PREFIX/var"

termux_step_make_install () {
	mkdir -p $TERMUX_PREFIX/share/man/man6
	cp moon-buggy $TERMUX_PREFIX/bin
	cp moon-buggy.6 $TERMUX_PREFIX/share/man/man6
}
