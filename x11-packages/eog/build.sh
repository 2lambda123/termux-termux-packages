TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Apps/EyeOfGnome
TERMUX_PKG_DESCRIPTION="Eye of GNOME, an image viewing and cataloging program"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=44
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.0
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/eog/${_MAJOR_VERSION}/eog-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=41d85fab05c430898dbfd847e48e1f5b4935dc3cbcee546e759a907eda671054
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, gnome-desktop3, gobject-introspection, gsettings-desktop-schemas, gtk3, libcairo, libexif, libhandy, libjpeg-turbo, libpeas, librsvg, libx11, littlecms, shared-mime-info, zlib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_RECOMMENDS="eog-help"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dxmp=false
-Dintrospection=true
-Dlibportal=false
"

termux_step_pre_configure() {
	termux_setup_gir
}
