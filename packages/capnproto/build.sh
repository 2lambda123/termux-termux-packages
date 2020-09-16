TERMUX_PKG_HOMEPAGE=https://capnproto.org/
TERMUX_PKG_DESCRIPTION="Cap'n Proto tool and library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=0.8.0
TERMUX_PKG_SRCURL=https://capnproto.org/capnproto-c++-${VERSION}.tar.gz
TERMUX_PKG_SHA256=d1f40e47574c65700f0ec98bf66729378efabe3c72bc0cda795037498541c10d

termux_step_configure() {
    ./configure --prefix=$TERMUX_PREFIX
}