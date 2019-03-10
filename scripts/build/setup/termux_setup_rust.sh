termux_setup_rust() {
	if [ $TERMUX_ARCH = "arm" ]; then
		CARGO_TARGET_NAME=armv7-linux-androideabi
	else
		CARGO_TARGET_NAME=$TERMUX_ARCH-linux-android
	fi

	local ENV_NAME=CARGO_TARGET_${CARGO_TARGET_NAME^^}_LINKER
	ENV_NAME=${ENV_NAME//-/_}
	export $ENV_NAME=$CC

	curl https://sh.rustup.rs -sSf > $TERMUX_PKG_TMPDIR/rustup.sh
	sh $TERMUX_PKG_TMPDIR/rustup.sh -y --default-toolchain 1.32.0
	export PATH=$HOME/.cargo/bin:$PATH

	rustup target add $CARGO_TARGET_NAME
}
