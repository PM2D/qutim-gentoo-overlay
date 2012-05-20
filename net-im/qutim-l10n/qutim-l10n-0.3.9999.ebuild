# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit git-2 cmake-utils

EGIT_HAS_SUBMODULES="true"
EGIT_REPO_URI="git://github.com/euroelessar/qutim.git"
EGIT_BRANCH="master"
EGIT_COMMIT="${EGIT_BRANCH}"
EGIT_PROJECT="qutim"
CMAKE_USE_DIR="${S}/translations"

DESCRIPTION="Localization package for net-im/qutim"
HOMEPAGE="http://qutim.org"

LICENSE="GPL-2"
SLOT="0.3-live"
KEYWORDS=""
IUSE="linguas_ru linguas_bg linguas_cs linguas_de linguas_uk linguas_sk"
LANGUAGES=""

DEPEND=""
RDEPEND="${DEPEND}
	net-im/qutim:${SLOT}"

src_unpack() {
	git-2_src_unpack
}

src_prepare() {
	CMAKE_IN_SOURCE_BUILD=1
	mycmakeargs=(
		-DQUTIM_ENABLE_ALL_PLUGINS=off
		$(cmake-utils_use linguas_ru LANGUAGES/RU)
		$(cmake-utils_use linguas_bg LANGUAGES/BG)
		$(cmake-utils_use linguas_cs LANGUAGES/CS)
		$(cmake-utils_use linguas_de LANGUAGES/DE)
		$(cmake-utils_use linguas_uk LANGUAGES/UK)
		$(cmake-utils_use linguas_sk LANGUAGES/SK)
	)

}

pkg_postinst() {
	ewarn
	ewarn "If localization doesn't appear for you, change \"shareDir\" value"
	ewarn "in .config/qutim/profiles/profiles.json to \"/usr/share/qutim\""
	ewarn
}
