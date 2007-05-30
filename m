From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: Re: [RFC][PATCH] optimise iptables interface matching
Date: Wed, 30 May 2007 03:34:06 +0200
Message-ID: <1180488846.6505.310.camel@henriknordstrom.net>
References: <465528CB.4020108@snapgear.com>
	<200705250044.l4P0i3f8007580@toshiba.co.jp>	<4656342A.5040202@snapgear.com>
	<4657FBD4.80506@trash.net>
	<1180381991.6505.46.camel@henriknordstrom.net>
	<465B72C0.5000907@snapgear.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-OPoikC3wnCcst5/h8t73"
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: Philip Craig <philipc@snapgear.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <465B72C0.5000907@snapgear.com>
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


--=-OPoikC3wnCcst5/h8t73
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

tis 2007-05-29 klockan 10:24 +1000 skrev Philip Craig:
>=20
> I'll try that, but that will also prevent loop unrolling if you're
> using -funroll-loops.  Not sure if any builds use this, but the
> comment in the code implies some do.

My GCC unrolls that loop just fine...

x86_64 gcc (GCC) 4.1.1 20070105 (Red Hat 4.1.1-51)

Here is a corrected version of the for loop:

for (i =3D 0, ret =3D 0;  i < IFNAMSIZ/sizeof(unsigned long) && ((const uns=
igned long *)ipinfo->outiface_mask)[i]; i++) {


but for modern 64-bit CPUs I suspect the original is actually fastest as
IFNAMSIZ is only 16 bytes and fits in two parallel 64-bit operations..

Regards
Henrik



--=-OPoikC3wnCcst5/h8t73
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Detta =?ISO-8859-1?Q?=E4r?= en digitalt signerad
	meddelandedel

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iQCVAwUARlzUjENPQ5Kbx8daAQJhyQP9HIAPgFi9vmkprwcmzlzVOxdRezccjyjZ
r9Q6GEkPvQJ+ceRIF1T+ws13s9aFWKJi9xbTJPW0JPOtdi0fAf3DV8owCoiaP9rB
cpTlJZLgfpqC8J7VxTOmoa3d8G4LsJHoJMJMzIDhwvd11tcqX4OCrrmX2Gm1vdwF
bR3EQNX03tw=
=uzEF
-----END PGP SIGNATURE-----

--=-OPoikC3wnCcst5/h8t73--
