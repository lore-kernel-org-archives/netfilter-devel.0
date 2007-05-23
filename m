From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: Re: problems applying ipset patch
Date: Wed, 23 May 2007 11:02:19 +0200
Message-ID: <1179910939.18674.46.camel@henriknordstrom.net>
References: <4653F176.4040604@gmail.com>
	<1179908784.18674.39.camel@henriknordstrom.net>
	<4654006D.9050704@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-GgcazethGWPhnbUA7ggh"
Cc: netfilter-devel@lists.netfilter.org
To: Andrea <andang76@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4654006D.9050704@gmail.com>
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


--=-GgcazethGWPhnbUA7ggh
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

ons 2007-05-23 klockan 10:50 +0200 skrev Andrea:
> Henrik Nordstrom ha scritto:
>=20
> >=20
> > Which kernel version?
>=20
>=20
> In the second try used linux-2.6.16.51.tar from www.kernel.org and=20
> patch-o-matic-ng-20070521

Try with a newer kernel. There is more than a year difference between
your kernel and your pom-ng release.

Also make sure CONFIG_NETFILTER_XTABLES is enabled in your kernel
config.

Regards
Henrik

--=-GgcazethGWPhnbUA7ggh
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Detta =?ISO-8859-1?Q?=E4r?= en digitalt signerad
	meddelandedel

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iQCVAwUARlQDGENPQ5Kbx8daAQLfJgP+Jb7Pza+HjYcA3c9TyjJSmxxNsFswL2rH
Nl1HqIySXwLYvS90wKXDoDOvuyqUIz8jisg1ydO8t9x4wcKJu6IZFZQiAY/GahMh
ft1bTlt53s4D50skDX1auKMDpPwYpX1gHG1FzZCdTAYX9c/KT2tQfF/mSVs5kATR
CSdswWIWZhQ=
=pD3S
-----END PGP SIGNATURE-----

--=-GgcazethGWPhnbUA7ggh--
