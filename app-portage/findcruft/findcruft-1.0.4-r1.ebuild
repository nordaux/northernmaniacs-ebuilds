# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DEPEND=""
RDEPEND=""
DESCRIPTION="Yet another script to find obsolete files"
HOMEPAGE="http://forums.gentoo.org/viewtopic.php?t=254197"
IUSE=""
KEYWORDS="~x86 ~amd64"
LICENSE="GPL-2"
RESTRICT="mirror"
SLOT="0"
SRC_URI="http://user.cs.tu-berlin.de/~sean/${P}.tar.bz2
		 http://cloud.github.com/downloads/mlilien/northernmaniacs-ebuilds/${P}.tar.bz2
		 http://ifp.loeber1.de/findcruft-config-20050807.tar.bz2
		 http://cloud.github.com/downloads/mlilien/northernmaniacs-ebuilds/findcruft-config-20050807.tar.bz2"

src_unpack() {
	unpack ${A}
	sed -i "s#/usr/local#/usr#" "${WORKDIR}/bin/findcruft" || die
}

src_install() {
	mkdir -p "${D}/usr/lib" && mv "${WORKDIR}/findcruft" "${D}/usr/lib" || die
	insinto /usr
	dobin "${WORKDIR}/bin/findcruft"
	dodoc "${WORKDIR}/lib/findcruft/LICENSE"
}

pkg_postinst() {
	einfo "Please check the files findcruft reports as cruft carefully"
	einfo "before deleting them! There may be false positives!"
}
