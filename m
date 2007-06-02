From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: Re: [PATCH] add direction match to conntrack match
Date: Sat, 02 Jun 2007 13:34:42 +0200
Message-ID: <1180784082.27259.38.camel@henriknordstrom.net>
References: <46604886.4080400@ufomechanic.net> <46604998.3050602@trash.net>
	<4660734B.3090203@ufomechanic.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-QPauCVQLJ/5Jt6Q2YEaz"
Cc: netfilter-devel@lists.netfilter.org
To: Amin Azez <azez@ufomechanic.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4660734B.3090203@ufomechanic.net>
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


--=-QPauCVQLJ/5Jt6Q2YEaz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

fre 2007-06-01 klockan 20:28 +0100 skrev Amin Azez:

> This was the neatest way I could come up with without destroying=20
> user-space compatability.

Another alternative is to create a new revision of the conntrack match
extending the flags fields to at least a 32-bit and I'd also propose
moving the NAT bits into the flags field. Requires a little more work,
but allows for a cleaner result..

See for example the MARK target for how to do this.

Regards
Henrik

--=-QPauCVQLJ/5Jt6Q2YEaz
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Detta =?ISO-8859-1?Q?=E4r?= en digitalt signerad
	meddelandedel

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iQCVAwUARmFV0ENPQ5Kbx8daAQLs4gQAi5wylsPF19a973vPP9huY0VuhL6JHS9h
vUm1H/qXjKqLFK62N0bffjlXRixEv1Xx3pgDf3I60OIb8IsQzd9Q+mxNhKbrwFzD
i7GuhKQGcaV9sCa3YueE8gkbaWtKQY2mN2sTJSD+JZ5QW5+wrG9iOQ81fyo0HUZM
CzU1lK/m3oI=
=PCG9
-----END PGP SIGNATURE-----

--=-QPauCVQLJ/5Jt6Q2YEaz--
