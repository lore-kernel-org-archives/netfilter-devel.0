From: Harald Welte <laforge@gnumonks.org>
Subject: Re: Wanted: netfilter:arptables working example.
Date: Sat, 7 Sep 2002 11:51:25 +0200
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20020907115125.M9675@sunbeam.de.gnumonks.org>
References: <3D78AC8F.8050409@masirv.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TnYVF1hk1c8rpHiF"
Cc: linux-kernel@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@lists.netfilter.org>
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: Lee Van Dyke <VandykeL@masirv.com>
Content-Disposition: inline
In-Reply-To: <3D78AC8F.8050409@masirv.com>; from VandykeL@masirv.com on Fri, Sep 06, 2002 at 06:24:31AM -0700
List-Id: netfilter-devel.vger.kernel.org


--TnYVF1hk1c8rpHiF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 06, 2002 at 06:24:31AM -0700, Lee Van Dyke wrote:
> Wanted: netfilter arptables working example.
>=20
> I've looked throught the archives and am unable to find any examples.

there is none.  david miller has introduced netfilter hooks to arp and port=
ed
iptables to arp (called arptables).  However, there is no userspace program
for configuration (yet?).

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M+=
=20
V-- PS++ PE-- Y++ PGP++ t+ 5-- !X !R tv-- b+++ !DI !D G+ e* h--- r++ y+(*)

--TnYVF1hk1c8rpHiF
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9ecwcXaXGVTD0i/8RApS8AKCoqk1JFyPR/g24lvgZOCw+WclA1gCfQYLo
zkcP9ZgbEBk6XYEZtuBlxe8=
=5Wxb
-----END PGP SIGNATURE-----

--TnYVF1hk1c8rpHiF--
