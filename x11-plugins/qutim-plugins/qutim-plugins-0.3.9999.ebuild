# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit git-2 eutils cmake-utils

EGIT_HAS_SUBMODULES="true"
EGIT_REPO_URI="git://github.com/euroelessar/qutim.git"
EGIT_BRANCH="master"
EGIT_COMMIT="${EGIT_BRANCH}"
EGIT_PROJECT="qutim"
CMAKE_USE_DIR="${S}/plugins"

DESCRIPTION="Plugins for net-im/qutim"
HOMEPAGE="http://www.qutim.org"

LICENSE="GPL-2"
SLOT="0.3-live"
KEYWORDS=""

PLUGINS_GOOD="aescrypto aspell hunspell clconf +dbus +unreadmessageskeeper +kineticpopups kde sdl\
		phonon histman weather floaties massmessaging emoedit dbusnotify"
PLUGINS_BAD="antiboss antispam yandexnarod nowplaying connectionmanager awn urlpreview qmlchat indicator"

IUSE="${PLUGINS_GOOD} ${PLUGINS_BAD} debug"

RDEPEND="net-im/qutim:${SLOT}
	>=x11-libs/qt-core-4.6.3
	sdl? ( media-libs/sdl-mixer )
	phonon? ( media-libs/phonon )
	aspell? ( app-text/aspell )
	hunspell? ( app-text/hunspell )
	qmlchat? ( >=x11-libs/qt-declarative-4.7.0 )
	kineticpopups? ( >=x11-libs/qt-declarative-4.7.0 )
	indicator? ( dev-libs/libindicate-qt )
	dbus? ( >=x11-libs/qt-dbus-4.6.0 )
	awn? ( gnome-extra/avant-window-navigator )
	aescrypto? ( app-crypt/qca )"

DEPEND="${RDEPEND}
	>=dev-util/cmake-2.6"

RESTRICT="debug? ( strip )"

pre_src_unpack() {
	# Some Bash magick
	USEARR=$(echo $USE | tr ";" "\n")
	for ONE_USE in $USEARR
	do
	  if (has $ONE_USE $PLUGINS_BAD) ; then
	    ewarn "WARNING: You have enabled the build of the ${ONE_USE} plugin which is known to be not working for now"
	  fi
	done
}

src_unpack() {
	git-2_src_unpack
}

src_prepare() {
	if (use debug) ; then
		unset CFLAGS CXXFLAGS
		append-flags -O1 -g -ggdb
		CMAKE_BUILD_TYPE="debug"
	fi

	mycmakeargs=(
		-DQUTIM_ENABLE_ALL_PLUGINS=off
		$(cmake-utils_use aescrypto AESCRYPTO)
		$(cmake-utils_use antiboss ANTIBOSS)
		$(cmake-utils_use antispam ANTISPAM)
		$(cmake-utils_use aspell ASPELLER)
		$(cmake-utils_use awn AWN)
		$(cmake-utils_use clconf CLCONF)
		$(cmake-utils_use connectionmanager CONNECTIONMANAGER)
		$(cmake-utils_use dbus DBUSAPI)
		$(cmake-utils_use dbusnotify DBUSNOTIFICATIONS)
		$(cmake-utils_use emoedit EMOEDIT)
		$(cmake-utils_use floaties FLOATIES)
		$(cmake-utils_use histman HISTMAN)
		$(cmake-utils_use hunspell HUNSPELLER)
		$(cmake-utils_use indicator INDICATOR)
		$(cmake-utils_use kde KDEINTEGRATION)
		$(cmake-utils_use kineticpopups KINETICPOPUPS)
		$(cmake-utils_use kineticpopups QUICKPOPUP/DEFAULT)
		$(cmake-utils_use kineticpopups QUICKPOPUP/GLASS)
		$(cmake-utils_use massmessaging MASSMESSAGING)
		$(cmake-utils_use nowplaying NOWPLAYING)
		$(cmake-utils_use phonon PHONONSOUND)
		$(cmake-utils_use qmlchat QMLCHAT)
		$(cmake-utils_use sdl SDLSOUND)
		$(cmake-utils_use unreadmessageskeeper UNREADMESSAGESKEEPER)
		$(cmake-utils_use urlpreview URLPREVIEW)
		$(cmake-utils_use weather WEATHER)
		$(cmake-utils_use yandexnarod YANDEXNAROD)
	)

	CMAKE_IN_SOURCE_BUILD=1
}
