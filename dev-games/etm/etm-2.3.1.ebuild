# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="The Editable Terrain Manager is an OGRE addon library for handling terrain based on heightmap data."
HOMEPAGE="http://www.oddbeat.de/wiki/etm"
SRC_URI="http://downloads.oddbeat.de/ETMv${PV}_source.zip
		 http://cloud.github.com/downloads/mlilien/northernmaniacs-ebuilds/ETMv${PV}_source.zip"

LICENSE="GPL-2-with-linking-exception"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-games/ogre-1.4"
DEPEND="${RDEPEND}"

#S={$WORKDIR}/${PN/ogre_/}-${PV}

src_unpack() {
	unpack ${A}
	cd "${S}"
	mkdir bin obj
}

src_install() {
	dolib.so bin/*.so
	insinto /usr/include/OGRE
	doins include/*.h
}
