# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit distutils eutils multilib fdo-mime


DESCRIPTION="Open-source, non-profit video player and podcast client."
HOMEPAGE="http://www.getmiro.com/"
SRC_URI="http://ftp.osuosl.org/pub/pculture.org/miro/src/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/pygtk
	net-libs/xulrunner:1.9
	dev-python/gnome-python-extras-base
	dev-python/gnome-python
	dev-python/gtkmozembed-python
	dev-python/gst-python
	media-libs/gst-plugins-base
	dev-libs/boost:1.39[python]
	>=dev-lang/python-2.5[berkdb,sqlite]
	>=net-libs/rb_libtorrent-0.14[python]
	dev-python/dbus-python
	dev-python/notify-python"
DEPEND="${RDEPEND}
	dev-python/pyrex
	dev-util/pkgconfig"

S="${WORKDIR}/${P}/platform/gtk-x11"

src_prepare() {
	cd "${WORKDIR}/${P}"
	epatch \
		"${FILESDIR}/2.0.4-ubuntu-movies_dir.patch" \
		"${FILESDIR}/2.0.4-ubuntu-no_autoupdate.patch"
}

src_configure() {
	sed -i \
		-e "s|^\(XPCOM_RUNTIME_PATH\) = .*|\1 = '/usr/$(get_libdir)/xulrunner-1.9'|" \
		-e 's|^\(XPCOM_LIB\) = .*|\1 = "libxul"|' \
		-e 's|^\(GTKMOZEMBED_LIB\) = .*|\1 = "libxul"|' \
		-e 's|^\(XULRUNNER_19\) = .*|\1 = True|' \
		-e 's|boost_python|boost_python-mt|' \
		setup.py || die "sed failed"
}

pkg_postinst() {
	elog "Please restart dbus"
	fdo-mime_mime_database_update
}
