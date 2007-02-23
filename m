From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: Re: OUTPUT DNAT AND FILTERING - scenario
Date: Fri, 23 Feb 2007 01:01:11 +0100
Message-ID: <1172188871.544.69.camel@henriknordstrom.net>
References: <885896af0702210255s3f0485a5t7420a55e1b8cea45@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-/1KIcAyu4C7WZjth3DXN"
Cc: netfilter devel <netfilter-devel@lists.netfilter.org>
To: Giacomo <delleceste@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <885896af0702210255s3f0485a5t7420a55e1b8cea45@mail.gmail.com>
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


--=-/1KIcAyu4C7WZjth3DXN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

ons 2007-02-21 klockan 11:55 +0100 skrev Giacomo:

> Finally, my question is very simple:
> why doues iptables apply the FILTER rules AFTER the OUTPUT DNAT and not
> before, when the packet still has the original destination address?

Because this is the way iptables is designed.

Simplified packet flow:

mangle -> nat DNAT -> [routing] -> filter -> nat SNAT -> mangle

To deal with this cleanly within the filter table there is the conntrack
match allowing you to filter based on connection details rather than the
packet details.

Regards
Henrik

--=-/1KIcAyu4C7WZjth3DXN
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Detta =?ISO-8859-1?Q?=E4r?= en digitalt signerad
	meddelandedel

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iQCVAwUARd4uxENPQ5Kbx8daAQLHAwP+PivdmMxZ6summvLELVI7bJjpiHQIvyEw
EFpL9eyG5Xsu8RxGbG04G5YQ24nbNONN2H+a7IoSGANzw+6qXi2lhg7iCkpD5zYE
A8WENLS/QD59lHhqySfKYrSgxHkPK18rSpVJaXyRwXRYbkeUZy3/4gvkGB73s13E
TG07vB0Rz3Q=
=X25B
-----END PGP SIGNATURE-----

--=-/1KIcAyu4C7WZjth3DXN--
