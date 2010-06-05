# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit git eutils qt4

EGIT_REPO_URI="http://git.gitorious.org/qutim/plugins.git"
EGIT_BRANCH="sdk02"
EGIT_COMMIT="${EGIT_BRANCH}"
EGIT_PROJECT="qutim-plugins"
DESCRIPTION="MassMessaging plugin for net-im/qutim"
HOMEPAGE="http://www.qutim.org"

LICENSE="GPL-2"
SLOT="0.2-live"
KEYWORDS=""
IUSE="debug"

RDEPEND="net-im/qutim:${SLOT}"

DEPEND="${RDEPEND}"

RESTRICT="debug? ( strip )"

MY_PN=${PN#qutim-}

src_unpack() {
	git_src_unpack
}

src_prepare() {
	S=${S}/${MY_PN}
	if (use debug) ; then
		unset CFLAGS CXXFLAGS
		append-flags -O1 -g -ggdb
	fi
	for i in $(grep -ril "<qutim/" "${S}" | grep -v "\.git"); do
		sed -e "s/<qutim\//<qutim-${PV}\//" -i ${i};
	done
	sed -e "/unix/s/qutim/qutim-${PV}/" -i "${S}/${MY_PN}.pro"
}

src_compile() {
	eqmake4 ${MY_PN}.pro || die "Failed plugin configure"
	emake || die "Failed plugin build"
}

src_install() {
	insinto "/usr/$(get_libdir)/qutim-${PV}"
	doins "${S}/lib${MY_PN}.so" || die "Plugin installation failed"
}
