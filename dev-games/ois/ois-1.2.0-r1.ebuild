# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools

DESCRIPTION="Object-oriented Input System - A cross-platform C++ input handling library."
#This ebuild enhances ois so, that ois behaviour is heavily changed! 
#See http://sourceforge.net/tracker/?func=detail&aid=2671880&group_id=149835&atid=775955 for details."
HOMEPAGE="http://www.wreckedgames.com/"
SRC_URI="mirror://sourceforge/wgois/${P/-/_}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/libXaw
	x11-libs/libX11"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}

mywarn() {
	ewarn ""
	ewarn "This ebuild enhances ois so, that ois behaviour is heavily changed!"
	ewarn "See http://sourceforge.net/tracker/?func=detail&aid=2671880&group_id=149835&atid=775955"
	ewarn "for details."
	ewarn
}

src_unpack() {
	mywarn
	unpack ${A}
	cd "${S}"
	#http://sourceforge.net/tracker/?func=detail&aid=2671880&group_id=149835&atid=775955
	epatch "${FILESDIR}"/2671880.patch
	epatch "${FILESDIR}"/2671880_linux.patch

	epatch "${FILESDIR}"/x11_key_repeat.patch
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}

pkg_postinst() {
	mywarn
}
