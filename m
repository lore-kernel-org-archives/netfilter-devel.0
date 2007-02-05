From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: Re: Need an iptables module for hiding NAT.
Date: Mon, 05 Feb 2007 22:04:01 +0100
Message-ID: <1170709441.23065.27.camel@henriknordstrom.net>
References: <45C75479.3090605@arturaz.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-enEFWL0O8RfJDcCkt6mX"
Cc: netfilter-devel@lists.netfilter.org
To: =?UTF-8?Q?Art=C5=ABras_=C5=A0lajus?= <x11@arturaz.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45C75479.3090605@arturaz.net>
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


--=-enEFWL0O8RfJDcCkt6mX
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

m=C3=A5n 2007-02-05 klockan 17:59 +0200 skrev Art=C5=ABras =C5=A0lajus:

> I need iptables module which would hide NAT. It means that all traffic=20
> being routed through the machine which is running netfilter and doing=20
> routing should be seen as originating from that host.

The easiest is to proxy instead of natting..

Regards
Henrik

--=-enEFWL0O8RfJDcCkt6mX
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Detta =?ISO-8859-1?Q?=E4r?= en digitalt signerad
	meddelandedel

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iQCVAwUARcebt0NPQ5Kbx8daAQLg3AP/SKRzr/xjArbe9ErkjB0oF+y0iGzMzaXl
lkGeMmWRrbb/dR9wSrlc9ZRdLT4uR6EINpEdHLcsbz1m2p9N28sL4f3jXQVKwS+3
jOc+YQ9wPh7c8gobrKWyKLAMh5QsjzSeQ5dhIgmowiP6B8X/im3RAzmt55kYq7sI
hkl6uoPMDAA=
=gBWP
-----END PGP SIGNATURE-----

--=-enEFWL0O8RfJDcCkt6mX--
