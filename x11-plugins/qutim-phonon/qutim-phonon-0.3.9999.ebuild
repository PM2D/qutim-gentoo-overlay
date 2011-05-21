# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit git eutils cmake-utils

EGIT_HAS_SUBMODULES="true"
EGIT_REPO_URI="git://github.com/euroelessar/qutim.git"
EGIT_BRANCH="master"
EGIT_COMMIT="${EGIT_BRANCH}"
EGIT_PROJECT="qutim"
CMAKE_USE_DIR="${S}/plugins"

DESCRIPTION="Phonon sound backend for net-im/qutim"
HOMEPAGE="http://www.qutim.org"

LICENSE="GPL-2"
SLOT="0.3-live"
KEYWORDS=""
IUSE="debug"

RDEPEND="net-im/qutim:${SLOT}
	media-libs/phonon"

DEPEND="${RDEPEND}"

RESTRICT="debug? ( strip )"

src_unpack() {
	git_src_unpack
}

src_prepare() {
	if (use debug) ; then
		unset CFLAGS CXXFLAGS
		append-flags -O1 -g -ggdb
		CMAKE_BUILD_TYPE="debug"
	fi
	mycmakeargs="-DQUTIM_ENABLE_ALL_PLUGINS=off -DPHONONSOUND=on"
	CMAKE_IN_SOURCE_BUILD=1
}
