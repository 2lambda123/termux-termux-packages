TERMUX_PKG_HOMEPAGE=https://github.com/ldc-developers/ldc
TERMUX_PKG_DESCRIPTION="D programming language compiler, built with LLVM"
_PKG_MAJOR_VERSION=1.3
TERMUX_PKG_VERSION=${_PKG_MAJOR_VERSION}.0
TERMUX_PKG_SRCURL=https://github.com/ldc-developers/ldc/releases/download/v${TERMUX_PKG_VERSION}/ldc-${TERMUX_PKG_VERSION}-src.tar.gz
TERMUX_PKG_SHA256=efe31a639bcb44e1f5b752da21713376d9410a01279fecc8aab8572065a3050b
TERMUX_PKG_DEPENDS="clang"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_BLACKLISTED_ARCHES="aarch64,i686,x86_64"
TERMUX_PKG_FORCE_CMAKE=yes
#These CMake args are only used to configure a patched LLVM
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DLLVM_ENABLE_PIC=ON
-DLLVM_BUILD_TOOLS=OFF
-DLLVM_BUILD_UTILS=OFF
-DLLVM_TABLEGEN=$TERMUX_PKG_HOSTBUILD_DIR/bin/llvm-tblgen"
TERMUX_PKG_KEEP_STATIC_LIBRARIES=true
TERMUX_PKG_NO_DEVELSPLIT=yes
TERMUX_PKG_MAINTAINER="Joakim @joakim-noah"

termux_step_post_extract_package () {
	local LLVM_SRC_VERSION=4.0.1
	termux_download \
		https://github.com/ldc-developers/llvm/releases/download/ldc-v${LLVM_SRC_VERSION}/llvm-${LLVM_SRC_VERSION}.src.tar.xz \
		$TERMUX_PKG_CACHEDIR/llvm-${LLVM_SRC_VERSION}.src.tar.xz \
		53dee2054a4da0a292fc55830119ae167812cc0eed5cc670223adc5a8731f71b

	tar xf $TERMUX_PKG_CACHEDIR/llvm-${LLVM_SRC_VERSION}.src.tar.xz
	mv llvm-${LLVM_SRC_VERSION}.src llvm

	DMD_COMPILER_VERSION=2.075.1
	termux_download \
		http://downloads.dlang.org/releases/2.x/${DMD_COMPILER_VERSION}/dmd.${DMD_COMPILER_VERSION}.linux.tar.xz \
		$TERMUX_PKG_CACHEDIR/dmd.${DMD_COMPILER_VERSION}.linux.tar.xz \
		6531c098020cf321b5e71c420a10db729566006b72e0af873b15b506a1583c57

	sed "s#\@TERMUX_C_COMPILER\@#$TERMUX_STANDALONE_TOOLCHAIN/bin/$TERMUX_HOST_PLATFORM-clang#" \
		$TERMUX_PKG_BUILDER_DIR/ldc-config-stdlib.patch.beforehostbuild.in > \
		$TERMUX_PKG_BUILDER_DIR/ldc-config-stdlib.patch.beforehostbuild
	sed -i "s#\@TERMUX_C_FLAGS\@#-march=armv7-a -mfpu=neon -mfloat-abi=softfp -mthumb -Os -I$TERMUX_PREFIX/include#" \
		$TERMUX_PKG_BUILDER_DIR/ldc-config-stdlib.patch.beforehostbuild
	sed "s#\@TERMUX_PKG_HOSTBUILD\@#$TERMUX_PKG_HOSTBUILD_DIR#" $TERMUX_PKG_BUILDER_DIR/ldc-linker-flags.patch.in > \
		$TERMUX_PKG_BUILDER_DIR/ldc-linker-flags.patch
	sed "s#\@TERMUX_PKG_BUILD\@#$TERMUX_PKG_BUILDDIR#" $TERMUX_PKG_BUILDER_DIR/ldc-llvm-config.patch.in > \
		$TERMUX_PKG_BUILDER_DIR/ldc-llvm-config.patch
	sed -i "s#\@TERMUX_PKG_SRC\@#$TERMUX_PKG_SRCDIR#" $TERMUX_PKG_BUILDER_DIR/ldc-llvm-config.patch
}

termux_step_host_build () {
	tar xf $TERMUX_PKG_CACHEDIR/dmd.${DMD_COMPILER_VERSION}.linux.tar.xz

	termux_setup_cmake
	cmake -G "Unix Makefiles" $TERMUX_PKG_SRCDIR/llvm \
		-DCMAKE_BUILD_TYPE=Release \
		-DLLVM_TARGETS_TO_BUILD=ARM \
		-DLLVM_DEFAULT_TARGET_TRIPLE=armv7-none-linux-android \
		-DLLVM_BUILD_TOOLS=OFF \
		-DLLVM_BUILD_UTILS=OFF
	make -j $TERMUX_MAKE_PROCESSES all llvm-config

	mkdir ldc-bootstrap
	cd ldc-bootstrap
	export DMD="$TERMUX_PKG_HOSTBUILD_DIR/dmd2/linux/bin64/dmd"
	cmake -G "Unix Makefiles" $TERMUX_PKG_SRCDIR \
		-DLLVM_CONFIG="$TERMUX_PKG_HOSTBUILD_DIR/bin/llvm-config"
	make -j $TERMUX_MAKE_PROCESSES druntime-ldc phobos2-ldc \
		druntime-ldc-debug phobos2-ldc-debug ldmd2
	cd ..
}

termux_step_pre_configure () {
	rm $TERMUX_PKG_BUILDER_DIR/ldc-config-stdlib.patch.beforehostbuild
	rm $TERMUX_PKG_BUILDER_DIR/ldc-linker-flags.patch
	rm $TERMUX_PKG_BUILDER_DIR/ldc-llvm-config.patch

	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DLLVM_DEFAULT_TARGET_TRIPLE=armv7a-linux-androideabi"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DLLVM_TARGET_ARCH=ARM -DLLVM_TARGETS_TO_BUILD=AArch64;ARM;X86"

	# CPPFLAGS adds the system llvm to the include path, which causes
	# conflicts with the local patched llvm when compiling ldc
	CPPFLAGS=""

	OLD_TERMUX_PKG_SRCDIR=$TERMUX_PKG_SRCDIR
	TERMUX_PKG_SRCDIR=$TERMUX_PKG_SRCDIR/llvm

	OLD_TERMUX_PKG_BUILDDIR=$TERMUX_PKG_BUILDDIR
	TERMUX_PKG_BUILDDIR=$TERMUX_PKG_BUILDDIR/llvm
	mkdir "$TERMUX_PKG_BUILDDIR"
}

termux_step_post_configure () {
	TERMUX_PKG_SRCDIR=$OLD_TERMUX_PKG_SRCDIR
	TERMUX_PKG_BUILDDIR=$OLD_TERMUX_PKG_BUILDDIR
	cd "$TERMUX_PKG_BUILDDIR"

	TERMUX_PKG_EXTRA_CONFIGURE_ARGS=""
	export DMD="$TERMUX_PKG_HOSTBUILD_DIR/ldc-bootstrap/bin/ldmd2"

	termux_step_configure_cmake

	cp $TERMUX_PKG_HOSTBUILD_DIR/ldc-bootstrap/ddmd/id.d $TERMUX_PKG_BUILDDIR/ddmd
	cp $TERMUX_PKG_HOSTBUILD_DIR/ldc-bootstrap/ddmd/id.h $TERMUX_PKG_BUILDDIR/ddmd
}

termux_step_make () {
	cd llvm
	if ls ./*akefile &> /dev/null; then
		make -j $TERMUX_MAKE_PROCESSES
	fi

	cd ..
	if ls ./*akefile &> /dev/null; then
		make -j $TERMUX_MAKE_PROCESSES ldc2 ldmd2
	fi
}

termux_step_make_install () {
	cp bin/{ldc2,ldmd2} $TERMUX_PREFIX/bin
	cp $TERMUX_PKG_HOSTBUILD_DIR/ldc-bootstrap/lib/lib{druntime,phobos2}*.a $TERMUX_PREFIX/lib
	sed -i "/runtime\/druntime\/src/d" bin/ldc2.conf
	sed -i "/runtime\/profile-rt\/d/d" bin/ldc2.conf
	sed -i "s|$TERMUX_PKG_SRCDIR/runtime/phobos|%%ldcbinarypath%%/../include/d|" bin/ldc2.conf
	sed "s|$TERMUX_PKG_BUILDDIR/lib|%%ldcbinarypath%%/../lib|" bin/ldc2.conf > $TERMUX_PREFIX/etc/ldc2.conf

	rm -Rf $TERMUX_PREFIX/include/d
	mkdir $TERMUX_PREFIX/include/d
	cp -r $TERMUX_PKG_SRCDIR/runtime/druntime/src/{core,etc,ldc,object.d} $TERMUX_PREFIX/include/d
	cp $TERMUX_PKG_HOSTBUILD_DIR/ldc-bootstrap/runtime/gccbuiltins_arm.di $TERMUX_PREFIX/include/d/ldc
	cp -r $TERMUX_PKG_SRCDIR/runtime/phobos/etc/c $TERMUX_PREFIX/include/d/etc
	rm -Rf $TERMUX_PREFIX/include/d/etc/c/zlib
	find $TERMUX_PKG_SRCDIR/runtime/phobos/std -name "*.orig" -delete
	cp -r $TERMUX_PKG_SRCDIR/runtime/phobos/std $TERMUX_PREFIX/include/d

	rm -Rf $TERMUX_PREFIX/share/ldc
	mkdir $TERMUX_PREFIX/share/ldc
	cp -r $TERMUX_PKG_SRCDIR/{LICENSE,README,bash_completion.d} $TERMUX_PREFIX/share/ldc
}
