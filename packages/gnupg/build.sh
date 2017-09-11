TERMUX_PKG_HOMEPAGE=https://www.gnupg.org/
TERMUX_PKG_DESCRIPTION="OpenPGP implementation for encrypting and signing data and communication"
TERMUX_PKG_VERSION=2.2.0
TERMUX_PKG_SHA256=d4514a0be0f7a1ff263193330019eb4b53c82f0f5e230af3c14df371271a45e6
TERMUX_PKG_SRCURL=ftp://ftp.gnupg.org/gcrypt/gnupg/gnupg-${TERMUX_PKG_VERSION}.tar.bz2
# disable readline since gnupg is used in bootstrap, so nice to avoid readline+ncurses dependencies.
# ac_cv_sys_symbol_underscore=no needed for i686 build to avoid "undefined reference to `mpihelp_sub_n'" errors
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-endian-check --without-readline ac_cv_sys_symbol_underscore=no"
# ac_cv_header_sys_shm_h is to avoid USE_SHM_COPROCESSING getting defined due to <sys/shm.h>,
#                        which it does on android-21 (but shmat(2) does not exist)
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_header_sys_shm_h=no"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --disable-bzip2"
# Assembly issues on at least arm:
TERMUX_PKG_CLANG=no

termux_step_pre_configure() {
	CFLAGS+=" -D__LITTLE_ENDIAN__"
}
