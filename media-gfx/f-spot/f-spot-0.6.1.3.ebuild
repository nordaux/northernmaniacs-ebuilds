# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit gnome2 mono eutils autotools multilib

DESCRIPTION="Personal photo management application for the gnome desktop"
HOMEPAGE="http://f-spot.org"
SRC_URI="http://ftp.gnome.org/pub/GNOME/sources/f-spot/0.6/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="beagle flickr"

RDEPEND=">=dev-lang/mono-2.0
	>=gnome-base/libgnome-2.2
	>=gnome-base/libgnomeui-2.2
	>=media-libs/libexif-0.6.16
	<media-libs/libexif-0.7.0
	>=dev-dotnet/gtk-sharp-2.12.2
	>=dev-dotnet/glib-sharp-2.12.2
	>=dev-dotnet/glade-sharp-2.12.2
	>=dev-dotnet/gnomevfs-sharp-2.12.2
	>=x11-libs/gtk+-2.14
	>=dev-libs/glib-2.16
	>=dev-dotnet/gnome-sharp-2.8
	>=dev-dotnet/glib-sharp-2.12
	>=dev-dotnet/gconf-sharp-2.12.2
	beagle? ( >=app-misc/beagle-0.3.0 )
	>=dev-libs/dbus-glib-0.71
	>=dev-dotnet/dbus-sharp-0.4.2
	>=dev-dotnet/dbus-glib-sharp-0.3.0
	media-libs/jpeg
	>=media-libs/lcms-1.12
	>=media-libs/libgphoto2-2.1.4
	>=dev-db/sqlite-3
	flickr? ( dev-dotnet/flickrnet-bin )"

DEPEND="${RDEPEND}
	>=dev-dotnet/gtk-sharp-gapi-2.12.2
	app-text/gnome-doc-utils
	dev-util/pkgconfig
	>=dev-util/intltool-0.35"

DOCS="AUTHORS ChangeLog MAINTAINERS NEWS README"

SCROLLKEEPER_UPDATE=0

src_prepare() {

	if ! use flickr; then
		sed -i -e '/FlickrExport/d' extensions/Exporters/Makefile.am || die
	fi

	eautoreconf
}

src_configure() {
	gnome2_src_configure --disable-static --disable-scrollkeeper \
		--with-flickrnet=/usr/$(get_libdir)/mono/FlickrNet/FlickrNet.dll
}

src_install() {
	gnome2_src_install
	find "${D}" -name '*.la' -delete || die ".la removal failed"
}
