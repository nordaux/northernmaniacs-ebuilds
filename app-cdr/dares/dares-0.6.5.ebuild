# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Data rescue tool for CDs and DVDs."
HOMEPAGE="http://www.heise.de/ct/05/16/links/078.shtml"
SRC_URI="ftp://ftp.heise.de/pub/ct/ctsi/dares.tgz
		 http://cloud.github.com/downloads/mlilien/northernmaniacs-ebuilds/dares.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sys-apps/file
		sys-libs/ncurses"
DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/magic_handling.patch" || die "epatch failed"
}

src_compile() {
	emake ncurses || die "emake failed"
}

src_install() {
	dobin frontend/ncurses/dares
	insinto usr/share/${PN}/
	doins magic
	doins magic.mime
	dodoc doc/README.deutsch
}
