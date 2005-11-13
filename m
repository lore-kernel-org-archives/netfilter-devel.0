From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] net/ipv6/netfilter/Kconfig cleanups
Date: Sun, 13 Nov 2005 11:19:22 +0100
Message-ID: <20051113101921.GK17476@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.64.0511120207340.26844@bizon.gios.gov.pl>
	<200511130820.jAD8K3hx005471@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tBhgiDt8dP1efIIJ"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Content-Disposition: inline
In-Reply-To: <200511130820.jAD8K3hx005471@toshiba.co.jp>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--tBhgiDt8dP1efIIJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 13, 2005 at 05:20:02PM +0900, Yasuyuki KOZAKAI wrote:
>=20
> Hi,
>=20
> From: Krzysztof Oledzki <olenf@ans.pl>
> Date: Sat, 12 Nov 2005 02:13:40 +0100 (CET)
>=20
> > Hello,
> >=20
> > Attached (and inlined) patch moves NF_CONNTRACK_IPV6 so both "IPv6:=20
> > Netfilter Configuration" and "IP: Netfilter Configuration" look similar.
> > It also removes unneeded CONFIG_IP6_NF_CONNTRACK.
>=20
> Thanks. But this patch generates Hunks, too. I rewrote it and it also rem=
ove
> all other linux 2.4 style configurations in comments.

thanks, applied.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--tBhgiDt8dP1efIIJ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDdxMpXaXGVTD0i/8RAu4xAKCXRqdbroKzVjBxht/6fxJuhGAYYgCfU1Q2
1uNS7ZpnevH8b2rtP/+XK54=
=Ym4h
-----END PGP SIGNATURE-----

--tBhgiDt8dP1efIIJ--
