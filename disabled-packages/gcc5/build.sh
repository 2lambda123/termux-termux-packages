TERMUX_PKG_HOMEPAGE=http://gcc.gnu.org/
TERMUX_PKG_DESCRIPTION="GNU C compiler"
TERMUX_PKG_DEPENDS="binutils, libgmp, libmpfr, libmpc, ndk-sysroot"
TERMUX_PKG_VERSION=5.3.0
TERMUX_PKG_SRCURL=ftp://ftp.fu-berlin.de/unix/languages/gcc/releases/gcc-${TERMUX_PKG_VERSION}/gcc-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-languages=c,c++ --with-system-zlib --disable-multilib --disable-lto"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-gmp=$TERMUX_PREFIX --with-mpfr=$TERMUX_PREFIX --with-mpc=$TERMUX_PREFIX"
# To build gcc as a PIE binary:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-stage1-ldflags=\"-specs=$TERMUX_SCRIPTDIR/termux.spec\""
# TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --without-headers --with-local-prefix=$TERMUX_PREFIX/include" # FIXME: gcc5 trying
if [ "$TERMUX_ARCH" = "arm" ]; then
        TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-arch=armv7-a --with-fpu=neon --with-float=hard"
elif [ "$TERMUX_ARCH" = "i686" ]; then
        # -mstackrealign -msse3 -m32
        TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-arch=i686 --with-tune=atom --with-fpmath=sse"
fi
TERMUX_PKG_KEEP_STATIC_LIBRARIES="true"
TERMUX_PKG_RM_AFTER_INSTALL="bin/gcc-ar bin/gcc-ranlib bin/c++ bin/gcc-nm bin/*-linux-* lib/gcc/*-linux-*/${TERMUX_PKG_VERSION}/plugin lib/gcc/*-linux-*/${TERMUX_PKG_VERSION}/include-fixed lib/gcc/*-linux-*/$TERMUX_PKG_VERSION/install-tools libexec/gcc/*-linux-*/${TERMUX_PKG_VERSION}/plugin libexec/gcc/*-linux-*/${TERMUX_PKG_VERSION}/install-tools share/man/man7"

export AR_FOR_TARGET="$AR"
export AS_FOR_TARGET="$AS"
export CC_FOR_TARGET="$CC"
export CFLAGS_FOR_TARGET="$CFLAGS" 
export CPP_FOR_TARGET="$CPP"
export CPPFLAGS_FOR_TARGET="$CPPFLAGS"
export CXXFLAGS_FOR_TARGET="$CXXFLAGS"
export CXX_FOR_TARGET="$CXX"
export LDFLAGS_FOR_TARGET="$LDFLAGS"
export LD_FOR_TARGET="$LD"
export PKG_CONFIG_FOR_TARGET="$PKG_CONFIG"
export RANLIB_FOR_TARGET="$RANLIB"

unset AR
unset AS
unset CC
unset CFLAGS
unset CPP
unset CPPFLAGS
unset CXXFLAGS
unset CXX
unset LDFLAGS
unset LD
unset PKG_CONFIG
unset RANLIB

# TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --host=x86-linux-android"

termux_step_make () {
	make -j $TERMUX_MAKE_PROCESSES all-gcc
	make -j $TERMUX_MAKE_PROCESSES all-target-libgcc
}

termux_step_make_install () {
	make install-gcc 
        make install-target-libgcc
}

termux_step_post_make_install () {
	if [ $TERMUX_ARCH = "arm" ]; then
		# Note that moving to $TERMUX_PREFIX/lib/gcc/arm-linux-androideabi/${TERMUX_PKG_VERSION}/
        	# allows compilation but fails to link at runtime
		mv $TERMUX_PREFIX/lib/armv7-a/hard/libgcc_s* $TERMUX_PREFIX/lib/
	fi

	# Android 5.0 only supports PIE binaries, so build that by default with a specs file:
	cp $TERMUX_SCRIPTDIR/termux.spec $TERMUX_PREFIX/lib/gcc/$TERMUX_HOST_PLATFORM/$TERMUX_PKG_VERSION/specs
}
