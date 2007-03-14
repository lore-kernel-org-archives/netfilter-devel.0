From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: Re: dangerous? Setting mark in nat table
Date: Wed, 14 Mar 2007 11:27:28 +0100
Message-ID: <1173868048.26913.30.camel@henriknordstrom.net>
References: <et6fp4$l04$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-7DSVnlICjYxqCnueWfae"
Cc: netfilter-devel@lists.netfilter.org
To: Amin Azez <azez@ufomechanic.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <et6fp4$l04$1@sea.gmane.org>
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


--=-7DSVnlICjYxqCnueWfae
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

tis 2007-03-13 klockan 15:25 +0000 skrev Amin Azez:
> I want need to set a mark (-j MARK) in the nat table based on dnat'ing do=
ne.

Note: This mark will only apply to the first packet of the connection,
the rest bypasses the nat table as the NAT mappings have already been
set up.

> (Is this also a good time to bring up why mangle and filter should not
> be merged?)

mangle reroutes packets on certain changes such as mark. filter does
not..

Regards
Henrik

--=-7DSVnlICjYxqCnueWfae
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Detta =?ISO-8859-1?Q?=E4r?= en digitalt signerad
	meddelandedel

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iQCVAwUARffODkNPQ5Kbx8daAQJrzQQAjAhsEutSNTl87ynAN2OR3J5R9rJda9MA
F05W8v2K0fdG2BJLA+ctC3+sx8jzwp+QE0yPLOOuM6haMuHj7v9/X++W1/pLHMYS
mhmIkfdEpXzpEGKgQXIrr2L5WLB1PXzvKHkQOx4Tb1MJy6awkQNVJ360p+fdLaJ2
Fv8GItjVWHs=
=iFBl
-----END PGP SIGNATURE-----

--=-7DSVnlICjYxqCnueWfae--
