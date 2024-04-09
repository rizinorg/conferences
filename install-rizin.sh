#!/bin/sh

install_darwin() {
	if ! hash brew &> /dev/null
	then
		echo "Please install brew and re-run this script"
		exit 1
	fi
	brew install --require-sha rizin
}

install_linux() {
	if ! hash wget &> /dev/null
	then
		if ! hash curl &> /dev/null
		then
			echo "Please install wget or curl and re-run this script"
			exit 1
		fi
	fi
	if ! hash meson &> /dev/null
	then
		echo "Please install meson and re-run this script"
		exit 1
	fi
	if ! hash ninja &> /dev/null
	then
		echo "Please install ninja (sometimes also named ninja-build) and re-run this script"
		exit 1
	fi

	RIZIN_DIR="rizin-0.7.2"

	if [ ! -d "$RIZIN_DIR" ]; then
		if [ -f "rizin-src-v0.7.2.tar.xz" ]; then
			rm "rizin-src-v0.7.2.tar.xz"
		fi

		if command -v wget &> /dev/null
		then
			wget "https://github.com/rizinorg/rizin/releases/download/v0.7.2/rizin-src-v0.7.2.tar.xz"
		else
			curl -L --output "rizin-src-v0.7.2.tar.xz" "https://github.com/rizinorg/rizin/releases/download/v0.7.2/rizin-src-v0.7.2.tar.xz"
		fi

		tar xf "rizin-src-v0.7.2.tar.xz"
		rm "rizin-src-v0.7.2.tar.xz"

		mv rizin-* "$RIZIN_DIR"
	fi

	if [ ! -d "$RIZIN_DIR" ]; then
		echo "failed to fetch rizin release. please try again with this script."
		exit 1
	fi

	cd "$RIZIN_DIR"
	meson setup --buildtype=release build
	ninja -C build
	sudo ninja -C build install
}


OS_NAME=$(uname)
case $OS_NAME in
  Linux)
	echo "Found linux"
	install_linux
	;;

  Darwin)
	echo "Found darwin"
	install_darwin
	;;

  *)
	echo "This should not happen. please ask for help."
	exit 1
	;;
esac
