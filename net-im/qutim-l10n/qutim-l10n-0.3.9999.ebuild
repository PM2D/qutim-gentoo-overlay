# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit git

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
IUSE="linguas_ru linguas_bg linguas_cs linguas_de linguas_uk"
LANGUAGES=""

DEPEND=""
RDEPEND="${DEPEND}
	net-im/qutim:${SLOT}"

src_unpack() {
	git_src_unpack
}

src_compile() {
	if use linguas_ru ; then
		LANGUAGES="${LANGUAGES} ru_RU"
	fi
	if use linguas_bg ; then
		LANGUAGES="${LANGUAGES} bg_BG"
	fi
	if use linguas_cs ; then
		LANGUAGES="${LANGUAGES} cs_CZ"
	fi
	if use linguas_de ; then
		LANGUAGES="${LANGUAGES} de_DE"
	fi
	if use linguas_uk ; then
		LANGUAGES="${LANGUAGES} uk_UA"
	fi
	einfo "Compiling translates for ${LANGUAGES}"
	if [ "x${LANGUAGES}" != "x" ]; then
		${CMAKE_USE_DIR}/make.sh compile ${LANGUAGES}
	fi
}

src_install() {
	if [ "x${LANGUAGES}" != "x" ]; then
		LANG_DIR="${D}/usr/share/qutim/languages"
		mkdir -p ${LANG_DIR}
		for LANG in ${LANGUAGES}; do
			mkdir -p ${LANG_DIR}/${LANG}
			cp ${CMAKE_USE_DIR}/${LANG}/binaries/*.qm ${LANG_DIR}/${LANG};
		done
	fi
}

pkg_postinst() {
        ewarn
        ewarn "If localization doesn't appear for you, change \"shareDir\" value"
	ewarn "in .config/qutim/profiles/profiles.json to \"/usr/share/qutim\""
        ewarn
}
