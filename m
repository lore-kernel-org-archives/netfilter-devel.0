From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH] Re: bug in iptables-save/iptables-restore
Date: Thu, 5 Dec 2002 21:32:56 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021205203256.GL11068@naboo.club.berlin.ccc.de>
References: <3DD7B46F.3050006@attbi.com> <20021124124344.20640cb8.rh0209ms@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kaF1vgn83Aa7CiXN"
Cc: netfilter-devel@lists.netfilter.org, Gerry Skerbitz <gsker@attbi.com>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Michael Schwendt <rh0209ms@arcor.de>
Content-Disposition: inline
In-Reply-To: <20021124124344.20640cb8.rh0209ms@arcor.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--kaF1vgn83Aa7CiXN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 24, 2002 at 12:43:44PM +0100, Michael Schwendt wrote:
> It should go before the 40:68, but separated with whitespace,
> like: -m length --length ! 40:68
>=20
> Try attached patch.

thanks, patch applied.

> Michael

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M-=
=20
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)

--kaF1vgn83Aa7CiXN
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE977f4XaXGVTD0i/8RAsquAJ4odeCX1NjJ7PpVFpcRV2Ngt6wXSACfTGBf
ISTUphF5AtjvZd4TNAkgoo4=
=CcEp
-----END PGP SIGNATURE-----

--kaF1vgn83Aa7CiXN--
