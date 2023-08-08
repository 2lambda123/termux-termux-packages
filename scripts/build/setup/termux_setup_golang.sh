# Utility function for golang-using packages to setup a go toolchain.
termux_setup_golang() {
	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		local TERMUX_GO_VERSION=go1.20.7
		local TERMUX_GO_SHA256=2c5ee9c9ec1e733b0dbbc2bdfed3f62306e51d8172bf38f4f4e542b27520f597
		if [ "$TERMUX_PKG_GO_USE_OLDER" = "true" ]; then
			TERMUX_GO_VERSION=go1.19.12
			TERMUX_GO_SHA256=ee5d50e0a7fd74ba1b137cb879609aaaef9880bf72b5d1742100e38ae72bb557
		fi
		local TERMUX_GO_PLATFORM=linux-amd64

		local TERMUX_BUILDGO_FOLDER
		if [ "${TERMUX_PACKAGES_OFFLINE-false}" = "true" ]; then
			TERMUX_BUILDGO_FOLDER=${TERMUX_SCRIPTDIR}/build-tools/${TERMUX_GO_VERSION}
		else
			TERMUX_BUILDGO_FOLDER=${TERMUX_COMMON_CACHEDIR}/${TERMUX_GO_VERSION}
		fi

		export GOROOT=$TERMUX_BUILDGO_FOLDER
		export PATH=${GOROOT}/bin:${PATH}

		if [ -d "$TERMUX_BUILDGO_FOLDER" ]; then return; fi

		local TERMUX_BUILDGO_TAR=$TERMUX_COMMON_CACHEDIR/${TERMUX_GO_VERSION}.${TERMUX_GO_PLATFORM}.tar.gz
		rm -Rf "$TERMUX_COMMON_CACHEDIR/go" "$TERMUX_BUILDGO_FOLDER"
		termux_download https://golang.org/dl/${TERMUX_GO_VERSION}.${TERMUX_GO_PLATFORM}.tar.gz \
			"$TERMUX_BUILDGO_TAR" \
			"$TERMUX_GO_SHA256"

		( cd "$TERMUX_COMMON_CACHEDIR"; tar xf "$TERMUX_BUILDGO_TAR"; mv go "$TERMUX_BUILDGO_FOLDER"; rm "$TERMUX_BUILDGO_TAR" )

		if [ "$TERMUX_PKG_GO_USE_OLDER" = "false" ]; then
			( cd "$TERMUX_BUILDGO_FOLDER"; . ${TERMUX_SCRIPTDIR}/packages/golang/fix-hardcoded-etc-resolv-conf.sh )
		fi
	else
		if [[ "$TERMUX_APP_PACKAGE_MANAGER" = "apt" && "$(dpkg-query -W -f '${db:Status-Status}\n' golang 2>/dev/null)" != "installed" ]] ||
		   [[ "$TERMUX_APP_PACKAGE_MANAGER" = "pacman" && ! "$(pacman -Q golang 2>/dev/null)" ]]; then
			echo "Package 'golang' is not installed."
			echo "You can install it with"
			echo
			echo "  pkg install golang"
			echo
			echo "  pacman -S golang"
			echo
			echo "or build it from source with"
			echo
			echo "  ./build-package.sh golang"
			echo
			exit 1
		fi

		export GOROOT="$TERMUX_PREFIX/lib/go"
	fi
}
