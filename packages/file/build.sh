TERMUX_PKG_HOMEPAGE=https://darwinsys.com/file/
TERMUX_PKG_DESCRIPTION="Command-line tool that tells you in words what kind of data a file contains"
TERMUX_PKG_VERSION=5.29
TERMUX_PKG_SRCURL=ftp://ftp.astron.com/pub/file/file-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ea661277cd39bf8f063d3a83ee875432cc3680494169f952787e002bdd3884c0
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_func_mmap_fixed_mapped=yes"
TERMUX_PKG_EXTRA_MAKE_ARGS="FILE_COMPILE=$TERMUX_PKG_HOSTBUILD_DIR/src/file"
TERMUX_PKG_HOSTBUILD="yes"
