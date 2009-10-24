# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils bash-completion

DESCRIPTION="A nice paludis.log parser (patched genlop)"
HOMEPAGE="http://www.genoetigt.de/site/projects/plop"
# I copied the genlop-0.30.8.tar.gz and renamed it to plop-0.1.tar.gz
SRC_URI="http://www.genoetigt.de/plop/${P}.tar.gz
		 http://cloud.github.com/downloads/mlilien/northernmaniacs-ebuilds/plop-0.2.3.tar.gz"
RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""

RDEPEND=">=dev-lang/perl-5.8.0-r12
	 >=dev-perl/DateManip-5.40
	 dev-perl/libwww-perl"


src_unpack() {
	unpack ${A}
	mv "${WORKDIR}/genlop-0.30.8/" "${S}"
	cd "${S}"
	mv genlop plop
	mv genlop.1 plop.1
#	mv genlop.bash-completion plop.bash-completion

epatch "${FILESDIR}/plop-${PV}_0.30.8.patch"
}

src_install() {
	dobin plop || die "failed to install plop (via dobin)"
	dodoc README Changelog
	doman plop.1
	dobashcompletion "${FILESDIR}/plop.bash-completion" plop
}

pkg_postinst() {
	einfo "Note that plop is just a patched genlop-0.30.8. I only patched the"
	einfo "main script. The manpage, README, etc. are all original genlop"
	einfo "files, but since plop is expected to work like genlop this"
	einfo "shouldn't be a problem. so if you find see genlop somewhere, simply"
	einfo "substitute it with plop, as long as it hasn't to do anything with"
	einfo "copyright or other credits"

	einfo "to convert old emerge.logfiles I've written a small perlscript that"
	einfo "you can download on the plop homepage"
}
