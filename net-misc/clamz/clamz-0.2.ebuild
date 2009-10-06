#Copyright 1999-2009
#Distributed under the terms of the GNU General Public License v2
#$Header:$

SLOT="0"	
LICENSE="GPL-3"	
KEYWORDS="~x86"
DESCRIPTION="Command-line downloader for the Amazon.com MP3 music store"
SRC_URI="http://clamz.googlecode.com/files/clamz-0.2.tar.gz"
HOMEPAGE="http://code.google.com/p/clamz/"
DEPEND="net-misc/curl dev-libs/libgcrypt dev-libs/expat"
IUSE=""

pkg_nofetch() 
{
   einfo "Download clamz at the following site"
   einfo ${HOMEPAGE}
   einfo ""
   einfo "Then place the file ${SRC_URI}"
   einfo "into ${DISTDIR} and restart the emerge."
}

src_unpack()
{ 
   unpack ${A}
   cd "${S}"
}

src_compile()
{
    econf || die "econf failed"
} 

src_install()
{
    emake DESTDIR="${D}" install || die "emake install failed"
}
