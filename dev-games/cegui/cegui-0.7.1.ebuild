# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils multilib

MY_P=CEGUI-${PV}
MY_D=CEGUI-DOCS-${PV}
DESCRIPTION="Crazy Eddie's GUI System is a free library providing windowing and widgets for graphic APIs/engines."
HOMEPAGE="http://www.cegui.org.uk/"
SRC_URI="mirror://sourceforge/crayzedsgui/${MY_P}.tar.gz
	doc? ( mirror://sourceforge/crayzedsgui/${MY_D}.tar.gz )"

LICENSE="MIT"
SLOT="0.7"
KEYWORDS="~amd64 ~x86"
IUSE="debug devil doc examples expat freeimage gtk irrlicht lua ogre opengl xerces-c xml"

RDEPEND="dev-libs/libpcre
	media-libs/freetype:2
	dev-libs/tinyxml
	devil? ( media-libs/devil )
	expat? ( dev-libs/expat )
	freeimage? ( media-libs/freeimage )
	irrlicht? ( dev-games/irrlicht )
	lua? (
		dev-lang/lua
		dev-lang/toluapp
	)
	ogre? ( dev-games/ogre )
	opengl? (
		virtual/opengl
		virtual/glu
		virtual/glut
		media-libs/glew
	)
	xerces-c? ( dev-libs/xerces-c )
	xml? ( dev-libs/libxml2 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S=${WORKDIR}/${MY_P}

src_prepare() {
	if use examples ; then
		cp -r Samples Samples.clean
		rm -f $(find Samples.clean -name 'Makefile*')
	fi
}

src_configure() {
	MYECONF=
	econf \
		--libdir=/usr/$(get_libdir)/${P} \
		--includedir=/usr/include/${P} \
		--datarootdir=/usr/share/${P} \
		--datadir=/usr/share/${P} \
		$(use_enable debug) \
		$(use_enable devil) \
		$(use_enable expat) \
		$(use_enable freeimage) \
		$(use_enable irrlicht irrlicht-renderer) \
		$(use_enable lua external-toluapp) \
		$(use_enable lua lua-module) \
		$(use_enable lua toluacegui) \
		$(use_enable opengl external-glew) \
		$(use_enable opengl opengl-renderer) \
		$(use_enable xerces-c) \
		$(use_enable xml libxml) \
		$(use_enable ogre ogre-renderer) \
		--enable-static \
		--enable-tga \
		--enable-tinyxml \
		--disable-corona \
		--disable-dependency-tracking \
		--disable-samples \
		--disable-silly \
		$(use_with gtk gtk2)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	#remove .la files
	rm -f $(find "${D}/usr/$(get_libdir)/${P}" -name *.la)

	#rename binarys
	find "${D}/usr/bin" -type f -print0 | xargs -0 -I \{\} mv \{\} \{\}-${PV}

	#move and rename pkgconfig files
	mv "${D}/usr/$(get_libdir)/${P}/pkgconfig" "${D}/usr/$(get_libdir)/"
	cd "${D}/usr/$(get_libdir)/pkgconfig"
	find -type f -print0 | xargs -0 -I \{\} basename \{\} .pc | \
		xargs -I \{\} mv \{\}.pc \{\}-${SLOT}.pc
	cd "${S}"

	if use doc ; then
		emake html || die "emake html failed"
		dohtml -r doc/doxygen/html/* || die "dohtml failed"
	fi
	if use examples ; then
		insinto /usr/share/doc/${PF}/Samples
		doins -r Samples.clean/* || die "doins failed"
	fi
}
