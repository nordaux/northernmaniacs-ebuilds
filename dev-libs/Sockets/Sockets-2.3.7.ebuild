# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="cross-platform C++ class library wrapping the berkeley sockets C API"
HOMEPAGE="http://www.alhem.net/Sockets/index.html"
SRC_URI="http://www.alhem.net/Sockets/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ssl"

RDEPEND="ssl? ( dev-libs/openssl )"
DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch "${FILESDIR}/2.3.7-include_fix.diff"

	#upstreams default configuration disables libxml2 but the build system 
	#doesnt know, so sed it out.
	sed -ie "s/^INCLUDE/$#INCLUDE/g" Makefile || die "couldnt disable xml2"
	sed -ie "/^[ \t]\{1,\}-Wl,-lxml2 \\\/d" Makefile.Defines.linux-x86-32 \
		|| die "couldnt disable xml2"

	if ! use ssl ; then
		#ssl is enabled by upstreams default so sed it out 
		sed -e "s/^#define HAVE_OPENSSL/\/\/#define HAVE_OPENSSL/g" \
			-i sockets-config.h || die "couldnt disable ssl"
		sed -e "/^[ \t]\{1,\}-lssl -lcrypto \\\/d" \
			-e	"/^[ \t]\{1,\}-Wl,-lssl \\\/d" \
			-e	"/^[ \t]\{1,\}-Wl,-lcrypto \\\/d" \
			-i Makefile.Defines.linux-x86-32 || die "couldnt disable ssl"
	fi
}

src_compile() {
	emake shared || die "emake failed"
}

src_install() {
	emake PREFIX="/usr" DESTDIR="${D}" install_shared || die "install failed"
}
