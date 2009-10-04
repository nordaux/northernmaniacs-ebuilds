# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-games/ogre/ogre-1.6.0.ebuild, v1.0 2008/12/31 01:20:00 lothmordor mr_bones_ Exp $

inherit multilib eutils autotools flag-o-matic

DESCRIPTION="Object-oriented Graphics Rendering Engine"
HOMEPAGE="http://www.ogre3d.org/"
SRC_URI="mirror://sourceforge/ogre/ogre-v${PV//./-}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="x86"
IUSE="doc cg devil double-precision examples freeimage gtk openexr stlport threads"

RDEPEND="dev-libs/zziplib
	>=media-libs/freetype-2
	virtual/opengl
	virtual/glu
	dev-games/cegui
	dev-games/ois
	x11-libs/libXt
	x11-libs/libXaw
	x11-libs/libXrandr
	x11-libs/libX11
	cg? ( media-gfx/nvidia-cg-toolkit )
	devil? ( media-libs/devil )
	freeimage? ( media-libs/freeimage )
	gtk? ( >=x11-libs/gtk+-2 )
	openexr? ( media-libs/openexr )
	stlport? ( dev-libs/STLport )
	threads? ( dev-libs/boost )"
DEPEND="${RDEPEND}
	x11-proto/xf86vidmodeproto
	dev-util/pkgconfig"

S=${WORKDIR}/${PN}

pkg_setup() {
	if use threads && ! built_with_use --missing true dev-libs/boost threads
	then
		die "Please emerge dev-libs/boost with USE=threads"
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
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
#	epatch "${FILESDIR}"/${P}-*.patch
	eautoreconf
}

src_compile() {
	strip-flags
		econf \
		--disable-dependency-tracking \
		--disable-freeimage \
		--disable-ogre-demos \
		--enable-static \
		--with-platform=GLX \
		--with-gui=$(usev gtk || echo Xt) \
		$(use_enable cg) \
		$(use_enable devil) \
		$(use_enable double-precision double) \
		$(use_enable freeimage) \
		$(use_enable openexr) \
		$(use_with stlport) \
		$(use_enable threads threading) \
		|| die
	emake || die "emake failed"
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
