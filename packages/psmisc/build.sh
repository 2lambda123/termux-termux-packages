TERMUX_PKG_HOMEPAGE=https://gitlab.com/psmisc/psmisc
TERMUX_PKG_DESCRIPTION="Some small useful utilities that use the proc filesystem"
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_VERSION=23.2
TERMUX_PKG_SHA256=4b7cbffdc9373474da49b85dc3457ae511c43dc7fa7d94513fe06f89dcb87880
TERMUX_PKG_SRCURL=https://fossies.org/linux/misc/psmisc-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_RM_AFTER_INSTALL="bin/pstree.x11"
