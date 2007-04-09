From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: Re: ICMP Land Attack
Date: Mon, 09 Apr 2007 16:13:23 +0200
Message-ID: <1176128003.21260.81.camel@henriknordstrom.net>
References: <007a01c77a9d$b2727c50$dd2d10ac@synapse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-13Lkr9gUB+uMj38zSxwK"
Cc: netfilter-devel@lists.netfilter.org
To: Manish Jain <manish.jain@globallogic.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <007a01c77a9d$b2727c50$dd2d10ac@synapse.com>
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


--=-13Lkr9gUB+uMj38zSxwK
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

m=C3=A5n 2007-04-09 klockan 17:23 +0530 skrev Manish Jain:

> Whether it is possible to write iptable rule saying "source ip =3D=3D des=
t ip"
> instead of specifying hard-coded values?=20

A quite trivial custom match to write if not supported by any of the
existing matches..

The addrtype match is a reasonable complex template to start from.

Regards
Henrik

--=-13Lkr9gUB+uMj38zSxwK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Detta =?ISO-8859-1?Q?=E4r?= en digitalt signerad
	meddelandedel

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iQCVAwUARhpKAENPQ5Kbx8daAQKouwQAxT62rpuUId1HsaavwDTYspWRXDMzRL1B
gKpiBfGFKWMPoDPDbcVQmSWIHRr3luSbmFjtNlABijDMBLowx87IO9xF52wf8T3E
yLxDgFp+v8PNf9+a+KetEPwanJoor2zcrTbO/TriElegV16eSLNtGgj04IB7951M
mzNbXj5JREM=
=XdeT
-----END PGP SIGNATURE-----

--=-13Lkr9gUB+uMj38zSxwK--
