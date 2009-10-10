# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1
NEED_PYTHON=2.4

inherit python distutils

MY_P="/${P/_rc/rc}"

DESCRIPTION="A plugin for Bazaar that aims to provide GTK+ interfaces to most
Bazaar operations"
HOMEPAGE="http://bazaar-vcs.org/bzr-gtk"
SRC_URI="http://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gconf gnome-keyring gpg +gtksourceview libnotify nautilus"

DEPEND=">=dev-util/bzr-1.6_rc1
	>=dev-python/pygtk-2.8
	nautilus? ( dev-python/nautilus-python )
	>=dev-python/pycairo-1.0"
RDEPEND="${DEPEND}
	gnome-keyring? ( dev-python/gnome-keyring-python )
	gpg? ( app-crypt/seahorse )
	gtksourceview? (
		dev-python/pygtksourceview
		gconf? ( dev-python/gconf-python )
	)
	libnotify? (
		dev-python/notify-python
		dev-util/bzr-dbus
	 )"

S="${WORKDIR}/${MY_P}"

#TODO: src_test

src_install() {
	distutils_src_install

	if use libnotify; then
		insinto /etc/xdg/autostart
		doins bzr-notify.desktop
	fi
}
