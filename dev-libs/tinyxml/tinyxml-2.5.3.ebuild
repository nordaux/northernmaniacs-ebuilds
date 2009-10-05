# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit flag-o-matic toolchain-funcs

DESCRIPTION="a simple, small, C++ XML parser that can be easily integrating into other programs"
HOMEPAGE="http://www.grinninglizard.com/tinyxml/index.html"
SRC_URI="mirror://sourceforge/tinyxml/${PN}_${PV//./_}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND=""
DEPEND=""

S=${WORKDIR}/${PN}

src_prepare() {
	cp -f "${FILESDIR}"/Makefile . || die
}

src_compile() {
	tc-export AR CXX RANLIB

	emake || die "emake failed"
}

src_install() {
	dolib.so *.so* || die "dolib.so failed"
	dolib.a *.a || die "dolib.a failed"

	insinto /usr/include
	doins *.h || die "doins failed"

	dodoc {changes,readme}.txt || die "dodoc failed"

	if use doc; then
		dodoc tutorial_gettingStarted.txt || die "dodoc failed"
		dohtml -r docs/* || die "dohtml failed"
	fi
}
