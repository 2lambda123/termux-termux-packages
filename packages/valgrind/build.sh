TERMUX_PKG_HOMEPAGE=http://valgrind.org/
TERMUX_PKG_DESCRIPTION="Valgrind is an instrumentation framework for building dynamic analysis tools."
TERMUX_PKG_VERSION=3.11.0
TERMUX_PKG_SRCURL=http://valgrind.org/downloads/valgrind-${TERMUX_PKG_VERSION}.tar.bz2
# TERMUX_PKG_SRCURL=https://fossies.org/linux/misc/valgrind-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-tmpdir=$TERMUX_PREFIX/tmp"
# - Does not build on x86_64 due to lacking upstream support of that arch on android.
TERMUX_PKG_BLACKLISTED_ARCHES="x86_64"

if [ "$TERMUX_ARCH" == "arm" ]; then
  # valgrind doesn't like arm; armv7 works, though.
  TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --host=armv7-linux-androideabi"
fi

