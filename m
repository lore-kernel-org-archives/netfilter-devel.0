From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: Re: default value of nf_conntrack_tcp_timeout_close_wait
Date: Thu, 05 Apr 2007 10:54:10 +0200
Message-ID: <1175763250.19021.17.camel@henriknordstrom.net>
References: <20070404122314.GP657@kriss.csbnet.se>
	<1175691579.4008.52.camel@henriknordstrom.net>
	<4613C75B.5020707@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-zC1wxOwVEcVDuMMTf1xD"
Cc: netfilter-devel@lists.netfilter.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4613C75B.5020707@trash.net>
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


--=-zC1wxOwVEcVDuMMTf1xD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

ons 2007-04-04 klockan 17:42 +0200 skrev Patrick McHardy:

> The idea is not bad IMO, but I think it would require an additional
> timer, which pretty much kills it since that would grow struct
> ip_conntrack by quite a lot.

Should suffice with one bit I think, keeping track of which direction
last saw data and a new timeout value for "ACK_WAIT".

Packet with data (incl FIN) -> ACK_WAIT timeout
Bare ACK in opposite direction -> Actual timeout for current state

Requires "ACK_WAIT" timeout to be sufficiently large to cover retransmit
delays.

Regards
Henrik

--=-zC1wxOwVEcVDuMMTf1xD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Detta =?ISO-8859-1?Q?=E4r?= en digitalt signerad
	meddelandedel

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iQCVAwUARhS5LkNPQ5Kbx8daAQI8hQP+KzPEY/PC568r0/aKOJdpGTqUk7jikpTz
ieBb9Ri68Gd3l0F3b5Irq7p0tlNVHPlL/xuDm+SG3Yqs7Tr3jRksqXw+6mgilyiV
qvG0ThXoRSZrysosCMZQhFUobUAO0eJ1tGQZB8LMcvmitbBrb/TeGsJH4JQww5yg
b4Si5/3Qv7E=
=rmbe
-----END PGP SIGNATURE-----

--=-zC1wxOwVEcVDuMMTf1xD--
