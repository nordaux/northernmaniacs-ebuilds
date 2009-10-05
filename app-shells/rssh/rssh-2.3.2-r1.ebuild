# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $


inherit eutils

DESCRIPTION="Restricted shell for SSHd"
HOMEPAGE="http://rssh.sourceforge.net/"
SRC_URI="mirror://sourceforge/rssh/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static git"

RDEPEND="virtual/ssh"

src_unpack() {
	unpack ${A}
	cd "${S}"
	if use git ; then
		epatch "${FILESDIR}/rssh-git.patch" || die "patching failed"
	fi
#	sed -i 's:chmod u+s $(:chmod u+s $(DESTDIR)$(:' Makefile.in
}

src_compile() {
	econf \
		--libexecdir='$(libdir)/misc' \
		--with-scp=/usr/bin/scp \
		--with-sftp-server="/usr/$(get_libdir)/misc/sftp-server" \
		$(use_enable static) \
		 || die "econf failed"
	emake || die
}

src_install() {
	make install DESTDIR="${D}" || die
	dodoc AUTHORS ChangeLog CHROOT INSTALL README TODO
}
