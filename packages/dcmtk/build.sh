TERMUX_PKG_HOMEPAGE="https://dicom.offis.de/dcmtk"
TERMUX_PKG_DESCRIPTION="A collection of libraries and applications implementing large parts the DICOM standard"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="COPYRIGHT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.6.7"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/DCMTK/dcmtk/archive/refs/tags/DCMTK-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=17705dcdb2047d1266bb4e92dbf4aa6d4967819e8e3e94f39b7df697661b4860
TERMUX_PKG_DEPENDS="libc++, zlib, libpng, libtiff, libxml2, openssl, libiconv, libjpeg-turbo, libsndfile"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DDCMTK_NO_TRY_RUN=ON
-DDCMTK_ICONV_FLAGS_ANALYZED=ON
-DDCMTK_FIXED_ICONV_CONVERSION_FLAGS=ON
-DBUILD_SHARED_LIBS=ON
-DDCMTK_WITH_ICONV=ON
-DDCMTK_WITH_ICU=OFF
-DDCMTK_WITH_XML=ON
-DDCMTK_WITH_PNG=ON
-DDCMTK_WITH_OPENJPEG=ON
-DDCMTK_WITH_OPENSSL=ON
-DDCMTK_WITH_SNDFILE=ON
-DDCMTK_WITH_TIFF=ON
-DDCMTK_WITH_ZLIB=ON
-DANDROID_TEMPORARY_FILES_LOCATION=$TERMUX_PREFIX/tmp
"

termux_step_pre_configure() {
    cp $TERMUX_PKG_BUILDER_DIR/arith.h/$TERMUX_ARCH.h $TERMUX_PKG_SRCDIR/config/include/dcmtk/config/arith.h
}
