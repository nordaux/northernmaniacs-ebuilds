# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-games/ogre/ogre-1.6.2.ebuild,v 1.2 2009/04/12 02:44:58 mr_bones_ Exp $

EAPI=2
inherit multilib eutils autotools flag-o-matic

DESCRIPTION="Object-oriented Graphics Rendering Engine"
HOMEPAGE="http://www.ogre3d.org/"
SRC_URI="mirror://sourceforge/ogre/ogre-v${PV//./-}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc cg devil double-precision examples freeimage gtk threads"
RESTRICT="test" #139905

RDEPEND="dev-libs/zziplib
	media-libs/freetype:2
	virtual/opengl
	virtual/glu
	x11-libs/libXt
	x11-libs/libXaw
	x11-libs/libXrandr
	x11-libs/libX11
	cg? ( media-gfx/nvidia-cg-toolkit )
	devil? ( media-libs/devil )
	freeimage? ( media-libs/freeimage )
	gtk? ( x11-libs/gtk+:2 )
	threads? ( || ( >=dev-libs/boost-1.34.1 dev-libs/boost[threads] ) )"
DEPEND="${RDEPEND}
	x11-proto/xf86vidmodeproto
	dev-util/pkgconfig"

S=${WORKDIR}/${PN}

src_prepare() {
	ecvs_clean
	if use examples ; then
		cp -r Samples install-examples || die
		find install-examples \
			'(' -name .keepme -o -name '*.cbp' -o -name '*.vcproj*' ')' \
			-print0 | xargs -0 rm -rf
		find install-examples -type d -print0 | xargs -0 rmdir 2> /dev/null
		sed -i \
			-e "s:/usr/local/lib/OGRE:/usr/$(get_libdir)/OGRE:" \
			$(grep -rl /usr/local/lib/OGRE install-examples) \
			|| die "sed failed"
	fi
	sed -i -e '/CPPUNIT/d' configure.in || die "sed failed"
	eautoreconf
}

src_configure() {
	strip-flags
		econf \
		--disable-dependency-tracking \
		--disable-openexr \
		--disable-ogre-demos \
		--enable-static \
		--with-platform=GLX \
		--with-gui=$(usev gtk || echo Xt) \
		$(use_enable cg) \
		$(use_enable devil) \
		$(use_enable double-precision double) \
		$(use_enable freeimage) \
		$(use_enable threads threading)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	if use doc ; then
		insinto /usr/share/doc/${PF}/html
		doins -r Docs/* || die "doins Docs failed"
	fi
	if use examples ; then
		insinto /usr/share/doc/${PF}/Samples
		doins -r install-examples/* || die "doins Samples failed"
	fi
	dodoc AUTHORS BUGS LINUX.DEV README
}
