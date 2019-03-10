termux_get_repo_files() {
	# Ensure folders present (but not $TERMUX_PKG_SRCDIR, it will be created in build)
	mkdir -p "$TERMUX_COMMON_CACHEDIR" \
		 "$TERMUX_COMMON_CACHEDIR-$TERMUX_ARCH" \
		 "$TERMUX_COMMON_CACHEDIR-all" \
		 "$TERMUX_DEBDIR" \
		 "$TERMUX_PKG_BUILDDIR" \
		 "$TERMUX_PKG_PACKAGEDIR" \
		 "$TERMUX_PKG_TMPDIR" \
		 "$TERMUX_PKG_CACHEDIR" \
		 "$TERMUX_PKG_MASSAGEDIR" \
		 $TERMUX_PREFIX/{bin,etc,lib,libexec,share,tmp,include}
	if [ "$TERMUX_INSTALL_DEPS" = true ]; then
		if [ "$TERMUX_NO_CLEAN" = false ]; then
			# Remove all previously extracted/built files from $TERMUX_PREFIX:
			rm -rf $TERMUX_PREFIX
			rm -f /data/data/.built-packages/*
		fi

		# Import signing keys from files
		gpg --import ${TERMUX_REPO_SIGNING_KEYS}

		for idx in $(seq ${#TERMUX_REPO_URL[@]}); do
			local TERMUX_REPO_NAME=$(echo ${TERMUX_REPO_URL[$idx-1]} | sed -e 's%https://%%g' -e 's%http://%%g' -e 's%/%-%g')
			local FILE_PREFIX=${TERMUX_COMMON_CACHEDIR}/${TERMUX_REPO_NAME}-${TERMUX_REPO_DISTRIBUTION[$idx-1]}
			curl --fail -L "${TERMUX_REPO_URL[$idx-1]}/dists/${TERMUX_REPO_DISTRIBUTION[$idx-1]}/InRelease" -o ${FILE_PREFIX}-InRelease \
			    || curl --fail -L "${TERMUX_REPO_URL[$idx-1]}/dists/${TERMUX_REPO_DISTRIBUTION[$idx-1]}/Release.gpg" -o ${FILE_PREFIX}-Release.gpg \
			    && curl --fail -L "${TERMUX_REPO_URL[$idx-1]}/dists/${TERMUX_REPO_DISTRIBUTION[$idx-1]}/Release" -o ${FILE_PREFIX}-Release \
			    || termux_error_exit "Download of InRelease and Release.gpg from ${TERMUX_REPO_URL[$idx-1]}/dists/${TERMUX_REPO_DISTRIBUTION[$idx-1]} failed"

			if [ -f ${TERMUX_COMMON_CACHEDIR}/${TERMUX_REPO_NAME}-${TERMUX_REPO_DISTRIBUTION[$idx-1]}-InRelease ]; then
				local RELEASE_FILE=${TERMUX_COMMON_CACHEDIR}/${TERMUX_REPO_NAME}-${TERMUX_REPO_DISTRIBUTION[$idx-1]}-InRelease
				gpg --verify $RELEASE_FILE
			else
				local RELEASE_FILE=${TERMUX_COMMON_CACHEDIR}/${TERMUX_REPO_NAME}-${TERMUX_REPO_DISTRIBUTION[$idx-1]}-Release
				gpg --verify ${RELEASE_FILE}.gpg $RELEASE_FILE
			fi

			for arch in all $TERMUX_ARCH; do
				local PACKAGES_HASH=$(./scripts/get_hash_from_file.py ${RELEASE_FILE} $arch ${TERMUX_REPO_COMPONENT[$idx-1]})
				# If packages_hash = "" then the repo probably doesn't contain debs for $arch
				if [ ! -z "$PACKAGES_HASH" ]; then
					termux_download "${TERMUX_REPO_URL[$idx-1]}/dists/${TERMUX_REPO_DISTRIBUTION[$idx-1]}/${TERMUX_REPO_COMPONENT[$idx-1]}/binary-$arch/Packages" \
							"${TERMUX_COMMON_CACHEDIR}-$arch/${TERMUX_REPO_NAME}-${TERMUX_REPO_DISTRIBUTION[$idx-1]}-${TERMUX_REPO_COMPONENT[$idx-1]}-Packages" \
							$PACKAGES_HASH
				fi
			done
		done
	fi
}
