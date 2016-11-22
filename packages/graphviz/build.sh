TERMUX_PKG_MAINTAINER="Dustin DeWeese @HackerFoo"
TERMUX_PKG_HOMEPAGE=http://www.graphviz.org/
TERMUX_PKG_DESCRIPTION="Rich set of graph drawing tools"
TERMUX_PKG_VERSION=2.38.0
TERMUX_PKG_BUILD_REVISION=1
TERMUX_PKG_SRCURL=http://www.graphviz.org/pub/graphviz/stable/SOURCES/graphviz-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=81aa238d9d4a010afa73a9d2a704fc3221c731e1e06577c2ab3496bdef67859e
TERMUX_PKG_DEPENDS="libandroid-glob,libcairo,pango,libexpat,libltdl,librsvg,libgd"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-poppler=no --enable-java=no --enable-perl=no
--enable-swig=no --enable-sharp=no --enable-guile=no --enable-lua=no --enable-ocaml=no
--enable-php=no --enable-python=no --enable-r=no --enable-ruby=no --enable-tcl=no
--with-pic --with-x=no --with-pangocairo=yes
--with-ltdl-include=$TERMUX_PREFIX/include --with-ltdl-lib=$TERMUX_PREFIX/lib"
TERMUX_PKG_RM_AFTER_INSTALL="bin/*-config share/man/man1/*-config.1"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}

termux_step_post_make_install() {
	# Some binaries (dot_builtins, gvpack) links against these:
	cd $TERMUX_PREFIX/lib
	for lib in graphviz/*.so.*; do
		ln -s -f $lib `basename $lib`
	done
}

termux_step_create_debscripts () {
	echo "dot -c" > postinst
	echo "exit 0" >> postinst
	chmod 0755 postinst
}
