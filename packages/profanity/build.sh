TERMUX_PKG_HOMEPAGE=http://profanity.im
TERMUX_PKG_DESCRIPTION="Profanity is a console based XMPP client written in C using ncurses and libstrophe, inspired by Irssi"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=0.6.0
TERMUX_PKG_MAINTAINER="Oliver Schmidhauser @Neo-Oli"
TERMUX_PKG_SRCURL=http://profanity.im/profanity-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=51b0932924a391656423af0d85f14dde049ac1e94214f948849d37df1c2759c4
TERMUX_PKG_DEPENDS="libandroid-support,ncurses,glib,libmesode,libcurl,readline,libuuid,libotr,gpgme,python"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=" --disable-python-plugins"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
  CPPFLAGS+=" -I$TERMUX_PREFIX/include/python3.7m"
  LDFLAGS+=" -lpython3.7m"
}

termux_step_post_configure() {
  # Enable python support manually, as trying to go using --enable-python-plugins
  # causes configure trying to execut python:
  echo '#define HAVE_PYTHON 1' >> $TERMUX_PKG_SRCDIR/src/config.h
  perl -p -i -e 's|#am__objects_2|am__objects_2|' $TERMUX_PKG_SRCDIR/Makefile
}
