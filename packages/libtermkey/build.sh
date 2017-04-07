TERMUX_PKG_HOMEPAGE=http://www.leonerd.org.uk/code/libtermkey/
TERMUX_PKG_DESCRIPTION="Library for processing of keyboard entry for terminal-based programs"
TERMUX_PKG_VERSION=0.19
TERMUX_PKG_SRCURL=http://www.leonerd.org.uk/code/libtermkey/libtermkey-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c505aa4cb48c8fa59c526265576b97a19e6ebe7b7da20f4ecaae898b727b48b7
TERMUX_PKG_DEPENDS="libunibilium"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_make () {
	return
}

termux_step_make_install () {
	CFLAGS+=" -std=c99 -DHAVE_UNIBILIUM=1"
	$CC $CFLAGS $CPPFLAGS -c -fPIC termkey.c -o termkey.o
	$CC $CFLAGS $CPPFLAGS -c -fPIC driver-csi.c -o driver-csi.o
	$CC $CFLAGS $CPPFLAGS -c -fPIC driver-ti.c -o driver-ti.o

	$CC -shared -fPIC $LDFLAGS -o $TERMUX_PREFIX/lib/libtermkey.so termkey.o driver-csi.o driver-ti.o -lunibilium

	chmod u+w termkey.h
	cp termkey.h $TERMUX_PREFIX/include/
	cat termkey.pc.in | sed "s|@INCDIR@|$TERMUX_PREFIX/include|" | \
	                    sed "s|@LIBDIR@|$TERMUX_PREFIX/lib|" > \
			    $PKG_CONFIG_LIBDIR/termkey.pc
}
