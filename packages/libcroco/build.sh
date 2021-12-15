TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/Archive/libcroco
TERMUX_PKG_DESCRIPTION="CSS parsing and manipulation library"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.6.13
TERMUX_PKG_REVISION=6
TERMUX_PKG_SRCURL=http://ftp.gnome.org/pub/gnome/sources/libcroco/${TERMUX_PKG_VERSION:0:3}/libcroco-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=767ec234ae7aa684695b3a735548224888132e063f92db585759b422570621d4
TERMUX_PKG_DEPENDS="glib,liblzma,libxml2"
TERMUX_PKG_BREAKS="libcroco-dev"
TERMUX_PKG_REPLACES="libcroco-dev"
