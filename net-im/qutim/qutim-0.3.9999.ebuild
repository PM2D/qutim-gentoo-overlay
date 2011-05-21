# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit git eutils cmake-utils confutils

EGIT_HAS_SUBMODULES="true"
EGIT_REPO_URI="git://github.com/euroelessar/qutim.git"
EGIT_BRANCH="master"
EGIT_COMMIT="${EGIT_BRANCH}"
CMAKE_USE_DIR="${S}/core"

DESCRIPTION="Multiprotocol instant messenger"
HOMEPAGE="http://qutim.org"

LICENSE="GPL-2"
SLOT="0.3-live"
KEYWORDS=""

PROTOCOLS="+icq irc +jabber libpurple mrim vkontakte"
PLUGINS="aescrypto antiboss antispam aspeller awn clconf connectionmanager +dbus \
	histman hunspeller indicator kde massmessaging nowplaying phonon +kineticpopups \
	+unreadmessageskeeper urlpreview weather yandexnarod sdl +webkit kineticscroller"
	#imagepub otr plugman sqlhistory tex vsqlhistory webhistory
IUSE="debug doc linguas_bg linguas_cs linguas_de linguas_ru linguas_uk"
IUSE="${PROTOCOLS} ${PLUGINS} ${IUSE} static mobile"

RDEPEND=">=x11-libs/qt-gui-4.6.0
	webkit? ( >=x11-libs/qt-webkit-4.6.0 )
	>=x11-libs/qt-multimedia-4.6.0
	phonon? ( kde-base/phonon-kde )"

DEPEND="${RDEPEND}
	>=dev-util/cmake-2.6.0
	doc? ( app-doc/doxygen )"

PDEPEND="linguas_bg? ( net-im/qutim-l10n:${SLOT}[linguas_bg?] )
	linguas_cs? ( net-im/qutim-l10n:${SLOT}[linguas_cs?] )
	linguas_de? ( net-im/qutim-l10n:${SLOT}[linguas_de?] )
	linguas_ru? ( net-im/qutim-l10n:${SLOT}[linguas_ru?] )
	linguas_uk? ( net-im/qutim-l10n:${SLOT}[linguas_uk?] )
	icq? ( x11-plugins/qutim-icq:${SLOT} )
	irc? ( x11-plugins/qutim-irc:${SLOT} )
	jabber? ( x11-plugins/qutim-jabber:${SLOT} )
	libpurple? ( x11-plugins/qutim-quetzal:${SLOT} )
	mrim? ( x11-plugins/qutim-mrim:${SLOT} )
	vkontakte? ( x11-plugins/qutim-vkontakte:${SLOT} )
	kde? ( kde-misc/qutim-kdeintegration:${SLOT} )
	aescrypto? ( x11-plugins/qutim-aescrypto:${SLOT} )
	antiboss? ( x11-plugins/qutim-antiboss:${SLOT} )
	antispam? ( x11-plugins/qutim-antispam:${SLOT} )
	aspeller? ( x11-plugins/qutim-aspeller:${SLOT} )
	awn? ( x11-plugins/qutim-awn:${SLOT} )
	clconf? ( x11-plugins/qutim-clconf:${SLOT} )
	connectionmanager? ( x11-plugins/qutim-connectionmanager:${SLOT} )
	dbus? ( x11-plugins/qutim-dbusapi:${SLOT} )
	histman? ( x11-plugins/qutim-histman:${SLOT} )
	hunspeller? ( x11-plugins/qutim-hunspeller:${SLOT} )
	indicator? ( x11-plugins/qutim-indicator:${SLOT} )
	massmessaging? ( x11-plugins/qutim-massmessaging:${SLOT} )
	nowplaying? ( x11-plugins/qutim-nowplaying:${SLOT} )
	phonon? ( x11-plugins/qutim-phonon:${SLOT} )
	unreadmessageskeeper? ( x11-plugins/qutim-unreadmessageskeeper:${SLOT} )
	urlpreview? ( x11-plugins/qutim-urlpreview:${SLOT} )
	weather? ( x11-plugins/qutim-weather:${SLOT} )
	yandexnarod? ( x11-plugins/qutim-yandexnarod:${SLOT} )
	sdl? ( x11-plugins/qutim-sdlsound:${SLOT} )
	kineticpopups? ( x11-plugins/qutim-kineticpopups:${SLOT} )"

RESTRICT="debug? ( strip )"

src_unpack() {
	git_src_unpack
}

src_prepare() {
	CMAKE_IN_SOURCE_BUILD=1

	if (use debug) ; then
		unset CFLAGS CXXFLAGS
		append-flags -O1 -g -ggdb
		CMAKE_BUILD_TYPE="Debug"
	fi

	mycmakeargs=(
		-DQSOUNDBACKEND=0
		$(cmake-utils_use webkit WEBKITCHAT)
		$(cmake-utils_use kineticscroller KINETICSCROLLER)
	)

	if (use static) ; then
		mycmakeargs+=(-DQUTIM_BASE_LIBRARY_TYPE=STATIC)
	fi

	if (use mobile) ; then
		mycmakeargs+=(-DMOBILESETTINGSDIALOG=1)
	else
		mycmakeargs+=(
			-DSTACKEDCHATFORM=0
			-DMOBILECONTACTINFO=0
			-DMOBILEABOUT=0
			-DMOBILESETTINGSDIALOG=0
			-DSOFTKEYSACTIONBOX=0
		)
	fi
}

src_install() {
	cmake-utils_src_install
}

pkg_postinst() {
	einfo
	einfo "Many plugins is unstable. If you have problems with qutim try to unmerge unnecessary plugins."
	einfo
}
