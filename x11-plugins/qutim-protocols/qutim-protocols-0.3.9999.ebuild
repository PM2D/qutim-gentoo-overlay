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
CMAKE_USE_DIR="${S}/protocols"

DESCRIPTION="Protocols for net-im/qutim"
HOMEPAGE="http://www.qutim.org"

LICENSE="GPL-2"
SLOT="0.3-live"
KEYWORDS=""
IUSE="+icq +jabber irc vkontakte mrim astral libpurple debug"

RDEPEND="net-im/qutim:${SLOT}
	>=x11-libs/qt-core-4.6.3
	sys-libs/zlib
	net-dns/libidn
	app-crypt/qca
	app-crypt/qca-cyrus-sasl
	jabber? ( !app-crypt/qca-ossl )
	libpurple? ( >=net-im/pidgin-2.6.0 )
	astral? ( >=net-libs/telepathy-qt4-0.3.0 )"

DEPEND="${RDEPEND}
	>=dev-util/cmake-2.6"

RESTRICT="debug? ( strip )"

pre_src_unpack() {
	if (use astral) ; then
		ewarn "WARNING: You have enabled the build of the astral plugin, which is known to not work at the moment"
	fi
	if (use libpurple) ; then
		ewarn "WARNING: You have enabled the build of the libpurple plugin, which is known to not work at the moment"
	fi
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
		$(cmake-utils_use icq OSCAR)
		$(cmake-utils_use icq XSTATUS)
		$(cmake-utils_use icq IDENTIFY)
		$(cmake-utils_use jabber JABBER)
		$(cmake-utils_use irc IRC)
		$(cmake-utils_use mrim MRIM)
		$(cmake-utils_use vkontakte VKONTAKTE)
		$(cmake-utils_use vkontakte WALL)
		$(cmake-utils_use vkontakte PHOTOALBUM)
		$(cmake-utils_use vkontakte VPHOTOALBUM/DEFAULT)
		$(cmake-utils_use astral ASTRAL)
		$(cmake-utils_use libpurple QUETZAL)
	)

	CMAKE_IN_SOURCE_BUILD=1
}
