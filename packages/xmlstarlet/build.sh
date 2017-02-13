TERMUX_PKG_HOMEPAGE=http://xmlstar.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Command line XML toolkit"
TERMUX_PKG_VERSION=1.6.1
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/project/xmlstar/xmlstarlet/${TERMUX_PKG_VERSION}/xmlstarlet-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=15d838c4f3375332fd95554619179b69e4ec91418a3a5296e7c631b7ed19e7ca
TERMUX_PKG_DEPENDS="libxslt"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-libxml-include-prefix=${TERMUX_PREFIX}/include/libxml2"
TERMUX_PKG_BUILD_IN_SRC=yes
