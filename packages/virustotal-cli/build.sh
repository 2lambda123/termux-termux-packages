TERMUX_PKG_HOMEPAGE=https://github.com/VirusTotal/vt-cli
TERMUX_PKG_DESCRIPTION="Command line interface for VirusTotal"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.13.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/VirusTotal/vt-cli/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=0908250bf659cb73be748da7a1c5d2d402aba0c9da0fc21a1ad629deb4f24a73
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BREAKS="vt-cli"
TERMUX_PKG_REPLACES="vt-cli"

termux_step_make() {
	termux_setup_golang

	export GOPATH=$TERMUX_PKG_BUILDDIR
	mkdir -p "$GOPATH"/src/github.com/VirusTotal
	ln -sf "$TERMUX_PKG_SRCDIR" "$GOPATH"/src/github.com/VirusTotal/vt-cli

	cd "$GOPATH"/src/github.com/VirusTotal/vt-cli

	go build \
		-ldflags "-X github.com/VirusTotal/vt-cli/cmd.Version=$TERMUX_PKG_VERSION" \
		-o "$TERMUX_PREFIX"/bin/vt-cli \
		./vt/main.go
}

termux_step_make_install() {
	ln -sfr "$TERMUX_PREFIX"/bin/vt-cli "$TERMUX_PREFIX"/bin/vt
}
