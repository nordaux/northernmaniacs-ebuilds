# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit autotools eutils

MY_P=CEGUI-${PV}
MY_D=CEGUI-DOCS-${PV}
DESCRIPTION="Crazy Eddie's GUI System"
HOMEPAGE="http://www.cegui.org.uk/"
SRC_URI="mirror://sourceforge/crayzedsgui/${MY_P}.tar.gz
	doc? ( mirror://sourceforge/crayzedsgui/${MY_D}.tar.gz )"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug devil directfb doc examples expat freeimage irrlicht lua opengl xerces-c xml"

RDEPEND="dev-libs/libpcre
	media-libs/freetype:2
	dev-libs/tinyxml
	devil? ( media-libs/devil )
	directfb? ( dev-libs/DirectFB )
	expat? ( dev-libs/expat )
	freeimage? ( media-libs/freeimage )
	irrlicht? ( dev-games/irrlicht )
	lua? (
		dev-lang/lua
		dev-lang/toluapp
	)
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
	econf \
		$(use_enable debug) \
		$(use_enable devil) \
		$(use_enable directfb directfb-renderer) \
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
		--enable-static \
		--enable-tga \
		--enable-tinyxml \
		--disable-corona \
		--disable-dependency-tracking \
		--disable-samples \
		--disable-silly \
		--without-gtk2 \
		--disable-ogre-renderer
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	if use doc ; then
		emake html || die "emake html failed"
		dohtml -r doc/doxygen/html || die "dohtml failed"
	fi
	if use examples ; then
		insinto /usr/share/doc/${PF}/Samples
		doins -r Samples.clean/* || die "doins failed"
	fi
}
