From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: Re: switch from ip_conntrack to nf_conntrack
Date: Fri, 23 Feb 2007 00:54:21 +0100
Message-ID: <1172188461.544.63.camel@henriknordstrom.net>
References: <20070221085835.173c691b@Golgotha>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-Bqt+uUreNZMfFjB2IYsX"
Cc: netfilter-devel@lists.netfilter.org
To: Thomas Mader <thezema@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070221085835.173c691b@Golgotha>
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


--=-Bqt+uUreNZMfFjB2IYsX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

ons 2007-02-21 klockan 08:58 +0100 skrev Thomas Mader:
> Hello everybody,
>=20
> we wrote a kernelspace module which uses the now deprecated
> ip_conntrack API and we are trying to switch to the new nf_conntrack
> but this seems to be a little bit more problematic than we thought
> first.
> What we want is to build a nf_conntrack_tuple to get the hash for an
> existing connection and finally the id of the connection.

Looking at your code I don't quite get why you need to build the tuple
again or ask for the conntrack hash lookup. Isn't you looking for the
conntrack associated with the packet sent to the match function? If so
just ask for it with nf_ct_get() as it's already associated with the
sk_buff and no need to look it up in the conntrack hash. To keep a
reference outside the match function scope use
nf_conntrack_get/nf_conntrack_put to maintain the lock count. While you
are inside the match function the conntrack is locked by the sk_buff.

Regards
Henrik

--=-Bqt+uUreNZMfFjB2IYsX
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Detta =?ISO-8859-1?Q?=E4r?= en digitalt signerad
	meddelandedel

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iQCVAwUARd4tKkNPQ5Kbx8daAQKNCwP+IGhhhYprsUxYsYmbtLHvgQ/oTx9yw9By
Vi7lxiYlMk9c7+nozJ3+HMcOpKIEwakZOlTJw6oysi+x6/vtkKyKmyqM18SD4H+r
u5L9hg63k4uVVNBoN2rmOt/JbxU50GlC4w6j+pLYQEDiv22Tzkg8cZldqhS4D3CZ
NB27dQlKtVo=
=7/TU
-----END PGP SIGNATURE-----

--=-Bqt+uUreNZMfFjB2IYsX--
