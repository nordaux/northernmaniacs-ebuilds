# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit versionator eutils

DESCRIPTION="gedit plugin: Bazaar integration"
HOMEPAGE="https://launchpad.net/bzr-gedit/"
SRC_URI="http://edge.launchpad.net/${PN}/${PV}/${PV}/+download/${PN}.${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+bzr-gtk"

DEPEND=">=dev-lang/python-2.4
	>=dev-python/pygtk-2.8
	>=dev-util/bzr-1.0_rc1"

RDEPEND="${DEPEND}
	>=app-editors/gedit-2.13[python]
	bzr-gtk? ( >=dev-util/bzr-gtk-0.93 )"

S=${WORKDIR}/${PN}.${PV}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.6.5-no-autodetect.patch
}

src_install() {
	dodir /usr/lib/gedit-2/plugins
	python setup.py install -location="${D}"/usr/lib/gedit-2/plugins/ || die
	dodoc README ROADMAP || die
}
