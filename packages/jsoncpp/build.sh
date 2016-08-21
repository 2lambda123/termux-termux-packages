TERMUX_PKG_HOMEPAGE=https://github.com/open-source-parsers/jsoncpp
TERMUX_PKG_DESCRIPTION="C++ library for interacting with JSON"
TERMUX_PKG_VERSION=1.7.4
TERMUX_PKG_SRCURL=https://github.com/open-source-parsers/jsoncpp/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_FOLDERNAME=jsoncpp-${TERMUX_PKG_VERSION}

termux_step_configure () {
        # The installation does not overwrite symlinks such as libjsoncpp.so.1,
        # so if rebuilding these are not detected as modified. Fix that:
        rm -f $TERMUX_PREFIX/lib/libjsoncpp.so*

	cd $TERMUX_PKG_BUILDDIR
	cmake -G "Unix Makefiles" .. \
		-DCMAKE_AR=`which ${TERMUX_HOST_PLATFORM}-ar` \
                -DCMAKE_BUILD_TYPE=MinSizeRel \
		-DCMAKE_CROSSCOMPILING=True \
		-DCMAKE_C_FLAGS="$CFLAGS $CPPFLAGS" \
		-DCMAKE_CXX_FLAGS="$CXXFLAGS" \
		-DCMAKE_FIND_ROOT_PATH=$TERMUX_PREFIX \
		-DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
		-DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY \
		-DCMAKE_INSTALL_PREFIX=$TERMUX_PREFIX \
		-DCMAKE_LINKER=`which ${TERMUX_HOST_PLATFORM}-ld` \
                -DCMAKE_MAKE_PROGRAM=`which make` \
		-DCMAKE_RANLIB=`which ${TERMUX_HOST_PLATFORM}-ranlib` \
		-DCMAKE_SYSTEM_NAME=Android \
                -DPKG_CONFIG_EXECUTABLE=$PKG_CONFIG \
		-DZLIB_LIBRARY:FILEPATH="$TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/lib/libz.so" \
		-DZLIB_INCLUDE_DIR:PATH="$TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/include" \
		-DBUILD_SHARED_LIBS=ON \
		-DJSONCPP_WITH_TESTS=OFF \
		$TERMUX_PKG_SRCDIR
}
